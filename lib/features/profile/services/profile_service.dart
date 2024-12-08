import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class ProfileService{

   Future<bool> updatePassword(String email, String currentPassword, String newPassword) async {
    try {
      // Reauthenticate the user
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: currentPassword);
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
      // Update the user's password
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      return true;
    } catch (error) {
      log("Error updating password: $error");
      throw error;
    }
  }
}