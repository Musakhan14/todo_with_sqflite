import 'package:flutter/material.dart';

void showAlertDialog(String title, String message, BuildContext? context) {
  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(message),
  );
  showDialog(context: context!, builder: (_) => alertDialog);
}
