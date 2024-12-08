import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share_pool/common/utils/assets_paths.dart';
import 'package:share_pool/features/authentication/providers/authentication_provider.dart';
import 'package:share_pool/features/authentication/services/auth_service.dart';
import 'package:share_pool/features/authentication/utils/login_text_field_validator.dart';
import 'package:share_pool/features/authentication/widgets/custom_elavated_button.dart';
import 'package:share_pool/features/authentication/widgets/custom_text_form_field.dart';
import 'package:share_pool/features/users%20management/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/utils/alert_boxes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscureText = true;
  AuthService authService= AuthService();
  bool _isLoading = false;

  void tooglePasswordEye() {
    setState(() {
      _isObscureText = !_isObscureText;
    });
  }

  Future<void> signInWithEmailPassword() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
      await authService.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      User? currentUser = await authProvider.getCurrentUser();
      UserModel? profileDetails = await authService.getProfileDetails();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("logged_in_user", jsonEncode(profileDetails?.toJson()));

    } catch (e) {
      // Handle login error
      log('Error logging in: $e');
      AlertBoxes.showAlert(
        context,
        "Error",
        e.toString(),
            () {
          Navigator.pop(context);
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        APP_LOGO,
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Share Pool",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Sign in",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Use your organization account to continue to Share Pool.",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.grey),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: "Enter your email address",
                  validator: LoginTextFieldValidator.validateEmail,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextFormField(
                  controller: _passwordController,
                  hintText: "Enter your password",
                  isObscureText: _isObscureText,
                  keyboardType: TextInputType.visiblePassword,
                  validator: LoginTextFieldValidator.validatePassword,
                  suffixWidget: IconButton(
                    icon: Icon(
                      _isObscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      tooglePasswordEye();
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.center,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : CustomElevatedButton(
                          buttonText: "Sign in",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              signInWithEmailPassword();
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
