import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share_pool/common/theme/app_theme.dart';
import 'package:share_pool/common/utils/alert_boxes.dart';
import 'package:share_pool/common/utils/enum_data.dart';
import 'package:share_pool/features/authentication/utils/login_text_field_validator.dart';
import 'package:share_pool/features/authentication/widgets/custom_elavated_button.dart';
import 'package:share_pool/features/users%20management/model/user_model.dart';
import 'package:share_pool/features/users%20management/services/user_profile_service.dart';
import 'package:share_pool/features/users%20management/utils/user_mng_textfield_validator.dart';

import '../../authentication/widgets/custom_text_form_field.dart';

class AddNewUserPage extends StatefulWidget {
  UserModel? userData;
  Nature nature;

  AddNewUserPage({super.key, this.userData, required this.nature});

  @override
  State<AddNewUserPage> createState() => _AddNewUserPageState();
}

class _AddNewUserPageState extends State<AddNewUserPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _officeLocation = TextEditingController();
  final TextEditingController _position = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _depratmentController = TextEditingController();
  bool _isLoading =false;
  bool _isAccDeleting =false;
  final _formKey = GlobalKey<FormState>();
  bool _isObscureText = true;
  bool _isReadOnly = false;

  @override
  void dispose(){
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _officeLocation.dispose();
    _position.dispose();
    _passwordController.dispose();
    _depratmentController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    fillControls();
    super.initState();
  }


  void fillControls(){
    if(widget.nature == Nature.EDIT){
      _isReadOnly=  true;
      _nameController.text = widget.userData!.name!;
      _emailController.text = widget.userData!.email!;
      _mobileController.text = widget.userData!.mobile!;
      _officeLocation.text = widget.userData!.officeLocation!;
      _position.text = widget.userData!.position!;
      _passwordController.text = widget.userData!.password!;
      _depratmentController.text = widget.userData!.department!;
    }
  }

  void tooglePasswordEye() {
    setState(() {
      _isObscureText = !_isObscureText;
    });
  }


  void fillObj(){
    UserModel data = UserModel();
    data.name = _nameController.text.trim();
    data.email = _emailController.text.trim();
    data.mobile = _mobileController.text.trim();
    data.officeLocation = _officeLocation.text.trim();
    data.position = _position.text.trim();
    data.department = _depratmentController.text.trim();
    data.password = _passwordController.text.trim();

    if(widget.nature == Nature.EDIT){
      data.groupRole =widget.userData!.groupRole;
      data.userRole =widget.userData!.userRole;
      updateProfile(data);
    }
    else{
      createProfile(data);
    }
  }
  Future<void> createProfile(UserModel data) async{
    try{
      if(mounted){
        setState(() {
          _isLoading = true;
        });
      }

     bool _isSuccess = await UserProfileService.createAccountAndProfile(data);

     if(_isSuccess==true){
       AlertBoxes.showAlert(
         context,
         "Success",
         "Account has been created successfully!",
             () {
           Navigator.pop(context);Navigator.pop(context);
         },
       );
     }
    }
    catch(e){
      log(e.toString());
      AlertBoxes.showAlert(
        context,
        "Error",
        e.toString(),
            () {
          Navigator.pop(context);
        },
      );
    }
    finally{
      if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
    }
  }



  Future<void> updateProfile(UserModel data) async{
    try{
      if(mounted){
        setState(() {
          _isLoading = true;
        });
      }

      bool _isSuccess = await UserProfileService.updateProfileData(data);

      if(_isSuccess==true){
        AlertBoxes.showAlert(
          context,
          "Success",
          "Account has been updated successfully!",
              () {
            Navigator.pop(context);Navigator.pop(context);
          },
        );
      }
    }
    catch(e){
      log(e.toString());
      AlertBoxes.showAlert(
        context,
        "Error",
        e.toString(),
            () {
          Navigator.pop(context);
        },
      );
    }
    finally{
      if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
    }
  }



  Future<void> deleteProfile() async{
    try{
      if(mounted){
        setState(() {
          _isAccDeleting = true;
        });
      }
      bool _isSuccess = await UserProfileService.deleteAccountAndProfileByAdmin(widget.userData!.email!);
      if(_isSuccess==true){
        AlertBoxes.showAlert(
          context,
          "Success",
          "Account has been deleted successfully!",
              () {
            Navigator.pop(context);Navigator.pop(context);
          },
        );
      }
    }
    catch(e){
      log(e.toString());
      AlertBoxes.showAlert(
        context,
        "Error",
        e.toString(),
            () {
          Navigator.pop(context);
        },
      );
    }
    finally{
      if(mounted){
        setState(() {
          _isAccDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.nature == Nature.ADD? "Create Account" :"Manage user account",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),

      ),
      body: SafeArea(child: Container(
        margin: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 16),
        child:  SingleChildScrollView(

          child: Form(
            key:_formKey ,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Text(widget.nature == Nature.ADD? "Add new user": "Manage Account", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),),
                    SizedBox(height: 5,),
                    Text(widget.nature == Nature.ADD? "Enter worker's details below." : "View, edit and delete user account", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, ),),

                  ]
                    ,),
                    Visibility(
                      visible: widget.nature == Nature.EDIT,
                      child: Row(children: [
                      IconButton(onPressed: (){
                        setState(() {
                          _isReadOnly = !_isReadOnly;
                        });

                      }, icon:  _isReadOnly? const Icon(Icons.edit_outlined,color: Colors.white,): const SizedBox()),
                        IconButton(onPressed: (){

                          AlertBoxes.showConfirmAlert(
                            context,
                            "Confirmation",
                                "Are you sure you want delete this user account?",
                                () {
                             deleteProfile();
                            },
                          );

                        }, icon: _isAccDeleting? const SizedBox(width:15, height: 15, child: CircularProgressIndicator()): const Icon(Icons.delete_outline,color: Colors.red,))
                      ],),
                    )

                ],),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                hintText: "Enter worker's name",
                readOnly:  _isReadOnly,
                validator: UserMngTextFieldValidator.validateName,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                readOnly:  _isReadOnly,
                hintText: "Enter worker's email address",
                validator: UserMngTextFieldValidator.validateEmail,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                hintText: "Enter worker's mobile number",
                readOnly:  _isReadOnly,
                validator: UserMngTextFieldValidator.validateMobileNo,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextFormField(
                controller: _officeLocation,
                keyboardType: TextInputType.name,
                hintText: "Enter worker's office location",
                readOnly:  _isReadOnly,
                validator:  UserMngTextFieldValidator.validateOfficeLocation,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextFormField(
                controller: _depratmentController,
                keyboardType: TextInputType.name,
                hintText: "Enter worker's department",
                readOnly:  _isReadOnly,
                validator:  UserMngTextFieldValidator.validateDepartment,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextFormField(
                controller: _position,
                keyboardType: TextInputType.name,
                hintText: "Enter worker's position",
                readOnly:  _isReadOnly,
                validator:  UserMngTextFieldValidator.validatePosition,
              ),
              const SizedBox(
                height: 15,
              ),
              Visibility(
                visible: widget.nature == Nature.ADD,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _passwordController,
                      hintText: "Enter password for worker",
                      isObscureText: _isObscureText,
                      readOnly:  _isReadOnly,
                      keyboardType: TextInputType.visiblePassword,
                      validator: UserMngTextFieldValidator.validatePassword,
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
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Visibility(
                visible: !_isReadOnly,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                  _isLoading?const Align(
                      alignment: Alignment.topCenter,
                      child: CircularProgressIndicator()):CustomElevatedButton(
                    buttonText: widget.nature== Nature.ADD? "Create" : "Update",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                                              fillObj();

                      }
                    },
                  ),
                ],),
              ),
             const SizedBox(height: 20,),
                ],),
          ),
        ),
      ),),);
  }
}
