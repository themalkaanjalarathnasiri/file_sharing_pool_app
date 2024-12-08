import 'package:flutter/material.dart';

class CustomPlaceHolder extends StatelessWidget {
  String title;
  IconData icon;
   CustomPlaceHolder({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20,),
        Icon(icon, size: 60,),
        const SizedBox(height: 10,),
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),),
      ],);
  }
}
