import 'dart:convert';

import 'package:farmhand/constant.dart';
import 'package:farmhand/models/person_details.dart';
import 'package:farmhand/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashCardA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var commonPadding = 10.0;
    int index = 0;

    Map personDetailsMap = json.decode(
        Utils.getStringFromPreferences(SharedOfflineData().personDetails));

    PersonDetails personDetails = PersonDetails.fromJson(personDetailsMap);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(commonPadding * 3, commonPadding / 2,
                commonPadding * 3, commonPadding / 2),
            decoration: BoxDecoration(
                color: Color.fromRGBO(51, 107, 171, 1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Text(
              dashA[index]["name"],
              style: TextStyle(color: Colors.white),
            ),
          ),
          FittedBox(
            child: Text(
              personDetails.organisations.length.toString(),
              style: TextStyle(
                  fontSize: textsizein * commonPadding / 1.5,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(32, 56, 37, 1)),
            ),
          ),
          SvgPicture.asset(dashA[index]["image"])
        ],
      ),
    );
  }
}
