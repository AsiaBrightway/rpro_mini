
import 'dart:io';

import 'package:rpro_mini/data/vos/brand_vo.dart';
import 'package:rpro_mini/data/vos/category_vo.dart';
import 'package:rpro_mini/data/vos/color_vo.dart';
import 'package:rpro_mini/data/vos/product_vo.dart';
import 'package:rpro_mini/data/vos/request/color_request_vo.dart';
import 'package:rpro_mini/data/vos/request/product_request_vo.dart';
import 'package:rpro_mini/data/vos/request/size_request.dart';
import 'package:rpro_mini/data/vos/size_vo.dart';
import 'package:rpro_mini/data/vos/slider_vo.dart';
import 'package:rpro_mini/data/vos/sub_category_vo.dart';
import 'package:rpro_mini/network/data_agents/shoppy_admin_agent.dart';
import 'package:rpro_mini/network/data_agents/shoppy_admin_agent_impl.dart';
import 'package:rpro_mini/network/responses/login_response.dart';

import '../../network/responses/post_method_response.dart';

class ShoppyAdminModel{
  static final ShoppyAdminModel _singleton = ShoppyAdminModel._internal();

  factory ShoppyAdminModel(){
    return _singleton;
  }

  ShoppyAdminModel._internal();

  ShoppyAdminAgent mDataAgent = ShoppyAdminAgentImpl();

  Future<LoginResponse?> adminLogin(String name,String password){
    return mDataAgent.adminLogin(name, password);
  }
  
  Future<List<ColorVo>> getColors(String token){
    return mDataAgent.getColors(token).asStream().map((response) => response?.data ?? []).first;
  }

  Future<PostMethodResponse?> updateColor(String token,int id,ColorRequestVo request){
    return mDataAgent.updateColor(token, id, request);
  }

  Future<List<SizeVo>> getSizes(String token){
    return mDataAgent.getSizes(token).asStream().map((response) => response?.data ?? []).first;
  }

  Future<PostMethodResponse?> addSize(String token,SizeRequest request){
    return mDataAgent.addSize(token,request);
  }

  Future<PostMethodResponse?> updateSizeById(String token,int id,SizeRequest request){
    return mDataAgent.updateSizeById(token, id, request);
  }

  Future<PostMethodResponse?> addBrand(String token,String name,String description,File? image){
    return mDataAgent.addBrand(token, name, description, image);
  }

  Future<List<BrandVo>> getBrands(String token){
    return mDataAgent.getBrands(token).asStream().map((response) => response?.data ?? []).first;
  }

  Future<PostMethodResponse?> updateBrandsById(String token,int id,String name, String description, File? imageFile){
    return mDataAgent.updateBrandById(token, id, name, description, imageFile);
  }

  Future<PostMethodResponse?> addCategory(String token,String name,File? image){
    return mDataAgent.addCategory(token, name, image);
  }

  Future<List<CategoryVo>> getCategories(String token){
    return mDataAgent.getCategories(token).asStream().map((response) => response?.data ?? []).first;
  }

  Future<PostMethodResponse?> updateCategoryById(String token,int id,String name,File? imageFile){
    return mDataAgent.updateCategoryById(token,id, name, imageFile);
  }

  Future<PostMethodResponse?> addSubCategory(String token,int categoryId,String subName,File? imageFile){
    return mDataAgent.addSubCategory(token,categoryId, subName, imageFile);
  }

  Future<List<SubCategoryVo>> getSubCategories(String token){
    return mDataAgent.getSubCategories(token).asStream().map((response) => response?.data ?? []).first;
  }

  Future<PostMethodResponse?> updateSubCategoryById(String token,int id,int categoryId,String name,File? image){
    return mDataAgent.updateSubCategoryById(token,id, categoryId, name, image);
  }

  Future<PostMethodResponse?> addNewProduct(String token,ProductRequestVo request){
    return mDataAgent.addNewProduct(token,request);
  }

  Future<PostMethodResponse?> updateProductById(String token,int id,ProductRequestVo request){
    return mDataAgent.updateProductById(token, id, request);
  }

  Future<List<ProductVo>> getProducts(String token){
    return mDataAgent.getProducts(token).asStream().map((response) => response?.products ?? []).first;
  }

  Future<List<SliderVo>> getSliders(String token){
    return mDataAgent.getSliders(token).asStream().map((response) => response?.data ?? []).first;
  }
}