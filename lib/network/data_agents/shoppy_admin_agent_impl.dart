import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rpro_mini/data/vos/floor_vo.dart';
import 'package:rpro_mini/data/vos/request/color_request_vo.dart';
import 'package:rpro_mini/data/vos/request/product_request_vo.dart';
import 'package:rpro_mini/data/vos/table_vo.dart';
import 'package:rpro_mini/network/data_agents/shoppy_admin_agent.dart';
import 'package:rpro_mini/network/responses/brand_response.dart';
import 'package:rpro_mini/network/responses/category_response.dart';
import 'package:rpro_mini/network/responses/login_response.dart';
import 'package:rpro_mini/network/responses/post_method_response.dart';
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
  Future<PostMethodResponse?> addCategory(String token,String name, File? imageFile) async{
    final Map<String, dynamic> data = {
      "category_name": name,
    };

    if (imageFile != null) {
      data["image"] = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      );
    }

    FormData formData = FormData.fromMap(data);
    try {
      return await shoppyApi.addCategory(token,formData);
    } catch (onError) {
      throw _createException(onError);
    }
  }

  @override
  Future<CategoryResponse?> getCategories(String token,) {
    return shoppyApi.getCategories(token).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> updateCategoryById(String token,int id, String name, File? imageFile) async{
    final Map<String, dynamic> data = {
      "category_name": name,
    };

    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      // Encode the image to base64. Ensure your API can decode this.
      data["image"] = base64Encode(bytes);

    } else {
      data["image"] = null;
    }

    try {
      return await shoppyApi.updateCategoryById(token,id,data);
    } catch (onError) {
      throw _createException(onError);
    }
  }

  @override
  Future<PostMethodResponse?> addSubCategory(String token,int categoryId, String subName, File? imageFile) async{
    final Map<String, dynamic> data = {
      "category_id": categoryId,
      "sub_category_name": subName,
    };

    if (imageFile != null) {
      data["image"] = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      );
    }

    FormData formData = FormData.fromMap(data);
    try {
      return await shoppyApi.addSubCategory(token,formData);
    } catch (onError) {
      throw _createException(onError);
    }
  }

  @override
  Future<PostMethodResponse?> updateSubCategoryById(String token,int id, int categoryId, String name, File? image) async{
    final Map<String, dynamic> data = {
      "category_id": id,
      "sub_category_name": name,
    };

    if (image != null) {
      final bytes = await image.readAsBytes();
      // Encode the image to base64. Ensure your API can decode this.
      data["image"] = base64Encode(bytes);
    } else {
      data["image"] = null;
    }

    try {
      return await shoppyApi.updateSubCategoryById(token, id,data);
    } catch (onError) {
      throw _createException(onError);
    }
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
  Future<List<TableVo>?> getTablesByFloorId(int floorId) {
    return shoppyApi.getTableListByFloorId(floorId).catchError((onError){
      throw _createException(onError);
    });
  }

}