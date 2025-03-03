

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/bloc/auth_provider.dart';
import '../themes/colors.dart';

class UrlPage extends StatefulWidget {
  const UrlPage({super.key});

  @override
  State<UrlPage> createState() => _UrlPageState();
}

class _UrlPageState extends State<UrlPage> {

  final _urlController = TextEditingController();
  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  String? _nameErrorMessage;

  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  Future<void> _onClickLogin() async{
    if(_urlController.text.isEmpty){
      setState(() {
        _nameErrorMessage = 'Username is require';
      });
      return;
    }else{
      setState(() {
        _nameErrorMessage = null;
      });
    }
    final bloc = Provider.of<AuthProvider>(context, listen: false);

    //bool success = await bloc.loginWithEmail(_userNameController.text, _passwordController.text);
    // if (!mounted) return; // Prevent navigation if widget is disposed
    // if (success) {
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
    // } else {
    //   showToastMessage(context, 'Something went wrong');
    // }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _userNameFocusNode.dispose();
    _passwordFocusNode.dispose();
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
                height: MediaQuery.of(context).size.height * 0.36,
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Login',
                  style: TextStyle(color: AppColors.colorPrimary,fontFamily: 'Ubuntu',fontWeight: FontWeight.w600),
                ),
              ),
              ///horizontal small line
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 2,
                  width: 43,
                  color: AppColors.colorPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ///email edit text
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: _urlController,
                  focusNode: _userNameFocusNode,
                  decoration: InputDecoration(
                    hintText: 'username',
                    errorText: _nameErrorMessage,
                    hintStyle: const TextStyle(color:Colors.black38,fontFamily: 'Ubuntu',fontSize: 14),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.colorPrimary50), // Color when not focused
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.colorPrimary), // Color when focused
                    ),
                  ),
                  onSubmitted: (_) {
                    // Move focus to the password field
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  keyboardType: TextInputType.emailAddress,
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
                        onPressed: model.isLoading ? null : _onClickLogin, // Disable button when loading
                        child: model.isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
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
