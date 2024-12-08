import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share_pool/common/utils/enum_data.dart';
import 'package:share_pool/common/utils/nav_transition_utils.dart';
import 'package:share_pool/features/authentication/providers/authentication_provider.dart';
import 'package:share_pool/features/authentication/widgets/custom_place_holder.dart';
import 'package:share_pool/features/file%20management/screens/group_details_page.dart';
import 'package:share_pool/features/file%20management/utils/group_role_helper.dart';
import 'package:share_pool/features/home/screens/view_team_members.dart';
import 'package:share_pool/features/home/utils/home_utils.dart';
import 'package:share_pool/features/home/widgets/group_list_item.dart';

import '../../group management/model/group_model.dart';
import '../../group management/screens/edit_groups.dart';

class MyTeamsPage extends StatefulWidget {
  const MyTeamsPage({super.key});

  @override
  State<MyTeamsPage> createState() => _MyTeamsPageState();
}

class _MyTeamsPageState extends State<MyTeamsPage> {
  String getUserGroupRole(GroupModel group){
    final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
    for(int i = 0; i < group.participants!.length; i++){
      var parti = group.participants![i];
      if(parti.email == authProvider.userData.email){
        var groupRole = GroupRolesHelper.getGroupRole(parti.groupRole!);
        return groupRole;
      }
    }

    return GroupRoleType.UNKNOWN.name;
  }

  Stream<QuerySnapshot<Object?>>? getQuery(){
    final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
    if(authProvider.userData.userRole == Role.ADMIN.name){
      return FirebaseFirestore.instance
          .collection('groups')
          .snapshots();
    }else{
      FirebaseFirestore.instance
          .collection('groups')
          .where('participantEmails', arrayContains: authProvider.userData.email)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
    return Scaffold(body: SafeArea(child: Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      const  Text("Your groups", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
      const SizedBox(height: 10,),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance
                  .collection('groups')
                  .where('participantEmails', arrayContains: authProvider.userData.email)
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
                  child:                           CustomPlaceHolder(title: "No groups found!", icon: Icons.not_interested_outlined ),

                ) :ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final GroupModel group = groups[index];
                    return GroupListItemTile(
                      showSeemore: true,
                      groupTitle: group.groupName??"n/a",
                      onGroupTap: (){
                        Navigator.push(
                          context,
                          TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => GroupDetailsPage(group: group,)),
                        );
                      },
                      menuWidgets: [
                        if(getUserGroupRole(group) == GroupRoleType.TEAMLEAD.name || authProvider.userData.userRole== Role.ADMIN.name)
                        PopupMenuItem(
                          child: Text('Edit Group'),
                          onTap: (){
                            Navigator.push(
                              context,
                              TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => EditGroups(group: group,)),
                            );
                          },
                        ),
                        PopupMenuItem(
                          child: Text('View Members'),
                          onTap: (){
                            Navigator.push(
                              context,
                              TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => ViewTeamMembers(group: group,)),
                            );
                          },
                        ),


                      ],
                      onSeeMoreTap: (){


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
