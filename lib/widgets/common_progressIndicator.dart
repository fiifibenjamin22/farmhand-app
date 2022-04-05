import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
ProgIndicator(context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        );
      });
}
