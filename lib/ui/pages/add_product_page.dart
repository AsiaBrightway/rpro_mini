import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/bloc/add_product_bloc.dart';
import 'package:rpro_mini/data/vos/color_vo.dart';
import 'package:rpro_mini/data/vos/price_vo.dart';
import 'package:rpro_mini/data/vos/product_vo.dart';
import 'package:rpro_mini/ui/components/custom_add_update_button.dart';
import 'package:rpro_mini/ui/themes/colors.dart';
import 'package:rpro_mini/utils/helper_functions.dart';
import '../../bloc/auth_provider.dart';
import '../../data/vos/size_vo.dart';

class AddProductPage extends StatefulWidget {

  final ProductVo? product;
  final bool isAdd;
  const AddProductPage({super.key, required this.isAdd, required this.product});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  String _token = '';
  List<dynamic> images = [];
  bool isPromotion = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.accessToken;
    setState(() {
      if (widget.product?.images != null) {
        images.addAll(widget.product!.images!); // Add ProductImageVo objects
      }
    });
    print("Token : $_token");
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  Future<void> _onClickAddProduct(AddProductBloc bloc) async{
    final (success,errorMessage) = await bloc.addProduct(images);
    if (!mounted) return;
    if (success) {
      showSuccessToast(context,'Success');
    } else if(errorMessage != null){
      showToastMessage(context,errorMessage);
      print("Error $errorMessage");
    }
  }

