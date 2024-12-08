import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_pool/common/utils/enum_data.dart';
import 'package:share_pool/common/utils/nav_transition_utils.dart';
import 'package:share_pool/features/group%20management/model/group_model.dart';
import 'package:share_pool/features/group%20management/screens/add_new_group.dart';
import 'package:share_pool/features/group%20management/screens/edit_groups.dart';
import 'package:share_pool/features/group%20management/screens/select_users.dart';
import 'package:share_pool/features/home/widgets/group_list_item.dart';

import '../../authentication/widgets/custom_place_holder.dart';

class ViewGroupsScreen extends StatelessWidget {
  const ViewGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Manage Groups",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
      ),
      body: SafeArea(child: Container(
        margin: const EdgeInsets.all(16),
        child:  Column(children: [

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('groups').snapshots(),
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
                  child:                           CustomPlaceHolder(title: "No groups found!", icon: Icons.not_interested_outlined ),

                ) :ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final GroupModel group = groups[index];
                    return GroupListItemTile(
                      groupTitle: group.groupName??"n/a",
                      onGroupTap: (){
                        Navigator.push(
                          context,
                          TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => EditGroups(group: group,)),
                        );
                      },
                      onSeeMoreTap: (){},
                    );
                  },
                );
              },
            ),
          )
        ],),
      ),),

      floatingActionButton: Container(
        width: 120,
        child: FloatingActionButton(
          onPressed: (){
            Navigator.push(
              context,
              TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => SelectUserForCreateGroup(nature: Nature.ADD,)),
            );
          },child:  Padding(
          padding:  const EdgeInsets.only(left: 10),
          child: Row(children: [Icon(Icons.add_circle_outline_rounded, color: Colors.grey.shade800,), const SizedBox(width: 5,),Text("Add new", style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14,color: Colors.grey.shade800
          ),),],),
        ),),
      ),
    );
  }
}
