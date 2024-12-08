
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/group_model.dart';

class GroupMngService{

  static Future<bool> addGroupToFirestore(GroupModel group) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference groupsCollection = FirebaseFirestore.instance.collection('groups');

      // Convert the GroupModel instance to JSON
      Map<String, dynamic> groupData = group.toJson();

      // Add the data to Firestore and get the document reference
      DocumentReference docRef = await groupsCollection.add(groupData);

      // Update the GroupModel with the generated document ID
      group.groupId = docRef.id;

      // Optional: Update Firestore document with the generated ID
      await docRef.update({'groupId': docRef.id});

      log('Group added with ID: ${group.groupId}');
      return true;
    } catch (error) {
      log('Error adding group: $error');
      throw error; // Re-throwing the error for error handling in the calling code
    }
  }


  static Future<bool> updateGroupInFirestore(GroupModel group) async {
    try {
      // Get a reference to the Firestore document
      DocumentReference docRef = FirebaseFirestore.instance.collection('groups').doc(group.groupId);

      // Convert the GroupModel instance to JSON
      Map<String, dynamic> groupData = group.toJson();

      // Update the document in Firestore
      await docRef.update(groupData);

      debugPrint('Group updated with ID: ${group.groupId}');
      return true;
    } catch (error) {
      debugPrint('Error updating group: $error');
      throw error; // Re-throwing the error for error handling in the calling code
    }
  }

  static Future<bool> deleteGroupFromFirestore(String groupId) async {
    try {
      // Get a reference to the Firestore document
      DocumentReference docRef = FirebaseFirestore.instance.collection('groups').doc(groupId);

      // Delete the document from Firestore
      await docRef.delete();

      debugPrint('Group deleted with ID: $groupId');
      return true;
    } catch (error) {
      debugPrint('Error deleting group: $error');
      throw error; // Re-throwing the error for error handling in the calling code
    }
  }


}