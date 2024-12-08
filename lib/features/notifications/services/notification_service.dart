import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_pool/features/notifications/model/activity_model.dart';

class NotificationService{


  static Future<bool> addNewActivityLog(ActivityModel data) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('activities');

      // Convert the MessageModel instance to JSON
      Map<String, dynamic> messageData = data.toJson();

      // Add the data to Firestore and get the document reference
      DocumentReference docRef = await messagesCollection.add(messageData);

      return true;
    } catch (error) {
      log('Error adding activity: $error');
      throw error;
    }
  }



}