import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_pool/features/users%20management/model/user_model.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      // Handle sign-in error
      log('Error signing in: $e');
      if(e.toString().contains("[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.")){
       await checkEmailExists(email,password);
      }
      else{
        throw e;

      }
    }
  }


  Future<void> checkEmailExists(String email,String password) async {
    try {
      // Reference to the profiles collection
      CollectionReference profiles = FirebaseFirestore.instance.collection('profiles');

      // Query to check if the email exists in the profiles collection
      QuerySnapshot querySnapshot = await profiles.where('email' , isEqualTo: email ).get();

      // Return true if the query snapshot has documents, indicating that the email exists
      if(querySnapshot.docs.isNotEmpty){
        log("Profile found in firestore");
        var profileData = querySnapshot.docs.first.data();
        UserModel userProfile = UserModel.fromJson(profileData as Map<String, dynamic>);

        if (userProfile.password == password) {
          log("Password matched with profile");
          await createAccountAndProfile(email,password);
        }else{
          log("Password does not match with the profile");
          throw("[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.");
        }

      }
      else{
        log("Profile not found in firestore");
        throw("[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.");
      }
    } catch (error) {
      // Handle errors here (e.g., print error, show error message)
      log('Error checking email existence: $error');
      throw error; // You can handle the error further up the call stack
    }
  }


  static Future<bool> createAccountAndProfile(String email, String password) async {
    try {
     // Create the account using email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      log("New Account created successfully");

      // Account created and profile created successfully
      return true;
    } catch (error) {
      // Handle errors here
      log(error.toString());

      throw(error);
    }
  }


  // Method to get profile details of the logged-in user
  Future<UserModel?> getProfileDetails() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot profileSnapshot =
        await _firestore.collection('profiles').doc(currentUser.email).get();
        if (profileSnapshot.exists) {
          return UserModel.fromJson(profileSnapshot.data() as Map<String, dynamic>);
        } else {
          log('Profile not found for user: ${currentUser.uid}');
          throw "Profile not found for this account!";
        }
      } catch (e) {
        log('Error fetching profile details: $e');
        throw e;
      }
    } else {
      log('No user logged in');
      throw "No user logged in";
    }
  }


}