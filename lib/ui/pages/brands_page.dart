
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/data/models/shoppy_admin_model.dart';
import 'package:rpro_mini/data/vos/brand_vo.dart';
import 'package:rpro_mini/ui/components/brand_card.dart';
import 'package:rpro_mini/utils/helper_functions.dart';
import '../../bloc/auth_provider.dart';
import '../../utils/image_compress.dart';
import '../themes/colors.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({super.key});

  @override
  State<BrandsPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandsPage> {
  String _token = '';
  String _refreshToken = '';
  List<BrandVo> brandList = [];
  final ShoppyAdminModel _model = ShoppyAdminModel();

  @override
  void initState() {
    super.initState();
    _initializeData();
    getBrandList();
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.accessToken;
    _refreshToken = authModel.refreshToken;
  }

  Future<void> _deleteBrand(int index) async{

  }

  Future<void> _addBrand(String name,String description,File? image) async{
    _model.addBrand(_token,name, description, image).then((onValue){
      showSuccessToast(context, onValue?.message ?? "");
      if(mounted) {
        Navigator.of(context).pop();
      }
      getBrandList();
    }).catchError((onError){
      showToastMessage(context, onError.toString());
    });
  }

  ///if user don't select the image,we pass null
  Future<void> _updateBrandById(int id,String name,String description,File? image) async{
    _model.updateBrandsById(_token,id, name,description,image).then((onValue){
      Navigator.pop(context);
      showSuccessToast(context, onValue?.message.toString() ?? "");
      getBrandList();
    }).catchError((onError){
      showToastMessage(context, onError.toString());
    });
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  Future<void> getBrandList() async {
    try {
      final onValue = await _model.getBrands(_token);
      if (mounted && brandList != onValue) {
        setState(() {
          brandList = onValue;
        });
      }
    } catch (error) {
      debugPrint("Error fetching brands: $error");
    }
  }

  void _editColorSheet(int index,BrandVo? colorRequest) {
    _showBrandBottomSheet(context,false,colorRequest);
  }

  void _showBrandBottomSheet(BuildContext context,bool isAdd,BrandVo? brand) {
    File? image;
    TextEditingController nameController = TextEditingController();
    TextEditingController desController = TextEditingController();

    nameController.text = brand?.brandName ?? "";
    desController.text = brand?.brandDescription ?? "";

    showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      expand: false, // Start with a small height
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false, // Start with a small height
          initialChildSize: 0.7, // Initial height (70% of screen)
          maxChildSize: 0.83, // Maximum height (90% of screen)
          minChildSize: 0.3, // Minimum height (30% of screen)
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context,setState){
                return  Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text( isAdd ? 'Add Brand' : 'Update Brand',
                          style: TextStyle(color: AppColors.colorPrimary,fontFamily: 'Agdasima',fontSize: 28,fontWeight: FontWeight.w700)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Brand Name',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Loral',
                                hintStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Description',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: desController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText: 'description',
                                      hintStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            GestureDetector(
                              onTap: () async {
                                ImagePicker imagePicker = ImagePicker();
                                XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

                                if (file != null) {
                                  // Compress the image
                                  File? compressFile = await compressAndGetFile(File(file.path), file.path,96);

                                  // Update the state with the compressed file
                                  if (compressFile != null) {
                                    setState(() {
                                      image = compressFile;
                                    });
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: (image == null)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          brand?.getImageWithBaseUrl() ?? "",
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/placeholder.png',
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.contain,);
                                          })
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.file(
                                          image!,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                            return const Center(
                                                child: SizedBox(height: 80, width: 80, child: CircularProgressIndicator(color: Colors.blue))
                                            );
                                          },
                                    )),
                              )),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isAdd
                                    ? ElevatedButton.icon(
                                        onPressed: () {
                                          if (nameController.text.isEmpty) {
                                            showToastMessage(context, 'Brand name cannot be empty', isError: true);
                                            return;
                                          }
                                          _addBrand(nameController.text, desController.text, image);

                                        },
                                        icon: const Icon(Icons.add, color: Colors.white, size: 14,),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.colorPrimary,
                                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        label: const Text('Add', style: TextStyle(color: Colors.white),)
                                    )
                                    : ElevatedButton.icon(
                                        onPressed: () {
                                          if (nameController.text.isEmpty) {
                                            showToastMessage(context, 'Brand name cannot be empty', isError: true);
                                          }else{
                                            _updateBrandById(brand?.brandId ?? 0, nameController.text, desController.text,image);
                                          }
                                        },
                                        icon: const Icon(Icons.edit, color: Colors.white, size: 14),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.colorPrimary,
                                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                        label: const Text('Update', style: TextStyle(color: Colors.white),)
                                ),
                                const SizedBox(width: 30,),
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                      },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.colorPrimary,
                                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Cancel',style: TextStyle(color: Colors.white),)
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Brands',style: TextStyle(fontFamily: 'Agdasima',fontSize: 28,color: Colors.white,fontWeight: FontWeight.w700),),
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white
          ),
          onPressed: _onBackPressed,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              height: 20,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 18,right: 18),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(36),topRight: Radius.circular(36))
                ),
                child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 70,top: 26),
                    itemCount: brandList.length,
                    itemBuilder: (context, index){
                      return BrandCard(
                        brand: brandList[index],
                        onEdit: () => _editColorSheet(index,brandList[index]),
                        onDelete: () => _deleteBrand(index),
                      );
                    }
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 56.0, // Custom width
        height: 56.0, // Custom height
        child: FloatingActionButton(
          onPressed: () {
            _showBrandBottomSheet(context, true,null);
          },
          elevation: 8,
          backgroundColor: Colors.deepPurple,
          tooltip: 'Add',
          shape: const CircleBorder(),
          child: const Icon(Icons.add), // Explicitly set the shape to a circle
        ),
      ),
    );
  }
}



