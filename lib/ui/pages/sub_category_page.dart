import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/data/models/shoppy_admin_model.dart';
import 'package:rpro_mini/data/vos/category_vo.dart';
import 'package:rpro_mini/ui/components/sub_category_card.dart';
import 'package:rpro_mini/utils/helper_functions.dart';
import '../../bloc/auth_provider.dart';
import '../../data/vos/sub_category_vo.dart';
import '../../utils/image_compress.dart';
import '../themes/colors.dart';

class SubCategoryPage extends StatefulWidget {
  const SubCategoryPage({super.key});

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  List<CategoryVo> categoryList = [];
  List<SubCategoryVo> subCategoryList = [];
  final ShoppyAdminModel _model = ShoppyAdminModel();
  int categoryId = 0;
  bool isLoading = false;
  String _token = '';
  String _refreshToken = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
    getCategoryList();
    getSubCategoryList();
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.accessToken;
    _refreshToken = authModel.refreshToken;
  }

  Future<void> _deleteSubCategory(int index) async{

  }

  Future<void> _addSubCategory(String name,File? image) async{
    _model.addSubCategory(_token,categoryId,name, image).then((onValue){
      if (!mounted) return;
      Navigator.pop(context);
      showSuccessToast(context, onValue?.message ?? "");
    }).catchError((onError){
      showToastMessage(context, onError.toString());
    });
  }

  ///if user don't select the image,we pass null
  Future<void> _updateSubCategoryById(int id,int categoryId,String name,File? image) async{
    _model.updateSubCategoryById(_token,id,categoryId, name,image).then((onValue){
      if (!mounted) return;
      Navigator.pop(context);
      showSuccessToast(context, onValue?.message.toString() ?? "");
      getSubCategoryList();
    }).catchError((onError){
      showScaffoldMessage(context, onError.toString());
    });
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  Future<void> getCategoryList() async {
    try {
      final onValue = await _model.getCategories(_token,);
      if (mounted && categoryList != onValue) {
        setState(() {
          categoryList = onValue;
        });
      }
    } catch (error) {
      debugPrint("Error fetching brands: $error");
    }
  }

  Future<void> getSubCategoryList() async{
    try {
      final onValue = await _model.getSubCategories(_token);
      if (mounted && subCategoryList != onValue) {
        setState(() {
          subCategoryList = onValue;
        });
      }
    } catch (error) {
      debugPrint("Error fetching brands: $error");
    }
  }

  void _editSubCategorySheet(int index,SubCategoryVo? subCategory) {
    _showSubCategoryBottomSheet(context,false,subCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sub Categories',style: TextStyle(fontFamily: 'Agdasima',fontSize: 28,color: Colors.white,fontWeight: FontWeight.w700),),
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
                    itemCount: subCategoryList.length,
                    itemBuilder: (context, index){
                      return SubCategoryCard(
                        subCategory: subCategoryList[index],
                        onEdit: () => _editSubCategorySheet(index,subCategoryList[index]),
                        onDelete: () => _deleteSubCategory(index),
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
            _showSubCategoryBottomSheet(context, true,null);
          },
          backgroundColor: Colors.deepPurple,
          tooltip: 'Add',
          shape: const CircleBorder(),
          child: const Icon(Icons.add), // Explicitly set the shape to a circle
        ),
      ),
    );
  }

  void _showSubCategoryBottomSheet(BuildContext context,bool isAdd,SubCategoryVo? subCategory) {
    File? image;
    TextEditingController nameController = TextEditingController();
    String? selectedCategory;
    if(subCategory != null){
      selectedCategory = subCategory.category?.categoryName;
    }
    nameController.text = subCategory?.subCategoryName ?? "";

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
                      Text( isAdd ? 'Add Sub Category' : 'Update Sub Category',
                          style: TextStyle(color: AppColors.colorPrimary,fontFamily: 'Agdasima',fontSize: 28,fontWeight: FontWeight.w700)),
                      Padding(
                        padding: const EdgeInsets.only(top:20,bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0,bottom: 8),
                              child: Text(
                                'Category Name',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                value: selectedCategory,
                                hint: const Text(
                                  'Choose Category',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                items: categoryList.map((CategoryVo value) {
                                  return DropdownMenuItem<String>(
                                    value: value.categoryName,
                                    child: Text(value.categoryName,style: TextStyle(
                                        overflow: TextOverflow.ellipsis,color: Theme.of(context).colorScheme.onSurface
                                    ),),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCategory = newValue!;
                                    CategoryVo category = categoryList.firstWhere((company) => company.categoryName == newValue);
                                    categoryId = category.categoryId;
                                  });
                                },
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  scrollbarTheme: const ScrollbarThemeData(
                                    radius: Radius.circular(20),
                                  ),
                                ),
                                buttonStyleData: ButtonStyleData(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Colors.grey.shade50,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  height: 50,
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                  iconSize: 22,
                                  iconEnabledColor: Colors.black,
                                  iconDisabledColor: Colors.grey,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0,top: 18),
                              child: Text(
                                'Sub Category Name',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,fontFamily: 'Ubuntu'),
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
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
                                            subCategory?.getImageWithBaseUrl() ?? "",
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
                                isAdd
                                    ? ElevatedButton.icon(
                                      onPressed: isLoading
                                          ? null
                                          : () async {
                                            if(nameController.text.isEmpty){
                                              showToastMessage(context, 'Sub Category cannot be empty');
                                              return;
                                            }
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await _addSubCategory(nameController.text, image);
                                            setState(() => isLoading = false);
                                          },
                                      icon: isLoading
                                          ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                          )
                                          : const Icon(Icons.add, color: Colors.white, size: 14),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.colorPrimary,
                                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      label: const Text('Add', style: TextStyle(color: Colors.white))
                                    )
                                    : ElevatedButton.icon(
                                        onPressed: isLoading
                                            ? null
                                            : () async {
                                              if(nameController.text.isEmpty){
                                                showToastMessage(context, 'Sub Category cannot be empty');
                                                return;
                                              }
                                              setState(() => isLoading = true);
                                              await _updateSubCategoryById(subCategory!.subCategoryId,categoryId,nameController.text, image);
                                              setState(() => isLoading = false);
                                            },
                                        icon: isLoading
                                            ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                              )
                                            : const Icon(Icons.add, color: Colors.white, size: 14),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.colorPrimary,
                                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                        label: const Text('Update', style: TextStyle(color: Colors.white))
                                    ),
                                const SizedBox(width: 30),
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
}



