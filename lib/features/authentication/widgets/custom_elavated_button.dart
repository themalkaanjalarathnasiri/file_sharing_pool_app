import 'package:flutter/material.dart';
import 'package:share_pool/common/theme/app_theme.dart';

class CustomElevatedButton extends StatelessWidget {
  String buttonText;
  void Function() onPressed;
  CustomElevatedButton(
      {required this.buttonText, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          // Change background color
          backgroundColor:
              MaterialStateProperty.all<Color>(AppTheme.primaryColor),
          // Change foreground color (text color)
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          // Add elevation
          elevation: MaterialStateProperty.all<double>(8),
          // Add border radius
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Customize text style
          textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(fontSize: 16),
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: Text(
          buttonText,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black),
        ),
      ),
    );
  }
}
