import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_pool/features/profile/services/profile_service.dart';

import '../../../common/utils/alert_boxes.dart';
import '../../authentication/providers/authentication_provider.dart';
import '../../authentication/widgets/custom_elavated_button.dart';
import '../../authentication/widgets/custom_text_form_field.dart';
import '../../users management/utils/user_mng_textfield_validator.dart';
import '../utils/profile_textfield_validator.dart';


class ChangeUserPassword extends StatefulWidget {
  const ChangeUserPassword({super.key});

  @override
  State<ChangeUserPassword> createState() => _ChangeUserPasswordState();
}

class _ChangeUserPasswordState extends State<ChangeUserPassword> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newConfirmPasswordController = TextEditingController();
  bool _isObscureText1 = true;
  bool _isObscureText2 = true;
  bool _isObscureText3 = true;
  bool _isLoading =false;
  ProfileService profileService = ProfileService();

  final _formKey = GlobalKey<FormState>();


  void tooglePasswordEye(int fieldNo) {
    setState(() {
      if(fieldNo ==1){
        _isObscureText1 = !_isObscureText1;
      }
      else if(fieldNo == 2){
        _isObscureText2 = !_isObscureText2;
      }
      else{
        _isObscureText3 = !_isObscureText3;
      }
    });
  }

  Future<void> updatePassword() async {
    try{
      if(mounted){
        setState(() {
          _isLoading =true;
        });
      }
      final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
      bool _isSuccess = await profileService.updatePassword(authProvider.getCurrentUser()!.email!, _currentPasswordController.text.trim(), _newConfirmPasswordController.text.trim());
      if(_isSuccess){
        AlertBoxes.showAlert(
          context,
          "Success",
          "Your password has been updated successfully!",
              () {
            Navigator.pop(context);Navigator.pop(context);
            authProvider.signOut(context);
          },
        );
      }
    }catch(e){
      log(e.toString());
      AlertBoxes.showAlert(
        context,
        "Error",
        e.toString(),
            () {
          Navigator.pop(context);
        },
      );
    }finally{
      if(mounted){
        setState(() {
          _isLoading =false;
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:   const  Text("Change Password", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
      ),
      body: SafeArea(
      child: Container(
        margin: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            SizedBox(height: 20,),
            CustomTextFormField(
              controller: _currentPasswordController,
              hintText: "Enter your current password",
              isObscureText: _isObscureText1,
              keyboardType: TextInputType.visiblePassword,
              validator: ProfileTextFieldValidator.validateCurrentPassword,
              suffixWidget: IconButton(
                icon: Icon(
                  _isObscureText1
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  tooglePasswordEye(1);
                },
              ),
            ),
            SizedBox(height: 15,),
            CustomTextFormField(
              controller: _newPasswordController,
              hintText: "Enter your new password",
              isObscureText: _isObscureText2,
              keyboardType: TextInputType.visiblePassword,
              validator: ProfileTextFieldValidator.validateNewPassword,
              suffixWidget: IconButton(
                icon: Icon(
                  _isObscureText2
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  tooglePasswordEye(2);
                },
              ),
            ),
            SizedBox(height: 15,),
            CustomTextFormField(
              controller: _newConfirmPasswordController,
              hintText: "Re-type your new password",
              isObscureText: _isObscureText3,
              keyboardType: TextInputType.visiblePassword,
              validator: (value){
                if (value == null || value.isEmpty) {
                  return 'Please re-type your new password';
                }
                else if(_newPasswordController.text != value){
                  return "Password does not match.";
                }
                return null; // Return null if the input is valid
              },
              suffixWidget: IconButton(
                icon: Icon(
                  _isObscureText3
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  tooglePasswordEye(3);
                },
              ),
            ),
            SizedBox(height: 15,),
            _isLoading?const Align(
                alignment: Alignment.topCenter,
                child: CircularProgressIndicator()):CustomElevatedButton(
              buttonText:"Update Password",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  updatePassword();
                }
              },
            ),
          ],),
        ),
      ),
    ),);
  }
}
