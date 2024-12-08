import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:share_pool/features/file%20management/model/message_model.dart';
import 'package:share_pool/features/group%20management/model/participant_model.dart';
import 'package:share_pool/features/group%20management/model/privileage_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../group management/model/group_model.dart';

class GroupFilesService{
  static Stream<List<GroupRole>?>? getGroupRoleStreamByGroupIdAndEmail(String groupId, String email) {
    // Get a reference to the group document
    DocumentReference groupDocRef = FirebaseFirestore.instance.collection('groups').doc(groupId);

    // Stream for the group document updates
    return groupDocRef.snapshots().map((snapshot) {
      if (snapshot.exists) {
        // Document exists, access participants list
        Map<String, dynamic> groupData = snapshot.data()! as Map<String, dynamic>;
        GroupModel group = GroupModel.fromJson(groupData);
        List<ParticipantModel>? participants =group.participants;
        List<GroupRole>? groupRoles;

        // Find the participant with the matching email
        participants?.forEach((participant) {
          if (participant.email == email) {
            groupRoles = participant.groupRole;
          }
        });
        return groupRoles;
      } else {
        return null;
      }
    });

  }

  static Future<bool> uploadFile(PlatformFile file,MessageModel message ) async {
    try {

      // Reference to the file in Firebase Cloud Storage
      firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('uploads')
          .child('${message.destinationGroupId}-${message.sentById}${DateTime.now().millisecondsSinceEpoch}-${file.name}');

      // Upload file to Firebase Cloud Storage
      await storageRef.putFile(
        File(file.path!),
        firebase_storage.SettableMetadata(contentType: file.extension!),
      );

      // Get the download URL of the uploaded file
      String downloadURL = await storageRef.getDownloadURL();
      log('File uploaded successfully');
      log('Download URL: $downloadURL');
      message.fileUrl = downloadURL;
      return await addMessageToFirestore(message);



    } catch (error) {
      log('Error adding message: $error');
      throw error;
    }
  }


 static Future<bool> addMessageToFirestore(MessageModel message) async {
    try {
      // Get a reference to the Firestore collection
      message.isUploading =false;
      CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('messages');

      // Convert the MessageModel instance to JSON
      Map<String, dynamic> messageData = message.toJson();

      // Add the data to Firestore and get the document reference
      DocumentReference docRef = await messagesCollection.add(messageData);

      // Update the MessageModel with the generated document ID
      message.id = docRef.id;

      // Optional: Update Firestore document with the generated ID
      await docRef.update({'id': docRef.id});

      log('Message added with ID: ${message.id}');
      return true;
    } catch (error) {
      log('Error adding message: $error');
      throw error;
    }
  }


  static Future<void> updateApprovalStatus(String messageId, String name) async {
    try {
      CollectionReference messagesCollection = FirebaseFirestore.instance.collection('messages');


      await messagesCollection.doc(messageId).update({'isApproved': true, 'approvedDateTime':DateTime.now().toString(), 'approvedByName':name});

      log('Approval status updated for message with ID: $messageId');
    } catch (error) {
      log('Error updating approval status: $error');
      throw error;
    }
  }

  static Future<void> deleteMessage(String messageId) async {
    try {
      CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('messages');

      // Delete the document with the specified messageId
      await messagesCollection.doc(messageId).delete();

      log('Message with ID: $messageId deleted successfully');
    } catch (error) {
      log('Error deleting message: $error');
      throw error;
    }
  }
}