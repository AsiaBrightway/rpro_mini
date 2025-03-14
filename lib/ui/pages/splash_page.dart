import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/bloc/home_bloc.dart';
import 'package:rpro_mini/data/models/shoppy_admin_model.dart';
import 'package:rpro_mini/ui/pages/home_page.dart';
import 'package:rpro_mini/ui/pages/login_page.dart';
import 'package:rpro_mini/ui/pages/url_page.dart';
import 'package:rpro_mini/ui/themes/colors.dart';
import 'package:rpro_mini/utils/helper_functions.dart';

import '../../bloc/auth_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  final ShoppyAdminModel _model = ShoppyAdminModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }
  
  Future<void> _checkLoginStatus() async{
    AuthProvider authProvider = Provider.of<AuthProvider>(context,listen: false);
    await Provider.of<AuthProvider>(context,listen: false).loadToken();
    String url = authProvider.url;
    String name = authProvider.userName;
    String password = authProvider.password;
    await Future.delayed(const Duration(milliseconds: 500));
    if(url.isEmpty){
      if(!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UrlPage()));
    }
    ///we will use network and check name and password
    else if(name.isNotEmpty){
      if(!mounted) return;
      _model.adminLogin(name, password).then((onValue){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
      }).catchError((error){
        showAlertDialogBox(context,'Login Error',error.toString());
      });
    }else{
      if(!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPrimary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/rpro_logo.webp',width: 160,height: 160),
                const SizedBox(height: 20),
                const CupertinoActivityIndicator(color: Colors.white,radius: 12),
              ],
            ),
          ),
          Container(
            color: AppColors.cartBgColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Ubuntu',
                        color: Colors.grey, // Default color for "Developed by"
                      ),
                      children: [
                        TextSpan(text: 'Developed by '),
                        TextSpan(
                          text: 'Asia Bright Way',
                          style: TextStyle(color: Colors.white), // Blue color for Asia Bright Way
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}
