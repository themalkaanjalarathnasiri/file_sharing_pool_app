import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_pool/features/authentication/screens/login_view/login_view.dart';
import 'package:share_pool/features/authentication/services/auth_service.dart';
import 'package:share_pool/features/users%20management/model/user_model.dart';
import 'package:share_pool/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_pool/main.dart';

import '../../../common/utils/nav_transition_utils.dart';
import '../../home/screens/navigation_page.dart';

class AuthenticationProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _userData = UserModel();
  final AuthService _authService = AuthService();
  UserModel get userData => _userData??UserModel();

  // Method to check the authentication state and navigate accordingly
  Future<void> checkAuthenticationState(BuildContext context) async {
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {

        _userData =  await  _authService.getProfileDetails();
        //get user data from cloud
        if(_userData!=null && _userData!.email!=null){
          //fetch data from cloud and navigate to home
          log("fetch data from cloud and navigate to home");
          // Navigator.of(context).pushAndRemoveUntil(
          //     TransitionUtils.slideTransitionFromRightToLeft(builder: (context) => NavigationScreen()),
          //         (Route<dynamic> route) => false);
          Navigator.of(context).push(
              TransitionUtils.slideTransitionFromRightToLeft(builder: (context) => PopScope(child: NavigationScreen(), canPop: false,)),);
        }
        //if failed, get data from locally
        else{
         bool isSuccess = await  isAuthenticated();
         if(isSuccess){
           log("fetch data from locally and navigate to home");
           Navigator.of(context).push(
               TransitionUtils.slideTransitionFromRightToLeft(builder: (context) => PopScope(child: NavigationScreen(), canPop: false,)),);

         }
         else{
           Navigator.of(context).push(
               TransitionUtils.slideTransitionFromRightToLeft(builder: (context) => PopScope(child: LoginPage(), canPop: false,)),);

         }
        }

      } else {
        // If user is not signed in, navigate to login page
        Navigator.of(context).push(
            TransitionUtils.slideTransitionFromRightToLeft(builder: (context) => PopScope(child: LoginPage(), canPop: false,)),);
      }
    });
  }


  //check whethere user is already logged in local storage
  Future<bool> isAuthenticated() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String currentUserString = prefs.getString("logged_in_user") ?? '';
      Map<String, dynamic> currentUserJson = jsonDecode(currentUserString);
      UserModel user = UserModel.fromJson(currentUserJson);
      //if logged user is already in local storage --> navigate to main screen
      if (user.email != null && user.email!.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }



  // Method to sign out the current user
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
  }

  // Method to get user data
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
