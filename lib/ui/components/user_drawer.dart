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

  void _navigateToConfigPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrinterConfigPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: DrawerHeader(
                  child: Image.asset('assets/rpro_logo.webp',width: 100,)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Icon(Icons.print,color: Theme.of(context).colorScheme.onSurface),
                title: const Text('Printer Config',style: TextStyle(fontWeight: FontWeight.w500),),
                onTap: (){
                  _navigateToConfigPage(context);
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
