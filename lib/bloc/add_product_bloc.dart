
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:rpro_mini/data/models/shoppy_admin_model.dart';
import 'package:rpro_mini/data/vos/category_vo.dart';
import 'package:rpro_mini/data/vos/color_vo.dart';
import 'package:rpro_mini/data/vos/request/price_request_vo.dart';
import 'package:rpro_mini/data/vos/request/product_image_request.dart';
import 'package:rpro_mini/data/vos/request/product_request_vo.dart';
import 'package:rpro_mini/data/vos/size_vo.dart';
import 'package:rpro_mini/data/vos/sub_category_vo.dart';
import 'package:rpro_mini/utils/helper_functions.dart';
import '../data/vos/brand_vo.dart';
import '../data/vos/price_vo.dart';

class AddProductBloc extends ChangeNotifier{
  final ShoppyAdminModel _model = ShoppyAdminModel();
  int productId = 0;
  List<BrandVo>? brandList;
  List<ColorVo>? colorList;
  List<PriceVo> priceList = [];
  final List<PriceRequestVo> _priceRequestList = [];
  List<SizeVo>? sizeList;
  List<CategoryVo>? categoryList;
  List<SubCategoryVo>? subCategoryList;
  String _productName = '';
  String _description = '';
  String? _selectedBrand;
  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _selectedSizeName;
  String? _selectedColor;
  String _token = '';
  String? _nameError;
  String? _descriptionError;
  bool _isLoading = false;
  bool _isSuccess = false;

  bool get isSuccess => _isSuccess;
  bool get isLoading => _isLoading;
  String? get nameError => _nameError;
  String? get descriptionError => _descriptionError;
  String get description => _description;
  String get productName => _productName;
  String? get selectedBrand => _selectedBrand;
  String? get selectedSubCategory => _selectedSubCategory;
  String? get selectedCategory => _selectedCategory;
  String? get selectedSizeName => _selectedSizeName;
  String? get selectedColor => _selectedColor;

  ///constructor
  AddProductBloc(String token,product){
    if(product != null){
      productId = product.productId;
      _productName = product.productName;
      _description = product.description;
      selectedBrand = product.brand.brandName;
      selectedCategory = product.category.categoryName;
      selectedSubCategory = product.subCategory.subCategoryName;
      priceList = product.prices ?? [];
      _priceRequestList.addAll(
        priceList.map((price) => PriceRequestVo(
          sizeId: price.size.sizeId.toString(),
          colorId: price.color.colorId.toString(),
          price: double.parse(price.price),
          stockQty: int.parse(price.stockQty),
          returnPoints: int.parse(price.returnPoint),
          isPromotion: price.isPromotion == 1,
        )),
      );
      notifyListeners();
    }
    _token = token;
    _model.getBrands(token).then((onValue){
      brandList = onValue;
      notifyListeners();
    }).catchError((onError){

    });

    _model.getCategories(token).then((onValue){
      categoryList = onValue;
      notifyListeners();
    }).catchError((onError){

    });
    _model.getSubCategories(token).then((onValue){
      subCategoryList = onValue;
      notifyListeners();
    }).catchError((onError){

    });
    _model.getColors(token).then((onValue){

    }).catchError((onError){

    });
    getColorList();
    getSizeList();
  }

  set selectedSizeName(String? value) {
    _selectedSizeName = value;
    notifyListeners();
  }

  set selectedBrand(String? value) {
    _selectedBrand = value;
    notifyListeners();
  }

  set selectedSubCategory(String? value) {
    _selectedSubCategory = value;
    notifyListeners();
  }

  set selectedCategory(String? value) {
    _selectedCategory = value;
    notifyListeners();
  }

  void addPrice(
      String price,String quantity,String points,ColorVo colorVo,SizeVo sizeVo,bool isPromotion,String? promotionPrice)
  {
    _priceRequestList.add(
        PriceRequestVo(
            sizeId: sizeVo.sizeId.toString(),
            colorId: colorVo.colorId.toString(),
            price: double.parse(price),
            stockQty: int.parse(quantity),
            returnPoints: int.parse(points),
            isPromotion: isPromotion)
    );
    List<PriceVo> updatedList = List.from(priceList);
    updatedList.add(
      PriceVo(sizeVo, colorVo, price, quantity, points.toString(), isPromotion ? 1 : 0, promotionPrice),
    );

    priceList = updatedList;
    notifyListeners();
  }

