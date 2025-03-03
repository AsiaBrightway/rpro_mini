
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:rpro_mini/data/vos/request/size_request.dart';
import 'package:rpro_mini/fcm/access_firebase_token.dart';
import 'package:rpro_mini/network/responses/brand_response.dart';
import 'package:rpro_mini/network/responses/category_response.dart';
import 'package:rpro_mini/network/responses/color_response.dart';
import 'package:rpro_mini/network/responses/login_response.dart';
import 'package:rpro_mini/network/responses/parse_error_logger.dart';
import 'package:rpro_mini/network/responses/post_method_response.dart';
import 'package:rpro_mini/network/responses/product_response.dart';
import 'package:rpro_mini/network/responses/size_response.dart';
import 'package:rpro_mini/network/responses/sub_category_response.dart';
import '../data/vos/request/color_request_vo.dart';
import '../data/vos/request/product_request_vo.dart';
import 'api_constants.dart';
part 'shoppy_api.g.dart';

@RestApi(baseUrl: kBaseUrl)
abstract class ShoppyApi{

  factory ShoppyApi(Dio dio) = _ShoppyApi;

  @POST(kEndPointColors)
  Future<PostMethodResponse?> addColor(
      @Header(kParamAuthorization) String apiKey,
      @Body() ColorRequestVo requestBody
      );

  @PUT("$kEndPointColors/{id}")
  Future<PostMethodResponse?> updateColorById(
      @Header(kParamAuthorization) String apiKey,
      @Path() int id,
      @Body() ColorRequestVo requestBody
      );

  @GET(kEndPointColors)
  Future<ColorResponse?> getColors(@Header(kParamAuthorization) String apiKey);

  @GET(kEndPointSizes)
  Future<SizeResponse?> getSizes(@Header(kParamAuthorization) String apiKey,);

  @POST(kEndPointSizes)
  Future<PostMethodResponse?> addSize(
      @Header(kParamAuthorization) String apiKey,
      @Body() SizeRequest request
      );

  @PUT("$kEndPointSizes/{id}")
  Future<PostMethodResponse?> updateSizeById(
      @Header(kParamAuthorization) String apiKey,
      @Path() int id,
      @Body() SizeRequest request
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

  @GET(kEndPointSubCategories)
  Future<SubCategoryResponse?> getSubCategories(
      @Header(kParamAuthorization) String apiKey,
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

  @GET(kEndPointProducts)
  Future<ProductResponse?> getProducts(@Header(kParamAuthorization) String apiKey,);

  @PUT("$kEndPointProducts/{id}")
  Future<PostMethodResponse?> updateProductById(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int id,
      @Body() ProductRequestVo body
      );

  @POST(kEndPointAdminAuth)
  Future<LoginResponse?> adminLogin(
      @Body() Map<String, dynamic> body,
      );
}