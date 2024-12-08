import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:share_pool/common/utils/alert_boxes.dart';
import 'package:share_pool/common/utils/nav_transition_utils.dart';
import 'package:share_pool/features/authentication/widgets/custom_elavated_button.dart';
import 'package:share_pool/features/authentication/widgets/custom_text_form_field.dart';
import 'package:share_pool/features/group%20management/model/privileage_model.dart';
import 'package:share_pool/features/group%20management/screens/select_users.dart';
import 'package:share_pool/features/group%20management/services/group_mng_service.dart';

import '../../../common/utils/enum_data.dart';
import '../../users management/utils/usermng_utils.dart';
import '../model/group_model.dart';
import '../model/participant_model.dart';
import '../utils/group_mng_textfield_validator.dart';


class EditGroups extends StatefulWidget {
  GroupModel group;
   EditGroups({super.key, required this.group});

  @override
  State<EditGroups> createState() => _EditGroupsState();
}

class _EditGroupsState extends State<EditGroups> {
  @override
  final TextEditingController _groupNameController = TextEditingController();
  bool _isLoading =false;
  final _formKey = GlobalKey<FormState>();
  List<ParticipantModel> participants=  [];

  @override
  void initState(){
    super.initState();
    //mapSelectedUsersToParticipantModel();
    _groupNameController.text  = widget.group.groupName??"";
    participants = widget.group.participants??[];
  }

  // void mapSelectedUsersToParticipantModel(){
  //   for(int i = 0; i < widget.selectedUserProfiles.length; i++){
  //     var user = widget.selectedUserProfiles[i];
  //     participants.add(  ParticipantModel(name: user.name, email: user.email, groupRole: [GroupRole(roleName: "Team Lead", isActive: false),
  //       GroupRole(roleName: "Sender", isActive: true),
  //       GroupRole(roleName: "Viewer", isActive: true),]),);
  //   }
  //
  // }


  Future<void> updateGroup() async{
    try{
      if(mounted){
        setState(() {
          _isLoading = true;
        });
      }
      widget.group.groupName = _groupNameController.text.trim();
      widget.group.participants = participants;
      List<String> participantsEmails = [];
      for(int i = 0; i<participants.length;i++){
        var p = participants[i];
        participantsEmails.add(p.email!);
      }
      widget.group.participantEmails = participantsEmails;
      bool _isSuccess = await GroupMngService.updateGroupInFirestore( widget.group);
      if(_isSuccess==true){
        AlertBoxes.showAlert(
          context,
          "Success",
          "Group has been updted successfully!",
              () {
            Navigator.pop(context);Navigator.pop(context);
          },
        );
      }
    }
    catch(e){
      log(e.toString());
      AlertBoxes.showAlert(
        context,
        "Error",
        e.toString(),
            () {
          Navigator.pop(context);
        },
      );
    }
    finally{
      if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  Future<void> deleteGroup() async{
    try{
      if(mounted){
        setState(() {
          _isLoading = true;
        });
      }
      bool _isSuccess = await GroupMngService.deleteGroupFromFirestore(widget.group.groupId!);
      if(_isSuccess==true){
        AlertBoxes.showAlert(
          context,
          "Success",
          "Group has been deleted successfully!",
              () {
            Navigator.pop(context);Navigator.pop(context);
          },
        );
      }
    }
    catch(e){
      log(e.toString());
      AlertBoxes.showAlert(
        context,
        "Error",
        e.toString(),
            () {
          Navigator.pop(context);
        },
      );
    }
    finally{
      if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.group.groupName??"",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
      ),
      body: SafeArea(child: Container(
        margin: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 16),
        child:  Form(
          key:_formKey ,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Update group's details below.", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, ),),
                IconButton(onPressed: (){
                  AlertBoxes.showConfirmAlert(
                    context,
                    "Confirmation",
                    "Are you sure you want to delete this group?",
                        () {
                      deleteGroup();
                    },
                  );

                }, icon: Icon(Icons.remove_circle_outline, color: Colors.red,))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              controller: _groupNameController,
              keyboardType: TextInputType.name,
              hintText: "Enter group name",
              validator: GroupMngTextfieldValidatior.validateName,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text("Members ${participants.length}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, ),),
                IconButton(onPressed: (){
                  Navigator.push(
                    context,
                    TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => SelectUserForCreateGroup(nature: Nature.EDIT,addNewMembers: (newMembers){

                      for(int i = 0; i < newMembers.length; i++){
                        var user = newMembers[i];
                        bool isFound =false;
                        for(int j= 0; j<participants.length; j++){
                          var existUser = participants[i];
                          if(user.email == existUser.email){
                            isFound = true;
                            break;
                          }
                        }
                        if(!isFound)
                        {
                          setState(() {
                            participants.add(  ParticipantModel(name: user.name, email: user.email, groupRole: [GroupRole(roleName: "Team Lead", isActive: false),
                              GroupRole(roleName: "Sender", isActive: true),
                              GroupRole(roleName: "Viewer", isActive: true),]),);
                          });
                        }

                      }
                    },)),
                  );
                }, icon: Icon(Icons.add_circle_outline_rounded, color: Colors.blueAccent,))

              ],
            ),
            const SizedBox(
              height: 20,
            ),

            Expanded(
              child: GridView.builder(
                itemCount: participants.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid
                  crossAxisSpacing: 10.0, // Spacing between columns
                  mainAxisSpacing: 10.0, // Spacing between rows
                  childAspectRatio: 0.5, // Aspect ratio of each grid item
                ),  itemBuilder: (context, pindex) {
                var participant = participants[pindex];
                return    Card(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(children: [
                        SizedBox(height: 10,),
                        Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          participant.name??"",style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),),
                        SizedBox(height: 15,),
                        CircleAvatar(
                          child: Text(UserMngUtils.getInitials(participant.name ?? "")),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          height: 150,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: participant.groupRole!.length,
                            itemBuilder: (context, index) {
                              var role =  participant.groupRole![index];
                              return CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                visualDensity:VisualDensity.comfortable ,
                                title: Text(role.roleName??"", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, ),),
                                value: role.isActive,
                                onChanged: (newValue) {
                                  setState(() {
                                    role.isActive = newValue!;
                                    if(index == 0 && newValue){
                                      participants[pindex].groupRole![0].isActive = true;
                                      participants[pindex].groupRole![1].isActive = true;
                                      participants[pindex].groupRole![2].isActive = true;
                                    }

                                    if( participants[pindex].groupRole![0].isActive == false &&participants[pindex].groupRole![1].isActive == false && participants[pindex].groupRole![2].isActive == false){
                                      participants[pindex].groupRole![2].isActive = true;
                                      return;
                                    }

                                  });
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10,),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              participants.remove(participant);
                            });
                          },
                          child: Text("Remove", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:Colors.red , // Red color for delete button
                          ),
                        ),
                      ],),
                    ),
                  ),
                );
              },),
            ),


            SizedBox(height: 10,),
            _isLoading?const Align(
                alignment: Alignment.topCenter,
                child: CircularProgressIndicator()):CustomElevatedButton(
              buttonText: "Update" ,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if(participants.length>=2){

                    updateGroup();
                  }
                  else{
                    AlertBoxes.showAlert(
                      context,
                      "Error",
                      "You must select at least two members to create a group!",
                          () {
                        Navigator.pop(context);
                      },
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 20,),
          ],),
        ),
      ),),

    );
  }
}
