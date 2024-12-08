import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share_pool/common/utils/alert_boxes.dart';
import 'package:share_pool/features/authentication/widgets/custom_text_form_field.dart';
import 'package:share_pool/features/group%20management/model/group_model.dart';
import 'package:share_pool/features/group%20management/model/participant_model.dart';
import 'package:share_pool/features/group%20management/model/privileage_model.dart';
import 'package:share_pool/features/group%20management/services/group_mng_service.dart';
import 'package:share_pool/features/group%20management/utils/group_mng_textfield_validator.dart';
import 'package:share_pool/features/users%20management/utils/usermng_utils.dart';

import '../../../common/theme/app_theme.dart';
import '../../authentication/widgets/custom_elavated_button.dart';
import '../../users management/model/user_model.dart';

class AddNewGroup extends StatefulWidget {
  List<UserModel> selectedUserProfiles= [];
   AddNewGroup({super.key, required this.selectedUserProfiles});

  @override
  State<AddNewGroup> createState() => _AddNewGroupState();
}

class _AddNewGroupState extends State<AddNewGroup> {
  final TextEditingController _groupNameController = TextEditingController();
  bool _isLoading =false;
  final _formKey = GlobalKey<FormState>();
  List<bool> _isCheckedList = List.generate(5, (index) => false); // Initial list of checkbox states
  List<ParticipantModel> participants=  [];

  @override
  void initState(){
    super.initState();
    mapSelectedUsersToParticipantModel();
  }

  void mapSelectedUsersToParticipantModel(){
    for(int i = 0; i < widget.selectedUserProfiles.length; i++){
      var user = widget.selectedUserProfiles[i];
      participants.add(  ParticipantModel(name: user.name, email: user.email, groupRole: [GroupRole(roleName: "Team Lead", isActive: false),
        GroupRole(roleName: "Sender", isActive: true),
        GroupRole(roleName: "Viewer", isActive: true),]),);
    }

  }


  Future<void> createNewGroup() async{
    try{
      if(mounted){
        setState(() {
          _isLoading = true;
        });
      }
      //create group instance
      GroupModel group = GroupModel();
      group.groupName = _groupNameController.text.trim();
      group.participants = participants;
      List<String> participantsEmails = [];
      for(int i = 0; i<participants.length;i ++){
        var p = participants[i];
        participantsEmails.add(p.email!);
      }
      group.participantEmails = participantsEmails;
      bool _isSuccess = await GroupMngService.addGroupToFirestore(group);
      if(_isSuccess==true){
        AlertBoxes.showAlert(
          context,
          "Success",
          "Group has been created successfully!",
              () {
            Navigator.pop(context);Navigator.pop(context);
            Navigator.pop(context);
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
        title:  Text("New Group",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
      ),
      body: SafeArea(child: Container(
        margin: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 16),
        child:  Form(
          key:_formKey ,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Enter group's details below.", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, ),),
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
            Text("Members ${participants.length}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, ),),
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
              buttonText: "Create" ,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                    if(participants.length>=2){

                      createNewGroup();
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
