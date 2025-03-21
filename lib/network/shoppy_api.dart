import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:rpro_mini/data/vos/floor_vo.dart';
import 'package:rpro_mini/network/responses/brand_response.dart';
import 'package:rpro_mini/network/responses/category_response.dart';
import 'package:rpro_mini/network/responses/item_response.dart';
import 'package:rpro_mini/network/responses/login_response.dart';
import 'package:rpro_mini/network/responses/parse_error_logger.dart';
import 'package:rpro_mini/network/responses/post_method_response.dart';
import 'package:rpro_mini/network/responses/table_response.dart';
import '../data/vos/request/color_request_vo.dart';
import '../data/vos/request/product_request_vo.dart';
import 'api_constants.dart';
part 'shoppy_api.g.dart';

@RestApi()
abstract class ShoppyApi{

  factory ShoppyApi(Dio dio) = _ShoppyApi;

  @POST("{url}$kEndPointBrands")
  Future<PostMethodResponse?> addColor(
      @Header(kParamAuthorization) String apiKey,
      @Path("url") String url,
      @Body() ColorRequestVo requestBody
      );

  @PUT("$kEndPointColors/{id}")
  Future<PostMethodResponse?> updateColorById(
      @Header(kParamAuthorization) String apiKey,
      @Path() int id,
      @Body() ColorRequestVo requestBody
      );

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

  @POST(kEndPointProducts)
  Future<PostMethodResponse?> addNewProduct(
      @Header(kParamAuthorization) String apiKey,
      @Body() ProductRequestVo body
      );

  @PUT("$kEndPointProducts/{id}")
  Future<PostMethodResponse?> updateProductById(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int id,
      @Body() ProductRequestVo body
      );

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
}