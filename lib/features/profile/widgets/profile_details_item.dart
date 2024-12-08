import 'package:flutter/material.dart';

class ProfileDetailsCardItem extends StatelessWidget {
  String title;
  String value;
   ProfileDetailsCardItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 0.3,height: 0,),
        const SizedBox(height: 10,),
        Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w300, color: Colors.grey),),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(value,style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
        ),
        SizedBox(height: 10,),
      ],);
  }
}
