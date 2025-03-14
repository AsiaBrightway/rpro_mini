import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:retrofit/http.dart';
import 'package:rpro_mini/data/vos/floor_vo.dart';
import 'package:rpro_mini/data/vos/table_vo.dart';
import 'package:rpro_mini/network/responses/brand_response.dart';
import 'package:rpro_mini/network/responses/category_response.dart';
import 'package:rpro_mini/network/responses/login_response.dart';
import 'package:rpro_mini/network/responses/parse_error_logger.dart';
import 'package:rpro_mini/network/responses/post_method_response.dart';
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

  @POST(kEndPointCategories)
  @MultiPart()
  Future<PostMethodResponse?> addCategory(
      @Header(kParamAuthorization) String apiKey,
      @Body() FormData formData
      );

  @GET(kEndPointCategories)
  Future<CategoryResponse?> getCategories(@Header(kParamAuthorization) String apiKey,);

  @PUT("$kEndPointCategories/{id}")
  Future<PostMethodResponse?> updateCategoryById(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int id,
      @Body() Map<String, dynamic> body,
      );

  @POST(kEndPointSubCategories)
  Future<PostMethodResponse?> addSubCategory(
      @Header(kParamAuthorization) String apiKey,
      @Body() FormData formData
      );

  @PUT("$kEndPointSubCategories/{id}")
  Future<PostMethodResponse?> updateSubCategoryById(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int id,
      @Body() Map<String, dynamic> body,
      );

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
  Future<List<TableVo>> getTableListByFloorId(
      @Path("id") int id,
      );
}