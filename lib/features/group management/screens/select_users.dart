import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_pool/common/utils/enum_data.dart';
import 'package:share_pool/common/utils/nav_transition_utils.dart';
import 'package:share_pool/features/authentication/widgets/custom_place_holder.dart';
import 'package:share_pool/features/group%20management/screens/add_new_group.dart';

import '../../../common/utils/alert_boxes.dart';
import '../../authentication/widgets/custom_elavated_button.dart';
import '../../users management/model/user_model.dart';
import '../../users management/utils/usermng_utils.dart';


class SelectUserForCreateGroup extends StatefulWidget {
  Nature nature;
  void Function(List<UserModel> selectedUserProfiles)? addNewMembers;
   SelectUserForCreateGroup({this.addNewMembers, required this.nature, super.key});

  @override
  State<SelectUserForCreateGroup> createState() => _SelectUserForCreateGroupState();
}

class _SelectUserForCreateGroupState extends State<SelectUserForCreateGroup> {
  late Future<List<UserModel>> _userProfilesFuture;
  List<UserModel> _userProfiles = [];
  List<UserModel> _selectedUserProfiles= [];


  @override
  void initState() {
    super.initState();
    _userProfilesFuture = fetchUserProfiles();
  }

  Future<List<UserModel>> fetchUserProfiles() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('profiles').get();
      return querySnapshot.docs
          .map((document) => UserModel.fromJson(document.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Select Participants",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
        actions: [
          Text(_selectedUserProfiles.length.toString(),style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
            SizedBox(width: 30,),
        ],
      ),
      body: SafeArea(child: Container(
        margin: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 16),
        child:  Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: FutureBuilder<List<UserModel>>(
                future: _userProfilesFuture,
                builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    );
                  } else {
                    _userProfiles = snapshot.data ?? [];
                    return _userProfiles.isEmpty
                        ? Center(
                      child: CustomPlaceHolder(title: "No users found!", icon: Icons.not_interested_outlined),
                    )
                        : ListView.builder(
                      itemCount: _userProfiles.length,
                      itemBuilder: (context, index) {
                        final UserModel userProfile = _userProfiles[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.comfortable,
                              secondary: CircleAvatar(
                                child: Text(UserMngUtils.getInitials(userProfile.name ?? "")),
                              ),
                              title: Text(
                                userProfile.name ?? "",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              value: userProfile.isSelected ?? false,
                              onChanged: (newValue) {
                                setState(() {
                                  userProfile.isSelected ??= false;
                                  userProfile.isSelected = newValue;
                                  if(userProfile.isSelected!){
                                    _selectedUserProfiles.add(userProfile);
                                  }
                                  else{
                                    _selectedUserProfiles.remove(userProfile);
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),


          SizedBox(height: 10,),
         CustomElevatedButton(
            buttonText: "Next" ,
            onPressed: () {
              if(_selectedUserProfiles.length>=1){
                if(widget.nature == Nature.ADD){
                  Navigator.push(
                    context,
                    TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => AddNewGroup(selectedUserProfiles: _selectedUserProfiles,)),
                  );
                }
                else{
                  widget.addNewMembers!(_selectedUserProfiles);
                 Navigator.pop(context);
                }

              }
              else{

                AlertBoxes.showAlert(
                  context,
                  "Alert",
                  "You must select at least a user to create a group!",
                      () {
                    Navigator.pop(context);
                  },
                );
              }

            },
          ),
          const SizedBox(height: 20,),
        ],),
      ),),

    );
  }
}
