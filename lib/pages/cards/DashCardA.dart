import 'package:farmhand/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashCardA extends StatelessWidget {
  final index;
  DashCardA({this.index});
  @override
  Widget build(BuildContext context) {
    var commonPadding = 10.0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
                dashAA[index]["name"].length > 7
                    ? (commonPadding * 2)
                    : (commonPadding * 3),
                commonPadding / 2,
                dashAA[index]["name"].length > 7
                    ? (commonPadding * 2)
                    : (commonPadding * 3),
                commonPadding / 2),
            decoration: BoxDecoration(
                color: Color.fromRGBO(51, 107, 171, 1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: FittedBox(
              child: Text(
                dashAA[index]["name"],
                style:
                    TextStyle(color: Colors.white, fontSize: textsizein * 1.5),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SvgPicture.asset(
            dashAA[index]["image"],
            height: 80,
          )
        ],
      ),
    );
  }
}
