import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_pool/common/utils/nav_transition_utils.dart';
import 'package:share_pool/features/authentication/widgets/custom_place_holder.dart';
import 'package:share_pool/features/file%20management/model/message_model.dart';
import 'package:share_pool/features/file%20management/screens/group_details_page.dart';
import 'package:share_pool/features/group%20management/model/group_model.dart';
import 'package:share_pool/features/home/widgets/group_list_item.dart';

import '../../../common/widgets/bottom_sheets.dart';

class SelectGroupPage extends StatefulWidget {
  void Function(GroupModel group) onGroupTap;
  SelectGroupPage({super.key, required this.onGroupTap});

  @override
  State<SelectGroupPage> createState() => _SelectGroupPageState();
}

class _SelectGroupPageState extends State<SelectGroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text( "Select a group to send a file",style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
      ),
      body: SafeArea(child: Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),


          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance
                  .collection('groups')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style:  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: const CircularProgressIndicator()); // Display loading indicator while data is being fetched
                }

                List<GroupModel> groups = snapshot.data!.docs.map((DocumentSnapshot document) {
                  return GroupModel.fromJson(document.data() as Map<String, dynamic>);
                }).toList();
                return  groups.isEmpty?Center(
                  child:  CustomPlaceHolder(title: "No groups found!", icon: Icons.not_interested_outlined ),

                ) :ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final GroupModel group = groups[index];
                    return GroupListItemTile(
                      groupTitle: group.groupName??"n/a",
                      onGroupTap: (){
                        widget.onGroupTap(group);
                      },
                      onSeeMoreTap: (){
                        CustomBottomSheets.showBottomMenu(context: context,widgets: [
                          ListTile(
                            leading: const Icon(Icons.edit_calendar_outlined, size: 19,),
                            title: const Text('Edit Group',style: TextStyle(fontSize:14,  ),),
                            onTap: () async {

                            },
                          ),
                          Visibility(
                            child: ListTile(
                              leading: const Icon(Icons.remove_red_eye_outlined, size: 19,),
                              title:const Text('View Participants',style: TextStyle(fontSize:14, ),),
                              onTap: () {
                                Navigator.pop(context); // Close the bottom sheet
                                // Add your delete logic here
                              },
                            ),
                          ),
                          Visibility(
                            child: ListTile(
                              leading: const Icon(Icons.delete, size: 19,),
                              title: const Text('Delete',style: TextStyle(fontSize:14,  ),),
                              onTap: () {
                                // Add your edit logic here
                              },
                            ),
                          ),

                        ]);


                      },
                    );
                  },
                );
              },
            ),
          )

        ],),
    ),),);
  }
}
