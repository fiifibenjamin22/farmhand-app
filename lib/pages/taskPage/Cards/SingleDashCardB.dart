import 'package:farmhand/constant.dart';
import 'package:farmhand/models/workTask/singleWorkTaskModel.dart';
import 'package:farmhand/widgets/common_arc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class SingleDashCardB extends StatelessWidget {
  final taskindex;
  final orgName;

  final SingleWorkTask taskListData;
  SingleDashCardB({this.taskListData, this.taskindex, this.orgName});
  final equalSpaceinCard = 10.0;

  @override
  Widget build(BuildContext context) {
    var dateData = DateFormat("dd/MM/yyyy")
        .format(DateTime.parse(taskListData.dueDateTime));

    return Padding(
      padding: EdgeInsets.fromLTRB(8, 28, 8, 8),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(60 + equalSpaceinCard, 0, 0, 0),
            child: Arc(
              height: 15.0 + equalSpaceinCard,
              edge: Edge.LEFT,
              arcType: ArcType.CONVEY,
              clipShadows: [
                ClipShadow(color: Colors.blue.shade100, elevation: 10)
              ],
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  // color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(20 + equalSpaceinCard, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: equalSpaceinCard,
                        ),
                        Container(
                          color: priorityColors[taskListData.priorityId - 1],
                          padding: EdgeInsets.all(5),
                          child: Text(
                            priorityIDstatus[taskListData.priorityId - 1],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: textsizein + 2,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: equalSpaceinCard,
                        ),
                        Text(
                          taskListData.name,
                          style: TextStyle(fontSize: textsizein + 10),
                        ),
                        SizedBox(
                          height: equalSpaceinCard,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              flex: 2,
                              child: FittedBox(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.green,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        (organisationNameFormFinal.isNotEmpty &&
                                                taskindex <=
                                                    organisationNameFormFinal
                                                        .length)
                                            ? Text(orgName)
                                            : Text("data")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Flexible(
                              flex: 1,
                              child: FittedBox(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          color: Colors.green,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(dateData),
                                        SizedBox(
                                          width: 4,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
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
          ),
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 45,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset("assets/dashB1.svg"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
