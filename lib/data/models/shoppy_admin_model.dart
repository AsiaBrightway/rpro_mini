
import 'dart:io';

import 'package:rpro_mini/data/vos/brand_vo.dart';
import 'package:rpro_mini/data/vos/category_vo.dart';
import 'package:rpro_mini/data/vos/floor_vo.dart';
import 'package:rpro_mini/data/vos/item_vo.dart';
import 'package:rpro_mini/data/vos/request/color_request_vo.dart';
import 'package:rpro_mini/data/vos/request/product_request_vo.dart';
import 'package:rpro_mini/network/data_agents/shoppy_admin_agent.dart';
import 'package:rpro_mini/network/data_agents/shoppy_admin_agent_impl.dart';
import 'package:rpro_mini/network/responses/login_response.dart';
import 'package:rpro_mini/network/responses/table_response.dart';
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

  Future<PostMethodResponse?> updateColor(String token,int id,ColorRequestVo request){
    return mDataAgent.updateColor(token, id, request);
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

  Future<List<CategoryVo>> getCategories(){
    return mDataAgent.getCategories().asStream().map((response) => response?.data ?? []).first;
  }

  Future<PostMethodResponse?> addNewProduct(String token,ProductRequestVo request){
    return mDataAgent.addNewProduct(token,request);
  }

  Future<PostMethodResponse?> updateProductById(String token,int id,ProductRequestVo request){
    return mDataAgent.updateProductById(token, id, request);
  }

  Future<List<FloorVo>> getFloors(){
    return mDataAgent.getFloors();
  }

  Future<TableResponse> getTablesByFloorId(int floorId){
    return mDataAgent.getTablesByFloorId(floorId);
  }

  Future<List<ItemVo>?> getItemsByCategory(int categoryId){
    return mDataAgent.getItemsByCategoryId(categoryId).asStream().map((response) => response.data ?? []).first;
  }

  Future<List<ItemVo>?> searchItemByName(String name){
    return mDataAgent.searchItemByName(name).asStream().map((response) => response.data ?? []).first;
  }
}