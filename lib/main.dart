import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:provider/provider.dart' as provider;
import 'package:rpro_mini/ui/pages/home_page.dart';
import 'package:rpro_mini/ui/pages/login_page.dart';
import 'package:rpro_mini/ui/themes/dark_mode.dart';
import 'package:rpro_mini/ui/themes/light_mode.dart';

import 'bloc/auth_provider.dart';

void main() async{
  runApp(
    riverpod.ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(create: (context) => AuthProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      home: const LoginPage(),
    );
  }
}
