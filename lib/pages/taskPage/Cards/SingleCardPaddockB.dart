import 'package:farmhand/constant.dart';
import 'package:farmhand/models/workTask/putWorkTaskModel.dart';
import 'package:farmhand/pages/taskPage/extensions/SingleCardPaddockBExt.dart';
import 'package:farmhand/providers/workTaskDataProviders.dart';
import 'package:farmhand/widgets/common_arc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong/latlong.dart';
import 'package:geodesy/geodesy.dart';

class SingleCardPaddockB extends StatefulWidget {
  final List paddockName;
  final List<LatLng> polygonDataPoint;
  final paddockIndex;
  final List<Color> commonColors;
  final List<String> buttonCheckString;
  SingleCardPaddockB(
      {this.polygonDataPoint,
      this.paddockIndex,
      this.commonColors,
      this.paddockName,
      this.buttonCheckString});
  @override
  SingleCardPaddockBState createState() => SingleCardPaddockBState();
}

class SingleCardPaddockBState extends State<SingleCardPaddockB> {
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  bool isReRenderingAllowed = true;
  List<Paddocks> paddockLocalDoneTask = [];

  Geodesy geodesy = Geodesy();

  @override
  Widget build(BuildContext context) {
    var paddockDoneTaskGet = Provider.of<WorkTaskDataProvider>(context);
    checkTaskComplete(paddockDoneTaskGet);

    double equalSpaceInCard = widthin * 5;
    double commonBorderRadius = 25;
    return widget.commonColors[widget.paddockIndex] != Colors.blue
        ? GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 16),
              child: Stack(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(0, 0, 45 + equalSpaceInCard, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(commonBorderRadius),
                          bottomLeft: Radius.circular(commonBorderRadius),
                        ),
                        color:
                            // buttonColor,
                            widget.commonColors[widget.paddockIndex],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 6.0,
                            spreadRadius: 1.0,
                            offset: Offset(2.0, 2.0),
                          )
                        ],
                      ),
                      child: Arc(
                        height: equalSpaceInCard,
                        edge: Edge.RIGHT,
                        arcType: ArcType.CONVEY,
                        clipShadows: [
                          ClipShadow(color: Colors.transparent, elevation: 0)
                        ],
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 0,
                            margin: EdgeInsets.all(1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(commonBorderRadius),
                                bottomLeft: Radius.circular(commonBorderRadius),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  10 + equalSpaceInCard, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: equalSpaceInCard + 3,
                                  ),
                                  Text(
                                    widget.paddockName[widget.paddockIndex]
                                        ["name"],
                                    style: TextStyle(
                                        fontSize: textsizein + 10,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: equalSpaceInCard + 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: equalSpaceInCard - 8,
                    bottom: 0,
                    child: SizedBox(
                      width: equalSpaceInCard + 51,
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(equalSpaceInCard + 15),
                        ),
                        color: Color(0xfff9f9f9),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: equalSpaceInCard - 10,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          setState(() {
                            navigateFromCard(paddockDoneTaskGet);
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor:
                              widget.commonColors[widget.paddockIndex],
                          radius: equalSpaceInCard * 1.7,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                              child: Text(
                                widget.buttonCheckString[widget.paddockIndex],
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
