import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertBoxes{

  static void showAlert(BuildContext context, String title, String message, VoidCallback onClose) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: onClose,
            child: Text('Close'),
          ),
        ],
      ),
    );
  }


  static void showConfirmAlert(BuildContext context, String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              onConfirm(); // Call the onConfirm callback
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }


}