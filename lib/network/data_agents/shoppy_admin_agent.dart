
import 'dart:io';
import 'package:rpro_mini/data/vos/floor_vo.dart';
import 'package:rpro_mini/data/vos/request/add_order_request.dart';
import 'package:rpro_mini/network/responses/item_response.dart';
import 'package:rpro_mini/network/responses/table_response.dart';
import '../responses/add_response.dart';
import '../responses/brand_response.dart';
import '../responses/category_response.dart';
import '../responses/login_response.dart';
import '../responses/order_details_response.dart';
import '../responses/post_method_response.dart';

abstract class ShoppyAdminAgent{

  Future<PostMethodResponse?> addBrand(String token,String name,String description,File? imageFile);

  Future<BrandResponse?> getBrands(String token);

  Future<PostMethodResponse?> updateBrandById(String token,int id,String name, String description, File? imageFile);

  Future<CategoryResponse?> getCategories();

  Future<LoginResponse?> adminLogin(String name, String password);

  Future<List<FloorVo>> getFloors();

  Future<TableResponse> getTablesByFloorId(int floorId);

  Future<ItemResponse> getItemsByCategoryId(int categoryId);

  Future<ItemResponse> searchItemByName(String name);

  Future<OrderDetailsResponse> getOrderDetailsByTable(int tableId,int tableOrderValue);

  Future<AddResponse> deleteOrderItem(int id);

  Future<PostMethodResponse> addOrderItem(AddOrderRequest request);
}