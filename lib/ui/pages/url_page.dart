import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/bloc/auth_provider.dart';
import 'package:rpro_mini/ui/pages/login_page.dart';
import 'package:rpro_mini/utils/helper_functions.dart';
import '../../network/data_agents/shoppy_admin_agent_impl.dart';
import '../themes/colors.dart';

class UrlPage extends StatefulWidget {
  const UrlPage({super.key});

  @override
  State<UrlPage> createState() => _UrlPageState();
}

class _UrlPageState extends State<UrlPage> {
  final ShoppyAdminAgentImpl shoppyAdminAgent = ShoppyAdminAgentImpl();
  final _urlController = TextEditingController();
  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  String? _nameErrorMessage;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveUrl() async {
    if(_urlController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter Url!")),
      );
      return;
    }

    final authModel = Provider.of<AuthProvider>(context,listen: false);
    authModel.saveUrl(_urlController.text);
    showSuccessToast(context, 'Url saved Successfully');

    // Update the baseUrl in ShoppyAdminAgentImpl
    shoppyAdminAgent.updateBaseUrl(_urlController.text);

    // Navigate to the login screen
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 10,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/pana.png',
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.34,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Url',
                  style: TextStyle(color: AppColors.colorPrimary,fontFamily: 'Ubuntu',fontWeight: FontWeight.w600),
                ),
              ),
              ///horizontal small line
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 2,
                  width: 30,
                  color: AppColors.colorPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ///email edit text
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    hintText: 'Please enter url',
                    errorText: _nameErrorMessage,
                    errorStyle: const TextStyle(color: Colors.black45),
                    hintStyle: const TextStyle(color:Colors.black38,fontFamily: 'Ubuntu',fontSize: 14),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.colorPrimary50), // Color when not focused
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.colorPrimary), // Color when focused
                    ),
                  ),
                  keyboardType: TextInputType.url,
                ),
              ),
              const SizedBox(height: 50),
              ///login button
              Consumer<AuthProvider>(
                builder: (context, model, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: AppColors.colorPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: _saveUrl, // Disable button when loading
                        child: const Text(
                          'Add Url',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
