import 'package:farmhand/models/workTask/singleWorkTaskModel.dart';
import 'package:farmhand/widgets/common_arc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../constant.dart';

class CardA extends StatefulWidget {
  final List<Marker> paddockMarkerlabelList;
  final List<Polygon> getpolygondata;
  final liveformloaction;
  final paddockNameListget;
  final mapidgetin;
  final SingleWorkTask getworkTaskSingleData;
  CardA({
    this.getworkTaskSingleData,
    this.getpolygondata,
    this.paddockMarkerlabelList,
    this.liveformloaction,
    this.mapidgetin,
    this.paddockNameListget,
  });

  @override
  _CardAState createState() => _CardAState();
}

class _CardAState extends State<CardA> {
  final double equalSpaceinCard = 10.0;
  bool isLoading = true;
  final double circleRadiusIn = 45;
  String dateData = "";
  String rateUnit = "";
  int colorIndex = 0;
  int workStatusIndex = 0;

  @override
  void initState() {
    super.initState();

    // print(
    //     "1.\n${this.widget.getworkTaskSingleData.worktaskapplication.applicationProduct}");
    // print("2.\n${this.widget.getpolygondata}");
    // print("3.\n${this.widget.paddockMarkerlabelList}");
    // print("4.\n${this.widget.liveformloaction}");
    // print("5.\n${this.widget.mapidgetin}");
    // print("6.\n${this.widget.paddockNameListget}");

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
        if (widget.getworkTaskSingleData != null) {
          print("Work Task Data :: " + widget.getworkTaskSingleData.toString());
          colorIndex = widget.getworkTaskSingleData.priorityId - 1;
          workStatusIndex = widget.getworkTaskSingleData.workTaskStatusId - 1;
          if (workStatusIndex > 4) {
            workStatusIndex = 4;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String dueDateStr = widget.getworkTaskSingleData?.dueDateTime;
    if (dueDateStr != null) {
      print("Date Value :: " + dueDateStr);

      dateData = DateFormat("dd/MM/yyyy").format(DateTime.parse(dueDateStr));
    }

    rateUnit = widget.getworkTaskSingleData?.worktaskapplication?.rateUnitType;

    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 10,
                      spreadRadius: 0.5,
                      offset: Offset(2.0, 2.0),
                    )
                  ],
                ),
                margin: EdgeInsets.fromLTRB(0, circleRadiusIn, 0, 0),
                width: MediaQuery.of(context).size.width,
                child: Arc(
                  height: 50,
                  circleRadius: circleRadiusIn + 6,
                  edge: Edge.TOPCENTER,
                  arcType: ArcType.CONVEY,
                  child: Card(
                    // color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(20 + equalSpaceinCard, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: equalSpaceinCard + 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    size: textsizein + 9,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: equalSpaceinCard - 5,
                                  ),
                                  Text(
                                    dateData,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: textsizein + 6,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    0, 0, equalSpaceinCard + 10, 0),
                                child: Row(
                                  children: [
                                    Container(
                                      color: priorityColors[colorIndex],
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        priorityIDstatus[colorIndex],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: textsizein + 2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: equalSpaceinCard - 5,
                                    ),
                                    Text(
                                      workTaskStatus[workStatusIndex],
                                      style: TextStyle(
                                        fontSize: textsizein + 4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: equalSpaceinCard,
                          ),
                          SizedBox(
                            height: equalSpaceinCard - 5,
                          ),
                          Text(
                            widget.getworkTaskSingleData.name == null
                                ? ""
                                : widget.getworkTaskSingleData.name,
                            style: TextStyle(
                              fontSize: textsizein + 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: equalSpaceinCard - 5,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                0, 0, equalSpaceinCard + 10, 0),
                            child: Text(
                              widget.getworkTaskSingleData.instructions == null
                                  ? "No instructions"
                                  : widget.getworkTaskSingleData.instructions,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: textsizein + 6,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: equalSpaceinCard,
                          ),
                          FittedBox(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Product Name : ",
                                      style: TextStyle(
                                          fontSize: textsizein + 5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      widget
                                                  .getworkTaskSingleData
                                                  .worktaskapplication
                                                  .applicationProduct
                                                  .inventoryItem
                                                  .name ==
                                              null
                                          ? "No Product Name"
                                          : widget
                                              .getworkTaskSingleData
                                              .worktaskapplication
                                              .applicationProduct
                                              .inventoryItem
                                              .name,
                                      style: TextStyle(
                                        fontSize: textsizein + 5,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: equalSpaceinCard,
                          ),
                          FittedBox(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Application Rate : ",
                                      style: TextStyle(
                                        fontSize: textsizein + 5,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      "${widget.getworkTaskSingleData.worktaskapplication.applicationRate == null ? 'No Application Rate' : widget.getworkTaskSingleData.worktaskapplication.applicationRate}",
                                      style: TextStyle(
                                        fontSize: textsizein + 5,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      rateUnit != null ? rateUnit : "",
                                      style: TextStyle(
                                        fontSize: textsizein + 5,
                                        color: Colors.black45,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: equalSpaceinCard,
                          ),
                          FittedBox(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.green,
                                      size: textsizein + 5,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      widget.liveformloaction,
                                      style: TextStyle(
                                          fontSize: textsizein + 5,
                                          color: Colors.black45),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: equalSpaceinCard * 1.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: circleRadiusIn,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgPicture.asset("assets/dashB1.svg"),
                    ),
                  ),
                ),
              )
            ],
          );
  }
}
