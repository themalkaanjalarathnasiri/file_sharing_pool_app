import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share_pool/common/utils/enum_data.dart';
import 'package:share_pool/features/home/screens/my_teams_page.dart';
import 'package:share_pool/features/home/screens/settings_page.dart';

import '../../../common/theme/app_theme.dart';
import '../../../common/utils/alert_boxes.dart';
import '../../../common/utils/nav_transition_utils.dart';
import '../../authentication/providers/authentication_provider.dart';
import '../../group management/screens/view_groups.dart';
import '../../notifications/screens/notification_screen.dart';
import '../../users management/screens/manage_users_page.dart';


class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  int _selectedIndex =1;
  int newActivityCount =0;
  int oldActivityCount =0;

  @override
  void initState(){
    super.initState();
    // Set up a listener to listen for changes in the "notification" collection
    FirebaseFirestore.instance.collection('activities').snapshots().listen((snapshot) {
      // Update the new message count based on the total number of documents in the collection
      setState(() {
        newActivityCount = snapshot.docs.length;
        if(oldActivityCount == 0){
          oldActivityCount = snapshot.docs.length;
        }
      });
    });
  }




  static const List<Widget> _widgetOptions = <Widget>[
    NotificationScreen(),
    MyTeamsPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(index ==0){
        oldActivityCount = newActivityCount;
      }
    });
  }

  String getScreenTitle(){
    if(_selectedIndex ==0){
      return "Activity";
    }
    else if(_selectedIndex ==1){
      return "Groups";
    }
    else{
      return "Settings";
    }
  }

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text( getScreenTitle(),style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
        // Adding a button to open the drawer
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 8, bottom: 8, top: 8,),
              child: GestureDetector(
                child:  const CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: Icon(Icons.person, color: Colors.black, ),),
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            );
          },
        ),
    //  actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_none))],
        toolbarHeight: 80,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.notifications_outlined),
                Visibility(
                  visible: oldActivityCount!= newActivityCount,
                  child: Positioned(
                    right: -10,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),),
                    ),
                  ),
                ),
              ],
            ),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.primaryColor,
        onTap: _onItemTapped,
      ),
      // Adding the drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              curve:Curves.bounceIn ,
              padding: const EdgeInsets.only(left: 0,right: 16,bottom: 16, top: 16),
              decoration: const BoxDecoration(
              //  color: Colors.blue,
              ),
              child:  ListTile(
                title:  Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(child: Icon(Icons.person, ),),
                    const SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment .start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(authProvider.userData.name??"N/A",style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),

                            const SizedBox(width: 5,),
                             const Icon(Icons.arrow_forward_ios_outlined, size: 12,)
                          ],
                        ),
                        Text(authProvider.userData.position??"N/A", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w300, color: Colors.grey),),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  // Add your navigation logic here
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.settings, size: 18,),
                  SizedBox(width: 10,),
                  Text('Settings',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
                ],
              ),
              onTap: () {
                // Add your navigation logic here
                Navigator.pop(context);
                Navigator.push(
                  context,
                  TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => Scaffold(
                      appBar: AppBar(
                        title:Text( "Settings",style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
                      ),
                      body: SettingsPage())),
                );
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.notifications_none, size: 18,),
                  SizedBox(width: 10,),
                  Text('Activity logs',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
                ],
              ),
              onTap: () {
                // Add your navigation logic here
                Navigator.pop(context);
                Navigator.push(
                  context,
                  TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => Scaffold(
                      appBar: AppBar(
                        title:Text( "Activity Logs",style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
                      ),
                      body: NotificationScreen())),
                );
              },
            ),
            Visibility(
              visible:  authProvider.userData.userRole == Role.ADMIN.name,
              child: ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.group, size: 18,),
                    SizedBox(width: 10,),
                    Text('Create new group',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white), ),
                  ],
                ),
                onTap: () {
                  // Add your navigation logic here
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => const ViewGroupsScreen()),
                  );
                },
              ),
            ),
            Visibility(
              visible:  authProvider.userData.userRole == Role.ADMIN.name,
              child: ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.add, size: 18,),
                    SizedBox(width: 10,),
                    Text('Add new user',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white), ),
                  ],
                ),
                onTap: () {
                  // Add your navigation logic here
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => const ManageUsers()),
                  );
                },
              ),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.exit_to_app, size: 18,),
                  SizedBox(width: 10,),
                  Text('Sign out',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white), ),
                ],
              ),
              onTap: () {
                AlertBoxes.showConfirmAlert(
                  context,
                  "Confirmation",
                  "Are you sure you want sign out?",
                      () {
                    final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
                    authProvider.signOut(context);
                  },
                );
              },
            ),
            // Add more ListTiles for additional menu items
          ],
        ),
      ),
    );
  }
}
