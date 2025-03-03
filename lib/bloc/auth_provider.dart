

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rpro_mini/network/responses/login_response.dart';
import '../data/models/shoppy_admin_model.dart';

class AuthProvider extends ChangeNotifier{
  String _accessToken = '';
  String _refreshToken = '';
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get accessToken => _accessToken;
  String get refreshToken => _refreshToken;
  final _model = ShoppyAdminModel();

  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('token') ?? '';
    _refreshToken = prefs.getString('refresh_token') ?? '';
    notifyListeners();
  }

  Future<void> saveTokenToDatabase(String token,String refreshToken) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('refresh_token', refreshToken);
    _accessToken = token;
    _refreshToken = refreshToken;
    notifyListeners();
  }

  Future<void> clearTokenAndRoleAndId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refresh_token');
    _accessToken = '';
    _refreshToken = '';
    notifyListeners();
  }

  Future<bool> loginWithEmail(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      LoginResponse? response = await _model.adminLogin(email, password);
      saveTokenToDatabase('Bearer ${response?.accessToken}', response?.refreshToken ?? '');
      await Future.delayed(const Duration(milliseconds: 500));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}