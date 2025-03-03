
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/data/models/shoppy_admin_model.dart';
import 'package:rpro_mini/data/vos/category_vo.dart';
import 'package:rpro_mini/ui/components/category_card.dart';
import 'package:rpro_mini/utils/helper_functions.dart';
import '../../bloc/auth_provider.dart';
import '../../utils/image_compress.dart';
import '../themes/colors.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String _token = '';
  String _refreshToken = '';
  List<CategoryVo> categoryList = [];
  final ShoppyAdminModel _model = ShoppyAdminModel();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
    getCategoryList();
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.accessToken;
    _refreshToken = authModel.refreshToken;
  }

  Future<void> _deleteBrand(int index) async{

  }

  Future<void> _addCategory(String name,String description,File? image) async{
    _model.addCategory(_token,name, image).then((onValue){
      showSuccessToast(context, onValue?.message ?? "");
      getCategoryList();
    }).catchError((onError){
      showToastMessage(context, onError.toString());
    });
  }

  ///if user don't select the image,we pass null
  Future<void> _updateCategoryById(int id,String name,String description,File? image) async{
    _model.updateCategoryById(_token, id, name,image).then((onValue){
      Navigator.pop(context);
      showSuccessToast(context, onValue?.message.toString() ?? "");
      getCategoryList();
    }).catchError((onError){
      showToastMessage(context, onError.toString());
    });
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  Future<void> getCategoryList() async {
    try {
      final onValue = await _model.getCategories(_token);
      if (mounted && categoryList != onValue) {
        setState(() {
          categoryList = onValue;
        });
      }
    } catch (error) {
      debugPrint("Error fetching brands: $error");
    }
  }

  void _editCategorySheet(int index,CategoryVo? category) {
    _showCategoryBottomSheet(context,false,category);
  }

  void _showCategoryBottomSheet(BuildContext context,bool isAdd,CategoryVo? category) {
    File? image;
    TextEditingController nameController = TextEditingController();
    TextEditingController desController = TextEditingController();
    nameController.text = category?.categoryName ?? "";

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
                      Text( isAdd ? 'Add Category' : 'Update Category',
                          style: TextStyle(color: AppColors.colorPrimary,fontFamily: 'Agdasima',fontSize: 28,fontWeight: FontWeight.w700)),
                      Padding(
                        padding: const EdgeInsets.only(top:20,bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Category Name',
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
                            ///image widget
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
                                              category?.getImageWithBaseUrl() ?? "",
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/placeholder.png',
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.contain);
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
                                /// add button
                                isAdd ? ElevatedButton.icon(
                                    onPressed: () async {
                                      if (nameController.text.isEmpty) {
                                        showToastMessage(context, 'Category name cannot be empty', isError: true);
                                        return;
                                      }
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await _addCategory(
                                          nameController.text,
                                          desController.text,
                                          image);
                                      setState(() => isLoading = false);
                                      },
                                    icon: isLoading
                                            ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(color: Colors.white,strokeWidth: 2),
                                              )
                                            : const Icon(Icons.add, color: Colors.white, size: 14),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.colorPrimary,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 32, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        label: const Text('Add', style: TextStyle(color: Colors.white))
                                )
                                    ///update button
                                    : ElevatedButton.icon(
                                        onPressed: () async {
                                          if (nameController.text.isEmpty) {
                                            showToastMessage(context, 'Category name cannot be empty', isError: true);
                                            return;
                                          }
                                          setState(() {
                                            isLoading = true;
                                          });
                                          await _updateCategoryById(category?.categoryId ?? 0, nameController.text, desController.text, image);
                                          setState(() => isLoading = false); // Hide progress
                                        },
                                    icon: isLoading
                                            ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                            : const Icon(Icons.add,
                                                color: Colors.white, size: 14),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.colorPrimary,
                                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                        label: const Text('Update', style: TextStyle(color: Colors.white),
                                        )),
                                const SizedBox(width: 30,),
                                ///cancel button
                                ElevatedButton(onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.colorPrimary,
                                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Cancel',style: TextStyle(color: Colors.white),))
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
        title: const Text('Categories',style: TextStyle(fontFamily: 'Agdasima',fontSize: 28,color: Colors.white,fontWeight: FontWeight.w700),),
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
                    padding: const EdgeInsets.only(top: 26),
                    itemCount: categoryList.length,
                    itemBuilder: (context, index){
                      return CategoryCard(
                        category: categoryList[index],
                        onEdit: () => _editCategorySheet(index,categoryList[index]),
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
            _showCategoryBottomSheet(context, true,null);
          },
          backgroundColor: Colors.deepPurple,
          tooltip: 'Add',
          shape: const CircleBorder(),
          child: const Icon(Icons.add), // Explicitly set the shape to a circle
        ),
      ),
    );
  }
}



