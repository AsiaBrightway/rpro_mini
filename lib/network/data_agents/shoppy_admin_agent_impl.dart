import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rpro_mini/data/vos/floor_vo.dart';
import 'package:rpro_mini/data/vos/request/color_request_vo.dart';
import 'package:rpro_mini/data/vos/request/product_request_vo.dart';
import 'package:rpro_mini/network/data_agents/shoppy_admin_agent.dart';
import 'package:rpro_mini/network/responses/brand_response.dart';
import 'package:rpro_mini/network/responses/category_response.dart';
import 'package:rpro_mini/network/responses/item_response.dart';
import 'package:rpro_mini/network/responses/login_response.dart';
import 'package:rpro_mini/network/responses/post_method_response.dart';
import 'package:rpro_mini/network/responses/table_response.dart';
import 'package:rpro_mini/network/shoppy_api.dart';
import '../../data/vos/error_vo.dart';
import '../../exception/custom_exception.dart';

class ShoppyAdminAgentImpl extends ShoppyAdminAgent{
  late Dio dio;
  late ShoppyApi shoppyApi;

  static ShoppyAdminAgentImpl? _singleton;

  factory ShoppyAdminAgentImpl({String? baseUrl}){
    _singleton ??= ShoppyAdminAgentImpl._internal(baseUrl: baseUrl);
    return _singleton!;
  }

  ShoppyAdminAgentImpl._internal({String? baseUrl}) {
    dio = Dio();
    if (baseUrl != null) {
      dio.options.baseUrl = baseUrl; // Set the baseUrl in Dio
    }
    shoppyApi = ShoppyApi(dio);
  }

  Future<MultipartFile> convertFileToMultipart(File file) async {
    return await MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last, // Optional: Set the file name
    );
  }

  void updateBaseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
  }

  CustomException _createException(dynamic error){
    ErrorVo errorVo;
    if(error is DioException){
      errorVo = _parseDioError(error);
    } else if(error is TypeError){
      errorVo = ErrorVo(message: "Type Error : $error");
    }
    else {
      errorVo = ErrorVo(message: "Unexcepted Error $error");
    }
    return CustomException(errorVo);
  }

  ErrorVo _parseDioError(DioException error){
    try{
      if(error.response != null && error.response?.data != null){
        var data = error.response?.data;
        ///Json String to Map<String,dynamic>
        if(data is String){
          data = jsonDecode(data);
        }
        return ErrorVo.fromJson(data);
      }else if(error.response?.statusCode == 401){
        return ErrorVo(message: 'Unauthorized');
      }
      else if(error.type == DioExceptionType.sendTimeout){
        return ErrorVo( message: 'Send Timeout!');
      }
      else if(error.type == DioExceptionType.badResponse){
        return ErrorVo(message: 'Bad response');
      }
      else if(error.type == DioExceptionType.connectionError){
        return ErrorVo(message: 'Connection Error');
      }
      else if(error.type == DioExceptionType.connectionTimeout){
        return ErrorVo(message: 'Connection Timeout!');
      }
      else {
        return ErrorVo(message: 'No response data');
      }
    }catch(e){
      return ErrorVo(message: 'Invalid DioException Format $e');
    }
  }


  @override
  Future<PostMethodResponse?> updateColor(String token,int id,ColorRequestVo request) {
    return shoppyApi.updateColorById(token, id, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> addBrand(String token,String name, String description, File? imageFile) async{
    final Map<String, dynamic> data = {
      "brand_name": name,
      "brand_description": description,
    };

    if (imageFile != null) {
      data["image"] = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      );
    }

    FormData formData = FormData.fromMap(data);
    try {
      return await shoppyApi.addBrand(token,formData);
    } catch (onError) {
      throw _createException(onError);
    }
  }

  @override
  Future<BrandResponse?> getBrands(String token,) {
    return shoppyApi.getBrands(token).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> updateBrandById(String token,int id, String name, String description, File? imageFile) async {
    final Map<String, dynamic> data = {
      "brand_name": name,
      "brand_description": description,
    };

    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      // Encode the image to base64. Ensure your API can decode this.
      data["image"] = base64Encode(bytes);
    } else {
      data["image"] = null; // Or simply omit this key if that's preferred by your API.
    }

    try {
      return await shoppyApi.updateBrandById(token,id, data);
    } catch (error) {
      throw _createException(error);
    }
  }

  @override
  Future<CategoryResponse?> getCategories() {
    return shoppyApi.getCategories().catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> addNewProduct(String token,ProductRequestVo body) {
    return shoppyApi.addNewProduct(token,body).catchError((onError){
      throw _createException(onError);

    });
  }

  @override
  Future<LoginResponse?> adminLogin(String name, String password) {
    return shoppyApi.adminLogin(name,password).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> updateProductById(String token, int id, ProductRequestVo body) {
    return shoppyApi.updateProductById(token, id, body).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<List<FloorVo>> getFloors() {
    return shoppyApi.getFloorList().catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<TableResponse> getTablesByFloorId(int floorId) {
    return shoppyApi.getTableListByFloorId(floorId).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<ItemResponse> getItemsByCategoryId(int categoryId) {
    return shoppyApi.getItemsByCategory(categoryId).catchError((onError){
      throw _createException(onError.toString());
    });
  }

  @override
  Future<ItemResponse> searchItemByName(String name) {
    return shoppyApi.searchItemByName(name).catchError((onError){
      throw _createException(onError.toString());
    });
  }
}