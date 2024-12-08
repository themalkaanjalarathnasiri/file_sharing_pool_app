import 'package:flutter/material.dart';

class SettingListItem extends StatelessWidget {
  String title;
  IconData icon;
  void Function() onItemTap;
   SettingListItem({super.key, required this.title, required this.icon, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
      child: Container(
        child: Row(children: [
          Icon(icon, color:  Colors.grey.shade400,),
          const SizedBox(width: 30,),
          Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade400),),
          const Spacer(),
          const Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_forward_ios, size: 14,)),
        ],),
      ),
    ), onTap: (){
      onItemTap();
    },);
  }
}
