import 'package:farmhand/pages/taskPage/SingleCardNoteC.dart';
import 'package:flutter/material.dart';
import '../../constant.dart';

class CardC extends StatelessWidget {
  final double equalSpace = 10.0;
  final double equalSpaceinCard = widthin * 5;
  final double commonBorderRadius = 20;

  @override
  Widget build(BuildContext context) {
    double equalSpace = 10.0;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(equalSpace + 10, 0, 0, 0),
            child: Text(
              "NOTES",
              style: TextStyle(
                color: Color(0xFF336BAB),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SingleCardNoteC()
      ],
    );
  }
}