  Future<void> _pickImage(int index) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        images[index] = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddProductBloc(_token,widget.product),
      builder: (context,child) {
        var bloc = context.read<AddProductBloc>();
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text('Add Product',style: TextStyle(color: Colors.white,fontFamily: 'Ubuntu')),
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: _onBackPressed,
            ),
            actions: [
              Selector<AddProductBloc,bool>(
                selector: (_,bloc) => (bloc.isLoading),
                builder: (context, isLoading,_) {
                  return Container(
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: widget.isAdd
                        ? IconButton(
                          icon: isLoading
                              ? const SizedBox(
                                width: 24, // Match typical icon size
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2.0),
                              )
                              : const Icon(Icons.edit_note_rounded, color: Colors.black87,),
                                onPressed: () {
                                  _onClickAddProduct(bloc);
                                },
                        )
                        : IconButton(
                            icon: isLoading
                                ? const SizedBox(
                                  width: 24, // Match typical icon size
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2.0),
                                )
                                : const Icon(Icons.edit_note_rounded, color: Colors.black87,),
                                  onPressed: () {
                                    bloc.updateProduct(context);
                                  },
                          )
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 16,left: 26),
                      child: Text(
                        'Product Name',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ///product name input form
                Selector<AddProductBloc,(String,String?)>(
                  selector: (context,bloc) => (bloc.productName,bloc.nameError),
                  builder: (context,data,_){
                    return Container(
                      decoration: BoxDecoration(
                        color:  Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border : Border.all(width: 0.5,color: Colors.grey)
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextFormField(
                        controller: TextEditingController(text: bloc.productName),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: '',
                            errorText: data.$2,
                            errorStyle: const TextStyle(fontFamily: 'Ubuntu'),
                            hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8),
                            ),
                        ),
                        onChanged: (value) => bloc.updateProductName(value),
                      ),
                    );
                  },
                ),
                /// image list
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 100,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5, // Fixed to 5 image slots
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            if (images[index] == null) {
                              // If no image, open image picker
                              _pickImage(index);
                            } else {
                              // If image exists, show delete/update dialog
                              _showImageOptionsBottomSheet(context, index);
                            }
                          },
                          child: Container(
                            width: 90,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: images[index] == null
                                ? const Center(
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.grey,
                                size: 40,
                              ),
                            )
                                : images[index] is String
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                images[index], // Network image URL
                                fit: BoxFit.cover,
                              ),
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                images[index], // Local image file
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8,left: 26,bottom: 4),
                      child: Text(
                        'Description',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                      ),
                    ),
                  ],
                ),
                /// product description input form
                Selector<AddProductBloc,String?>(
                  selector: (context,bloc) => (bloc.descriptionError),
                  builder: (context,data,_){
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 0.5, color: Colors.grey)),
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextFormField(
                            controller: TextEditingController(text: bloc.description),
                            maxLines: 4,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: '',
                              errorText: data,
                              hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                            ),
                            onChanged: (value) => bloc.updateDescription(value),
                          ),
                        );
                      }
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 16,left: 26),
                      child: Text(
                        'Brand',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                      ),
                    ),
                  ],
                ),
                ///brand dropdown
                brandListWidget(context),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 16,left: 26),
                      child: Text(
                        'Category',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                      ),
                    ),
                  ],
                ),
                ///category dropdown
                categoryListWidget(context),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 16,left: 26),
                      child: Text(
                        'Sub Category',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                      ),
                    ),
                  ],
                ),
                ///sub category list dropdown
                subCategoryListWidget(context),
                ///color,size,price
                Column(
                  children: [
                    /// add product price
                    GestureDetector(
                      onTap: (){
                        _showPriceBottomSheet(context, true, null,bloc,bloc.colorList ?? [],bloc.sizeList ?? [],(p) {
                          bloc.addPrice(p.price, p.stockQty, p.returnPoint, p.color, p.size, isPromotion, p.promotionPrice);
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 18),
                        decoration: BoxDecoration(
                          color: AppColors.colorPrimary,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24))
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 16,right: 20,bottom: 4),
                              child: Text(
                                '+ Add',
                                style: TextStyle(color: Colors.white,fontSize: 16, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 24,top: 8,bottom: 8,right: 8),
                      color: Colors.grey.shade300,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Color'),
                          Text('Size'),
                          Text('Price'),
                          Text('Qty'),
                          SizedBox(width: 10),
                          SizedBox(width: 10)
                        ],
                      ),
                    ),
                    ///price list table
                    Selector<AddProductBloc,List<PriceVo>>(
                      selector: (context,bloc) => bloc.priceList,
                      builder: (context,prices,_){
                        return Container(
                          padding: const EdgeInsets.only(left: 24,top: 8,bottom: 8,right: 8),
                          color: AppColors.colorPrimary,
                          height: 150,
                          child: ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 10,top: 16),
                              itemCount: prices.length,
                              itemBuilder: (context, index){
                                return Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(2),
                                    1: FlexColumnWidth(2),
                                    2: FlexColumnWidth(2),
                                    3: FlexColumnWidth(2),
                                    4: FlexColumnWidth(1),
                                    5: FlexColumnWidth(1),
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(left: 4,bottom: 12), child: Text(prices[index].color.colorName,style: const TextStyle(color: Colors.white),)
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 6), child: Text(prices[index].size.sizeName,style: const TextStyle(color: Colors.white))
                                        ),
                                        Padding(padding: const EdgeInsets.only(left: 8), child: Text(prices[index].price.toString(),style: const TextStyle(color: Colors.white))),
                                        Padding(padding: const EdgeInsets.only(left: 10), child: Text(prices[index].stockQty.toString(),style: const TextStyle(color: Colors.white))),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 4),
                                          child: IconButton(
                                            icon: const Icon(Icons.edit_note_rounded, color: Colors.orange),
                                            onPressed:(){
                                              _showPriceBottomSheet(
                                                  context, false, prices[index].size, bloc,bloc.colorList ?? [], bloc.sizeList ?? [], (p){
                                                    bloc.addPrice(p.price, p.stockQty, p.returnPoint, p.color, p.size, isPromotion, p.promotionPrice);
                                                  }
                                              );
                                              },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 4),
                                          child: IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                              onPressed: (){
                                                bloc.removePriceFromList(prices[index]);
                                              },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                          ),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  void _showImageOptionsBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit,color: Colors.black38,size: 20),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Update button color
                minimumSize: const Size(double.infinity, 50), // Full-width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await _pickImage(index); // Update the image
              },
              label: const Text(
                'Update',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete,color: Colors.black38),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Delete button color
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() {
                  images[index] = null; // Delete the image
                });
                Navigator.pop(context);
              },
              label: const Text(
                'Delete',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.cancel,color: Colors.black38,size: 20),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // Cancel button color
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              label: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPriceBottomSheet(
      BuildContext context,
      bool isAdd,SizeVo? size,
      AddProductBloc bloc,
      List<ColorVo> colors,
      List<SizeVo> sizes,
      Function(PriceVo) onPriceAdded)
  {
    TextEditingController priceController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController pointController = TextEditingController();
    TextEditingController promotionPriceController = TextEditingController();
    ColorVo? selectedColorVo;
    SizeVo? selectedSizeVo;
    String? selectedColor;
    String? selectedSize;

    quantityController.text = size?.sizeName ?? "";
    priceController.text = size?.sizeName ?? "";
    pointController.text = size?.sizeName ?? "";
    promotionPriceController.text = size?.sizeName ?? "";

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true, // Start with a small height
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false, // Start with a small height
          initialChildSize: 0.85, // Initial height (70% of screen)
          maxChildSize: 0.85, // Maximum height (90% of screen)
          minChildSize: 0.3, // Minimum height (30% of screen)
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context,setState){
                return Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom, // Push UI above keyboard
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(isAdd ? 'Add Product Price' : 'Update Product Price',
                            style: TextStyle(color: AppColors.colorPrimary,fontFamily: 'Agdasima',fontSize: 28,fontWeight: FontWeight.w700)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Text(
                                  'Price',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                                ),
                              ),
                              TextFormField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'xxx',
                                  hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 4.0,top: 16),
                                child: Text(
                                  'Stock Quantity',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'xxx',
                                  hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 4.0,top: 16),
                                child: Text(
                                  'Points',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: pointController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'xxx',
                                  hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 4.0,top: 16),
                                child: Text(
                                  'Color',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                                ),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  value: selectedColor,
                                  hint: const Text(
                                    'Choose Color',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  items: colors.map((ColorVo value) {
                                    return DropdownMenuItem<String>(
                                      value: value.colorName,
                                      child: Text(value.colorName,style: TextStyle(
                                          overflow: TextOverflow.ellipsis,color: Theme.of(context).colorScheme.onSurface
                                      )),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedColor = newValue!;
                                      selectedColorVo = colors.firstWhere((company) => company.colorName == newValue);
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
                                padding: EdgeInsets.only(left: 4.0,top: 16),
                                child: Text(
                                  'Size',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                                ),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  value: selectedSize,
                                  hint: const Text(
                                    'Select Size',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  items: sizes.map((SizeVo value) {
                                    return DropdownMenuItem<String>(
                                      value: value.sizeName,
                                      child: Text(value.sizeName,style: TextStyle(
                                          overflow: TextOverflow.ellipsis,color: Theme.of(context).colorScheme.onSurface
                                      )),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedSize = newValue!;
                                      selectedSizeVo = sizes.firstWhere((size) => size.sizeName == newValue);
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
                              const SizedBox(height: 8),
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Is Promotion', style: TextStyle(fontFamily: 'Ubuntu')),
                                value: isPromotion,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isPromotion = value!;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                                side: const BorderSide(color: Colors.grey),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 4.0,top: 12),
                                child: Text(
                                  'Promotion Price',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                                ),
                              ),
                              TextFormField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '12345',
                                  hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isAdd
                                ? CustomAddUpdateButton(
                                    isAdd: isAdd,
                                    onPressed: () async {
                                      String price = priceController.text;
                                      String quantity = quantityController.text;
                                      String points = pointController.text;
                                      String? promotionPrice= promotionPriceController.text;
                                      if(selectedSizeVo != null && selectedColorVo != null){
                                        Navigator.pop(context);
                                        onPriceAdded(PriceVo(selectedSizeVo!, selectedColorVo!, price, quantity, points, isPromotion ? 1 : 0, promotionPrice));
                                      }
                                      else{
                                        showToastMessage(context, 'size is require');
                                      }
                                    },
                                )
                                : CustomAddUpdateButton(
                                    isAdd: isAdd,
                                    onPressed: () {

                                    },
                                ),
                            const SizedBox(width: 30),
                            ElevatedButton(
                                onPressed: (){
                                  Navigator.pop(context);
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
                );
              },
            );
          },
        );
      },
    );
  }

  Widget categoryListWidget(BuildContext context){
    var bloc = context.read<AddProductBloc>();

    void handleOptionSelected(String selectedOption) {
      bloc.selectedCategory = selectedOption;
    }

    return GestureDetector(
      onTap: (){
        showCategoryDialog(context,handleOptionSelected);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24,vertical: 4),
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Selector<AddProductBloc, String?>(
                selector: (context, bloc) => bloc.selectedCategory,
                builder: (context, category, _) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: (category != null)
                        ? Text(category,style: const TextStyle(fontSize: 13,color: Colors.black,fontFamily: 'Ubuntu'))
                        : const Text('St',style: TextStyle(fontSize: 13,color: Colors.black,fontFamily: 'Ubuntu')),
                  );
                }),
            const Icon(Icons.arrow_drop_down_sharp)
          ],
        ),
      ),
    );
  }

  Widget subCategoryListWidget(BuildContext context){
    var bloc = context.read<AddProductBloc>();

    void handleOptionSelected(String selectedOption) {
      bloc.selectedSubCategory = selectedOption;
    }

    return GestureDetector(
      onTap: (){
        showSubCategoryDialog(context,handleOptionSelected);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24,vertical: 4),
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Selector<AddProductBloc, String?>(
                selector: (context, bloc) => bloc.selectedSubCategory,
                builder: (context, category, _) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: (category != null)
                        ? Text(category,style: const TextStyle(fontSize: 13,color: Colors.black,fontFamily: 'Ubuntu'))
                        : const Text('St',style: TextStyle(fontSize: 13,color: Colors.black,fontFamily: 'Ubuntu')),
                  );
                }),
            const Icon(Icons.arrow_drop_down_sharp)
          ],
        ),
      ),
    );
  }

  Widget brandListWidget(BuildContext context){

    var bloc = context.read<AddProductBloc>();

    void handleOptionSelected(String selectedOption) {
      bloc.selectedBrand = selectedOption;
    }

    return GestureDetector(
      onTap: (){
        showBrandDialog(context,handleOptionSelected);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24,vertical: 4),
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),

            borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Selector<AddProductBloc, String?>(
              builder: (context, brand, _) {
                return Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: (brand != null)
                      ? Text(brand,style: const TextStyle(fontSize: 13,color: Colors.black,fontFamily: 'Ubuntu'))
                      : const Text('st', style: TextStyle(color: Colors.black,fontSize: 13, fontFamily: 'Ubuntu')),
                );
              },
              selector: (context, bloc) => bloc.selectedBrand,
            ),
            const Icon(Icons.arrow_drop_down_sharp)
          ],
        ),
      ),
    );
  }

  Widget colorListWidget(BuildContext context,AddProductBloc bloc){

    void handleOptionSelected(String selectedOption) {
      setState(() {

      });
    }

    return ChangeNotifierProvider.value(
      value: bloc,
      child: GestureDetector(
        onTap: (){
          showColorListDialog(context,handleOptionSelected,bloc.colorList ?? []);
        },
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Selector<AddProductBloc, String?>(
                  selector: (context, bloc) => bloc.selectedColor,
                  builder: (context, category, _) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: (category != null)
                          ? Text(category,style: const TextStyle(fontSize: 13,color: Colors.black,fontFamily: 'Ubuntu'))
                          : const Text('St',style: TextStyle(fontSize: 13,color: Colors.black,fontFamily: 'Ubuntu')),
                    );
                  }),
              const Icon(Icons.arrow_drop_down_sharp)
            ],
          ),
        ),
      ),
    );
  }

  void showBrandDialog(BuildContext context, Function(String) onOptionSelected) {
    var mBrandList = context.read<AddProductBloc>().brandList;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text(
            'Choose Brand',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: mBrandList?.length ?? 0,
                itemBuilder: (context, index) {
                  final brand = mBrandList?[index];
                  return SimpleDialogOption(
                    onPressed: () {
                      onOptionSelected(brand?.brandName ?? '');
                      Navigator.pop(dialogContext);
                    },
                    child: Text(
                      brand?.brandName ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void showCategoryDialog(BuildContext context, Function(String) onOptionSelected) {
    var mCategoryList = context.read<AddProductBloc>().categoryList;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text(
            'Choose Brand',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: mCategoryList?.length ?? 0,
                itemBuilder: (context, index) {
                  final category = mCategoryList?[index];
                  return SimpleDialogOption(
                    onPressed: () {
                      onOptionSelected(category?.categoryName ?? '');
                      Navigator.pop(dialogContext);
                    },
                    child: Text(
                      category?.categoryName ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void showSubCategoryDialog(BuildContext context, Function(String) onOptionSelected) {
    var mSubCategoryList = context.read<AddProductBloc>().subCategoryList;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text(
            'Choose Brand',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: mSubCategoryList?.length ?? 0,
                itemBuilder: (context, index) {
                  final category = mSubCategoryList?[index];
                  return SimpleDialogOption(
                    onPressed: () {
                      onOptionSelected(category?.subCategoryName ?? '');
                      Navigator.pop(dialogContext);
                    },
                    child: Text(
                      category?.subCategoryName ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void showColorListDialog(BuildContext context, Function(String) onOptionSelected,List<ColorVo> colorList) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text(
            'Choose Color',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: colorList.length,
                itemBuilder: (context, index) {
                  final color = colorList[index];
                  return SimpleDialogOption(
                    onPressed: () {
                      onOptionSelected(color.colorName);
                      Navigator.pop(dialogContext);
                    },
                    child: Text(
                      color.colorName,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

