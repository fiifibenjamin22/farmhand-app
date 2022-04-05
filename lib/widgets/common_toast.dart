import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void showToast(String msgIN, BuildContext context,
    {int durationIN, int gravityIN}) {
  Toast.show(msgIN, context, duration: durationIN, gravity: gravityIN);
}
