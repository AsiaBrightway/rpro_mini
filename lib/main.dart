import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:provider/provider.dart' as provider;
import 'package:rpro_mini/ui/pages/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/auth_provider.dart';
import 'bloc/bluetooth_service.dart';
import 'bloc/home_bloc.dart';
import 'network/data_agents/shoppy_admin_agent_impl.dart';
import 'ui/pages/login_page.dart';
import 'ui/themes/dark_mode.dart';
import 'ui/themes/light_mode.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final baseUrl = prefs.getString('url') ?? "https://default.example.com";

  final shoppyAdminAgent = ShoppyAdminAgentImpl(baseUrl: baseUrl);
  runApp(
    riverpod.ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(create: (context) => PrinterService()),
          provider.ChangeNotifierProvider(create: (context) => AuthProvider()),
          provider.ChangeNotifierProvider(create: (context) => HomeBloc())
        ],
        child: MyApp(shoppyAdminAgent: shoppyAdminAgent),
      ),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final ShoppyAdminAgentImpl shoppyAdminAgent;
  const MyApp({super.key, required this.shoppyAdminAgent});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      home: const SplashPage(),
        routes: {
          '/login': (context) => const LoginPage(),
        }
    );
  }
}
