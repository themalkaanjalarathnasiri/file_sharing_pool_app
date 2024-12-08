import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share_pool/features/authentication/providers/authentication_provider.dart';
import 'package:share_pool/features/group%20management/screens/view_groups.dart';
import 'package:share_pool/features/profile/screens/change_password.dart';
import 'package:share_pool/features/users%20management/screens/manage_users_page.dart';

import '../../../common/utils/alert_boxes.dart';
import '../../../common/utils/enum_data.dart';
import '../../../common/utils/nav_transition_utils.dart';
import '../../notifications/screens/notification_screen.dart';
import '../../profile/screens/my_profile_page.dart';
import '../widgets/settings_list_item.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
    return Scaffold(body: SafeArea( child: Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text("Newnop Co. Ltd", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
        SizedBox(height: 10,),
        Expanded(child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SettingListItem(title: "Profile", icon: Icons.person_outline, onItemTap: () {
              Navigator.push(
                context,
                TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => MyProfilePage()),
              );

            },),
            SettingListItem(title: "Change Password", icon: Icons.password, onItemTap: () {
              Navigator.push(
                context,
                TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => ChangeUserPassword()),
              );
            },),
            SettingListItem(title: "Activities", icon: Icons.notifications_outlined, onItemTap: () {
              Navigator.push(
                context,
                TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => Scaffold(
                    appBar: AppBar(
                      title:Text( "Activity Logs",style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
                    ),
                    body: NotificationScreen())),
              );
            },),
              Visibility(
                visible: authProvider.userData.userRole == Role.ADMIN.name ,
                child: SettingListItem(title: "Manage users", icon: Icons.people_outline, onItemTap: () {
                  Navigator.push(
                    context,
                    TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => ManageUsers()),
                  );
                },),
              ),
              Visibility(
                visible:  authProvider.userData.userRole == Role.ADMIN.name,
                child: SettingListItem(title: "Manage groups", icon: Icons.groups_outlined, onItemTap: () {
                  Navigator.push(
                    context,
                    TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => ViewGroupsScreen()),
                  );
                },),
              ),

            SettingListItem(title: "Help & feedback", icon: Icons.help_outline, onItemTap: () {  },),
            SettingListItem(title: "About", icon: Icons.info_outline_rounded, onItemTap: () {  },),
            SettingListItem(title: "Privacy", icon: Icons.lock_outline_rounded, onItemTap: () {  },),
            SettingListItem(title: "Sign out", icon: Icons.exit_to_app_outlined, onItemTap: () {
              AlertBoxes.showConfirmAlert(
                context,
                "Confirmation",
                "Are you sure you want sign out?",
                    () {
                      final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
                      authProvider.signOut(context);
                },
              );

            },)
          ],),
        ))
      ],),
    ),),);
  }
}
