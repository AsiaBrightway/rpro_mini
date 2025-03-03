
import 'dart:io';

import 'package:rpro_mini/data/vos/request/color_request_vo.dart';
import 'package:rpro_mini/data/vos/request/product_request_vo.dart';
import 'package:rpro_mini/data/vos/request/size_request.dart';
import '../responses/brand_response.dart';
import '../responses/category_response.dart';
import '../responses/color_response.dart';
import '../responses/login_response.dart';
import '../responses/post_method_response.dart';
import '../responses/product_response.dart';
import '../responses/size_response.dart';
import '../responses/sub_category_response.dart';

abstract class ShoppyAdminAgent{

  Future<PostMethodResponse?> addColor(String token,ColorRequestVo request);

  Future<ColorResponse?> getColors(String token,);

  Future<PostMethodResponse?> updateColor(String token,int id,ColorRequestVo request);

  Future<SizeResponse?> getSizes(String token,);

  Future<PostMethodResponse?> addSize(String token,SizeRequest request);

  Future<PostMethodResponse?> updateSizeById(String token,int id,SizeRequest request);

  Future<PostMethodResponse?> addBrand(String token,String name,String description,File? imageFile);

  Future<BrandResponse?> getBrands(String token,);

  Future<PostMethodResponse?> updateBrandById(String token,int id,String name, String description, File? imageFile);

  Future<PostMethodResponse?> addCategory(String token,String name,File? imageFile);

  Future<CategoryResponse?> getCategories(String token,);

  Future<PostMethodResponse?> updateCategoryById(String token,int id,String name,File? imageFile);

  Future<PostMethodResponse?> addSubCategory(String token,int categoryId,String subName,File? imageFile);

  Future<SubCategoryResponse?> getSubCategories(String token,);

  Future<PostMethodResponse?> updateSubCategoryById(String token,int id,int categoryId,String name,File? image);

  Future<PostMethodResponse?> addNewProduct(String token,ProductRequestVo body);

  Future<ProductResponse?> getProducts(String token,);

  Future<PostMethodResponse?> updateProductById(String token,int id,ProductRequestVo body);

  Future<LoginResponse?> adminLogin(String name, String password);
}