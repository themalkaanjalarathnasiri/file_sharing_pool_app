import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_pool/features/notifications/model/activity_model.dart';
import 'package:share_pool/features/notifications/utils/notification_utils_helper.dart';

import '../../authentication/widgets/custom_place_holder.dart';
import '../../users management/utils/usermng_utils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: const  Text("Activity Logs", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
        // ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance
                  .collection('activities').orderBy('dateTime', descending: true).
              snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style:  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: const CircularProgressIndicator()); // Display loading indicator while data is being fetched
                }

                List<ActivityModel> activities = snapshot.data!.docs.map((DocumentSnapshot document) {
                  return ActivityModel.fromJson(document.data() as Map<String, dynamic>);
                }).toList();
                return  activities.isEmpty?Center(
                  child:                           CustomPlaceHolder(title: "No activities found!", icon: Icons.not_interested_outlined ),

                ) :ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final ActivityModel activity = activities[index];
                    return    Card(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                child: Icon(Icons.notifications_active_outlined),
                              ),
                              const SizedBox(width: 10,),
                               Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activity.description??"",
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(
                                      activity.subDescription??"",
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                NotificationUtilsHelper.formatTimestamp( activity.dateTime??""),
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey),
                              ),
                            ],)
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),

      ],),
    );
  }
}
