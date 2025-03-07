import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/ui/pages/printer_config_page.dart';
import '../../bloc/auth_provider.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key});
  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: DrawerHeader(
                  child: Image.asset('assets/rpro_logo.png',width: 100,)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: const Icon(Icons.print,color: Colors.black87,),
                title: const Text('Printer Config',style: TextStyle(fontWeight: FontWeight.w500),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PrinterConfigPage()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: const Icon(Icons.logout,color: Colors.red,),
                title: const Text('Logout',style: TextStyle(fontWeight: FontWeight.w500),),
                onTap: (){
                  _showLogoutDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
