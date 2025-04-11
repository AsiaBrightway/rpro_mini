import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:rpro_mini/data/vos/floor_vo.dart';
import 'package:rpro_mini/data/vos/request/add_order_request.dart';
import 'package:rpro_mini/network/responses/add_response.dart';
import 'package:rpro_mini/network/responses/brand_response.dart';
import 'package:rpro_mini/network/responses/category_response.dart';
import 'package:rpro_mini/network/responses/item_response.dart';
import 'package:rpro_mini/network/responses/login_response.dart';
import 'package:rpro_mini/network/responses/order_details_response.dart';
import 'package:rpro_mini/network/responses/parse_error_logger.dart';
import 'package:rpro_mini/network/responses/post_method_response.dart';
import 'package:rpro_mini/network/responses/table_response.dart';
import 'api_constants.dart';

part 'shoppy_api.g.dart';

@RestApi()
abstract class ShoppyApi{

  factory ShoppyApi(Dio dio) = _ShoppyApi;

  @POST(kEndPointBrands)
  @MultiPart()
  Future<PostMethodResponse?> addBrand(
      @Header(kParamAuthorization) String apiKey,
      @Body() FormData formData
      );

  @GET(kEndPointBrands)
  Future<BrandResponse?> getBrands(@Header(kParamAuthorization) String apiKey,);

  ///@PUT method with @MultiPart and @Body() is incorrect
  @PUT("$kEndPointBrands/{id}")
  Future<PostMethodResponse?> updateBrandById(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int id,
      @Body() Map<String, dynamic> body,
      );

  @GET(kEndPointCategory)
  Future<CategoryResponse?> getCategories();

  @POST(kEndPointAdminAuth)
  Future<LoginResponse?> adminLogin(
      @Query('username') String name,
      @Query('password') String password,
      );

  @GET(kEndPointFloor)
  Future<List<FloorVo>> getFloorList();

  @GET("$kEndPointTables/{id}")
  Future<TableResponse> getTableListByFloorId(
      @Path("id") int id,
      );

  @GET("$kEndPointItem/{id}")
  Future<ItemResponse> getItemsByCategory(
      @Path("id") int id,
      );

  @GET("$kEndPointSearchName/{name}")
  Future<ItemResponse> searchItemByName(
      @Path("name") String id,
      );
  
  @GET(kEndPointGetOrder)
  Future<OrderDetailsResponse> getOrderDetailsByTable(
      @Query("tableID") int tableId,
      @Query("tableOrderValue") int orderValue
      );

  @DELETE("$kEndPointDeleteOrder/{id}")
  Future<AddResponse> deleteOrderItem(
      @Path("id") int id,
      );

  @POST(kEndPointAddOrder)
  Future<PostMethodResponse> addNewOrder(
      @Body() AddOrderRequest requestBody
      );
}