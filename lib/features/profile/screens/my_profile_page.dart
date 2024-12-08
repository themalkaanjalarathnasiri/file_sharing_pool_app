import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share_pool/common/theme/app_theme.dart';
import 'package:share_pool/features/authentication/providers/authentication_provider.dart';
import 'package:share_pool/features/profile/widgets/profile_details_item.dart';
import 'package:share_pool/features/users%20management/model/user_model.dart';

import '../../authentication/widgets/custom_place_holder.dart';


class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title:  Text(authProvider.userData?.name??"",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
      ),
      body: SafeArea(child: Container(
        margin: const EdgeInsets.all(16),
        child:  Column(children: [
          SizedBox(height: 20,),
          Align(
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.person_outline, color: Colors.black,size: 50, ),),
          ),
        
        SizedBox(height: 20,),
          Column(
            children: [
              Text('Software Developer',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
              SizedBox(height: 5,),
              Text('IT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300, color: Colors.grey),),
            ],
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('profiles').doc(authProvider.getCurrentUser()!.email!).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                ); // Display loading indicator while data is being fetched
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(
                  child: CustomPlaceHolder(
                    title: "No profile found!",
                    icon: Icons.not_interested_outlined,
                  ),
                );
              }

              UserModel userProfile = UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);


              return Column(children: [
                SizedBox(height: 20,),
                ProfileDetailsCardItem(title: "Email", value: userProfile.email?? authProvider.userData.email!,),
                ProfileDetailsCardItem(title: "Mobile phone", value: userProfile.mobile?? authProvider.userData.mobile!,),
                ProfileDetailsCardItem(title: "Office location", value: userProfile.officeLocation?? authProvider.userData.officeLocation!,),
              ],);
            },
          ),


        ],),
      ),),);
  }
}
