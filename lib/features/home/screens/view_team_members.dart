import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share_pool/features/group%20management/model/group_model.dart';

import '../../file management/utils/group_role_helper.dart';
import '../../users management/utils/usermng_utils.dart';

class ViewTeamMembers extends StatefulWidget {
  GroupModel group;
   ViewTeamMembers({required this.group, super.key});

  @override
  State<ViewTeamMembers> createState() => _ViewTeamMembersState();
}

class _ViewTeamMembersState extends State<ViewTeamMembers> {


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:  Text("Members of ${widget.group.groupName}",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
      ),
      body: SafeArea(child: Container(
        margin: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 16),
        child:  Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.group.participants!=null? widget.group.participants!.length.toString() + " members": '0 members', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, ),),
            SizedBox(height: 10,),
           Expanded(
             child: ListView.builder(
               itemCount: widget.group.participants!.length,
               itemBuilder: (context, index) {
                 var member=  widget.group.participants![index];
               return  Card(
                 child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                       CircleAvatar(
                         child: Text(UserMngUtils.getInitials(member.name??"")),
                       ),
                       SizedBox(width: 10,),
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               member.name??"N/A",
                               style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                             ),
                              SizedBox(height: 3,),
                             Text(
                               GroupRolesHelper.getGroupRole(member.groupRole!) == "SENDERNVIEWER"? "SENDER/VIEWER": GroupRolesHelper.getGroupRole(member.groupRole!),
                               style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey),
                             ),
                           ],
                         ),
                       ),
                     ],)
                 ),
               );
             },),
           )
          ],),
      ),),

    );
  }
}
