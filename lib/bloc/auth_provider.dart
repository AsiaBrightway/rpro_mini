
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier{
  String _userName = '';
  String _password = '';
  String _url = '';
  String _layout = 'grid';

  String get layout => _layout;
  String get url => _url;
  String get password => _password;
  String get userName => _userName;

  set layout(String value) {
    _layout = value;
  }

  void toggleLayout() {
    layout = layout == 'grid' ? 'list' : 'grid';
    notifyListeners();
  }

  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('name') ?? '';
    _password = prefs.getString('password') ?? '';
    _url = prefs.getString('url') ?? '';
    notifyListeners();
  }

  Future<void> saveUrl(String url) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('url', url);
  }

  Future<void> saveTokenToDatabase(String name,String password) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('password', password);
    _userName = name;
    _password = password;
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('password');
    _userName = '';
    _password = '';
    notifyListeners();
  }

  Future<void> clearAllData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refresh_token');
    await prefs.remove('url');
    _userName = '';
    _url = '';
    _password = '';
    notifyListeners();
  }
}