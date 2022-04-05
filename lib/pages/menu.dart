import 'dart:ui';

import 'package:farmhand/constant.dart';
import 'package:farmhand/pages/cards/DashCardA.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';

showdialogFormMenu(context) {
  showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
          child: Card(
            margin: EdgeInsets.all(0),
            elevation: 0,
            shadowColor: Colors.transparent,
            borderOnForeground: false,
            color: Colors.white.withOpacity(0.5),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: CloseButton(),
                ),
                Spacer(),
                Text(
                  "MENU",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(28.0),
                  child: StaggeredGridView.countBuilder(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 20,
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                    itemCount: dashAA.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => true
                          ? Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => dashAA[index]["nav"],
                              ),
                            )
                          // ignore: dead_code
                          : Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => dashAA[index]["nav"]),
                              (router) => false,
                            ),
                      child: DashCardA(
                        index: index,
                      ),
                    ),
                    shrinkWrap: true,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        );
      });
}
