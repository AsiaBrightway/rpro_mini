
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier{
  String _userName = '';
  String _password = '';
  String _url = '';
  String _empName ='';
  int _userId = 0;
  String _restName = '';
  String _layout = 'list';

  String get restName => _restName;
  String get layout => _layout;
  String get url => _url;
  String get empName => _empName;
  int get userId => _userId;
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
    _restName = prefs.getString('restName') ?? '';
    _empName = prefs.getString('empName') ?? '';
    _userId = prefs.getInt('userId') ?? 0;
    _userName = prefs.getString('name') ?? '';
    _password = prefs.getString('password') ?? '';
    _url = prefs.getString('url') ?? '';
    notifyListeners();
  }

  Future<void> saveUrl(String url,String restName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('url', url);
    await prefs.setString('restName', restName);
    _restName = restName;
    _url = url;
    notifyListeners();
  }

  Future<void> saveTokenToDatabase(String name,String password,String empName,int userId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('empName', empName);
    await prefs.setString('name', name);
    await prefs.setString('password', password);
    await prefs.setInt('userId', userId);
    _empName = empName;
    _userName = name;
    _password = password;
    _userId = userId;
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('empName');
    await prefs.remove('name');
    await prefs.remove('password');
    _userId = 0;
    _empName = '';
    _userName = '';
    _password = '';
    notifyListeners();
  }

  Future<void> clearAllData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('empName');
    await prefs.remove('token');
    await prefs.remove('refresh_token');
    await prefs.remove('url');
    _userId = 0;
    _empName = '';
    _userName = '';
    _url = '';
    _password = '';
    notifyListeners();
  }
}