  void removePriceFromList(PriceVo price){
    // Remove from _priceRequestList if needed
    _priceRequestList.removeWhere((priceRequest) =>
    priceRequest.sizeId == price.size.sizeId.toString() && priceRequest.colorId == price.color.colorId.toString());

    // Remove from priceList
    List<PriceVo> updatedList = priceList.where((priceVo) =>
    priceVo.size.sizeId != price.size.sizeId || priceVo.color.colorId != priceVo.color.colorId).toList();
    priceList = updatedList;
    notifyListeners();
  }

  Future<(bool,String?)> addProduct(List<dynamic> images) async{
      // Reset previous state
      _nameError = null;
      _descriptionError = null;
      _isSuccess = false;
      notifyListeners();
      // Validation
      if (_productName.isEmpty) {
        _nameError = "Product name is required";
        _isLoading = false;
        notifyListeners();
        return (false,null);
      }
      if (_description.isEmpty) {
        _descriptionError = "Description is required";
        _isLoading = false;
        notifyListeners();
        return (false,null);
      }

      _isLoading = true;
      notifyListeners();

      try {
        final brandId = brandList?.firstWhere(
              (category) => category.brandName == _selectedBrand,
          orElse: () => throw Exception('Brand not found'),
        ).brandId;
        final subCategoryId = subCategoryList?.firstWhere(
              (sub) => sub.subCategoryName == _selectedSubCategory,
          orElse: () => throw Exception('Subcategory not found'),
        ).subCategoryId;

        List<ProductImageRequest>? requests = [];
        if(images.isNotEmpty){
          try {
            for (int i = 0; i < images.length; i++) {
              if (images[i] != null) {
                final bytes = await images[i]!.readAsBytes(); // Read image bytes
                requests.add(ProductImageRequest(base64Encode(bytes)));// Convert to Base64
              }
            }
          } catch (e) {
            _isLoading = false;
            notifyListeners();
            return (false, "Failed to convert images to Base64 $e");
          }
        }

        var product = ProductRequestVo(
            subCategoryId!,
            brandId!,
            productName,
            description,
            _priceRequestList,
            requests
        );
        await _model.addNewProduct(_token, product);
        _isLoading = false;
        _isSuccess = true;
        notifyListeners();
        return (true,null);
      } catch (e) {
        _isLoading = false;
        _isSuccess = false;
        notifyListeners();
        return (false, e.toString());
      }
  }

  Future<void> updateProduct(BuildContext context) async{
    _isLoading = true;
    _nameError = null;
    _descriptionError = null;
    _isSuccess = false;
    notifyListeners();
    // Validation

    if (_productName.isEmpty) {
      _nameError = "Product name is required";
      _isLoading = false;
      notifyListeners();
    }
    if (_description.isEmpty) {
      _descriptionError = "Description is required";
      _isLoading = false;
      notifyListeners();
    }

    _isLoading = true;
    notifyListeners();

    final brandId = brandList?.firstWhere(
          (category) => category.brandName == _selectedBrand,
      orElse: () => throw Exception('Category not found'),
    ).brandId;
    final subCategoryId = subCategoryList?.firstWhere(
          (sub) => sub.subCategoryName == _selectedSubCategory,
      orElse: () => throw Exception('Subcategory not found'),
    ).subCategoryId;

    var product = ProductRequestVo(
        subCategoryId!,
        brandId!,
        _productName,
        _description,
        _priceRequestList,
        null
    );
    _model.updateProductById(_token, productId, product).then((onValue){
      _isLoading = false;
      _isSuccess = true;
      notifyListeners();
      showSuccessToast(context, onValue?.message ?? 'Product Update Success');
    }).catchError((onError){
      _isLoading = false;
      _isSuccess = false;
      notifyListeners();
      showToastMessage(context, onError.toString());
    });
  }

  Future<void> getSizeList() async{
    _model.getSizes(_token).then((onValue){
      sizeList = onValue;
      notifyListeners();
    }).catchError((onError){

    });
  }

  set nameError(String? value) {
    _nameError = value;
  }

  Future<void> getColorList() async{
    _model.getColors(_token).then((onValue){
      colorList = onValue;
      notifyListeners();
    }).catchError((onError){

    });
  }

  void updateProductName(String value){
    _productName = value;
    notifyListeners();
  }

  void updateDescription(String value){
    _description = value;
    notifyListeners();
  }

  set selectedColor(String? value) {
    _selectedColor = value;
    notifyListeners();
  }

  set descriptionError(String? value) {
    _descriptionError = value;
  }
}