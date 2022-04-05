import 'package:flutter/material.dart';

showConfirmationDialog(context, String message, Function okin, bool changerIN) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return null;
    },
    transitionDuration: Duration(milliseconds: 500),
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (BuildContext context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(message,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            actions: <Widget>[
              TextButton(
                child: changerIN
                    ? Text(
                        'Ok',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )
                    : Text(
                        'Yes',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                onPressed: okin,
              ),
              TextButton(
                child: changerIN
                    ? Text('Cancel',
                        style: TextStyle(fontWeight: FontWeight.bold))
                    : Text(
                        'No',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
