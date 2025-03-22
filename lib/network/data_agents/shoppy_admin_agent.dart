
import 'dart:io';

import 'package:rpro_mini/data/vos/floor_vo.dart';
import 'package:rpro_mini/data/vos/request/color_request_vo.dart';
import 'package:rpro_mini/data/vos/request/product_request_vo.dart';
import 'package:rpro_mini/network/responses/item_response.dart';
import 'package:rpro_mini/network/responses/table_response.dart';
import '../responses/brand_response.dart';
import '../responses/category_response.dart';
import '../responses/login_response.dart';
import '../responses/order_details_response.dart';
import '../responses/post_method_response.dart';

abstract class ShoppyAdminAgent{

  Future<PostMethodResponse?> updateColor(String token,int id,ColorRequestVo request);

  Future<PostMethodResponse?> addBrand(String token,String name,String description,File? imageFile);

  Future<BrandResponse?> getBrands(String token,);

  Future<PostMethodResponse?> updateBrandById(String token,int id,String name, String description, File? imageFile);

  Future<CategoryResponse?> getCategories();

  Future<PostMethodResponse?> addNewProduct(String token,ProductRequestVo body);

  Future<PostMethodResponse?> updateProductById(String token,int id,ProductRequestVo body);

  Future<LoginResponse?> adminLogin(String name, String password);

  Future<List<FloorVo>> getFloors();

  Future<TableResponse> getTablesByFloorId(int floorId);

  Future<ItemResponse> getItemsByCategoryId(int categoryId);

  Future<ItemResponse> searchItemByName(String name);

  Future<OrderDetailsResponse> getOrderDetailsByTable(int tableId,int tableOrderValue);
}