
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/data/models/shoppy_admin_model.dart';
import 'package:rpro_mini/ui/pages/home_page.dart';
import 'package:rpro_mini/utils/helper_functions.dart';
import '../../bloc/auth_provider.dart';
import '../themes/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final ShoppyAdminModel _model = ShoppyAdminModel();
  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  String? _nameErrorMessage;
  String userName = '';
  String? _passwordErrorMessage;
  bool isLoading = false;
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onClickLogin() async {
    if (_userNameController.text.isEmpty) {
      setState(() {
        _nameErrorMessage = 'Username is require';
      });
      return;
    } else if (_passwordController.text.isEmpty) {
      setState(() {
        _nameErrorMessage = null;
        _passwordErrorMessage = 'Password is require';
      });
    }
    else {
      setState(() {
        isLoading = true;
        _nameErrorMessage = null;
        _passwordErrorMessage = null;
      });
      _model.adminLogin(_userNameController.text, _passwordController.text).then((onValue){
        setState(() { isLoading = false; });
        final authModel = Provider.of<AuthProvider>(context,listen: false);
        authModel.saveTokenToDatabase(_userNameController.text, _passwordController.text);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()),(routes) => false);
      }).catchError((onError){
        setState(() { isLoading = false; });
        showAlertDialogBox(context, 'Login failed !', onError.toString());
      });
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
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
          margin: EdgeInsets.symmetric(horizontal: MediaQuery
              .of(context)
              .size
              .width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/pana.png',
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.36,
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Login',
                  style: TextStyle(color: AppColors.colorPrimary,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w600),
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
                  controller: _userNameController,
                  focusNode: _userNameFocusNode,
                  decoration: InputDecoration(
                    hintText: 'username',
                    errorText: _nameErrorMessage,
                    hintStyle: const TextStyle(color: Colors.black38,
                        fontFamily: 'Ubuntu',
                        fontSize: 14),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors
                          .colorPrimary50), // Color when not focused
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors
                          .colorPrimary), // Color when focused
                    ),
                  ),
                  onSubmitted: (_) {
                    // Move focus to the password field
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
              ),

              ///password edit text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  decoration: InputDecoration(
                    hintText: 'password',
                    errorText: _passwordErrorMessage,
                    hintStyle: const TextStyle(fontFamily: 'Ubuntu',
                        fontSize: 14,
                        color: Colors.black38),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors
                          .colorPrimary50), // Color when not focused
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors
                          .colorPrimary), // Color when focused
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 50),

              ///login button
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.8,
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                        onPressed: _onClickLogin,
                        child: isLoading
                            ? const CupertinoActivityIndicator(color: Colors.white)
                            : const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        )),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
