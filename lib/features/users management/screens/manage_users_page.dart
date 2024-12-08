import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share_pool/common/theme/app_theme.dart';
import 'package:share_pool/common/utils/enum_data.dart';
import 'package:share_pool/features/authentication/widgets/custom_place_holder.dart';
import 'package:share_pool/features/users%20management/screens/add_new_user.dart';

import '../../../common/utils/nav_transition_utils.dart';
import '../model/user_model.dart';
import '../utils/usermng_utils.dart';


class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Manage Users",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),

      ),
      body: SafeArea(child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children:[
            const Text("Users Management", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),),
            const SizedBox(height: 5,),
          const Text("Manage users within the organization", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
          const SizedBox(height: 20,),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('profiles').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style:  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: const CircularProgressIndicator()); // Display loading indicator while data is being fetched
                  }
              
                  List<UserModel> userProfiles = snapshot.data!.docs.map((DocumentSnapshot document) {
                    return UserModel.fromJson(document.data() as Map<String, dynamic>);
                  }).toList();
                  return  userProfiles.isEmpty?Center(
                    child:                           CustomPlaceHolder(title: "No accounts found!", icon: Icons.not_interested_outlined ),

                  ) :ListView.builder(
                    itemCount: userProfiles.length,
                    itemBuilder: (context, index) {
                      final UserModel userProfile = userProfiles[index];
                     return Card(
                       clipBehavior: Clip.antiAlias,
                       elevation: 4.0,
                       child: ListTile(
                         leading: CircleAvatar(
                           child: Text(UserMngUtils.getInitials(userProfile.name??""),),
                         ),
                         title: Text(
                           userProfile.name??"N/A",
                           style: const TextStyle(
                             fontWeight: FontWeight.bold, fontSize: 13,
                           ),
                         ),
                         subtitle:  Text(userProfile.position??"N/A",style: const TextStyle(
                           fontWeight: FontWeight.w200, fontSize: 12,
                         ),), // Example department
                         // trailing: IconButton(
                         //   icon: const Icon(Icons.delete_outline),
                         //   onPressed: () {
                         //     // Implement edit user functionality
                         //   },
                         // ),
                         onTap: () {
                           Navigator.push(
                             context,
                             TransitionUtils.slideTransitionFromRightToLeft(builder: (_) =>  AddNewUserPage(nature: Nature.EDIT,userData:userProfile ,)),
                           );
                         },
                       ),
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
              TransitionUtils.slideTransitionFromRightToLeft(builder: (_) =>  AddNewUserPage(nature: Nature.ADD,)),
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
