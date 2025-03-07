import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/bloc/home_bloc.dart';
import 'package:rpro_mini/ui/pages/home_page.dart';
import 'package:rpro_mini/ui/pages/login_page.dart';
import 'package:rpro_mini/ui/pages/url_page.dart';
import 'package:rpro_mini/ui/themes/colors.dart';

import '../../bloc/auth_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async{
    HomeBloc homeBloc = Provider.of<HomeBloc>(context,listen: false);
    var floors = homeBloc.floors;
    AuthProvider authProvider = Provider.of<AuthProvider>(context,listen: false);
    await Future.delayed(const Duration(seconds: 2));
    await Provider.of<AuthProvider>(context,listen: false).loadToken();
    String url = authProvider.url;
    String name = authProvider.userName;
    // String password = authProvider.password;
    if(url.isEmpty){
      if(!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context) => const UrlPage()));
    }
    ///we will use network and check name and password
    else if(name.isNotEmpty){
      if(!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(floors: floors,)));
    }else{
      if(!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/rpro_logo.png',width: 160,height: 160),
            const SizedBox(height: 20),
            const CupertinoActivityIndicator(color: Colors.white,radius: 12,)
          ],
        )
      ),
    );
  }
}
