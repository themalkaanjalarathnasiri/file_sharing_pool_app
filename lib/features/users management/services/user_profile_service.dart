
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_pool/common/utils/enum_data.dart';
import '../model/user_model.dart';


class UserProfileService{

 static Future<bool> createAccountAndProfile(UserModel userModel) async {
    try {

      userModel.userRole= Role.USER.name;
      // Create a profile document in Firestore using toJson method
      await FirebaseFirestore.instance.collection('profiles').doc(userModel.email).set(
        userModel.toJson(),
      );
      // Account created and profile created successfully
      return true;
    } catch (error) {
      // Handle errors here
      log(error.toString());

      throw(error);
    }
  }

 static Future<bool> updateProfileData(UserModel userModel) async {
   try {
     await FirebaseFirestore.instance.collection('profiles').doc(userModel.email).update(userModel.toJson());
     return true;
   } catch (error) {
     log(error.toString());
     throw error;
   }
 }


 static Future<bool> deleteAccountAndProfileByAdmin(String email) async {
   try {
     // Delete the user's profile document from Firestore
     await FirebaseFirestore.instance.collection('profiles').doc(email).delete();
     return true;
   } catch (error) {
     log("Error deleting user account and profile: $error");
     throw error;
   }
 }

 static Future<List<UserModel>> fetchUserProfiles() async {
   List<UserModel> userProfiles = [];

   try {
     QuerySnapshot userProfileSnapshots = await FirebaseFirestore.instance.collection('profiles').get();

     userProfileSnapshots.docs.forEach((DocumentSnapshot userProfileSnapshot) {
       if (userProfileSnapshot.exists) {
         userProfiles.add(UserModel.fromJson(userProfileSnapshot.data() as Map<String, dynamic>));
       }
     });
   } catch (error) {
     log("Error fetching user profiles: $error");
   }

   return userProfiles;
 }
}