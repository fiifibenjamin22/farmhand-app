import 'package:farmhand/models/organisation.dart';
import 'package:farmhand/models/storage_locations/storage_locations.dart';
import 'package:farmhand/utils/common_utils.dart';
import 'package:farmhand/widgets/common_arc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constant.dart';

class StorageCardA extends StatefulWidget {
  final StorageLocations storageDatain;
  final Organisation organisationDetails;

  StorageCardA({
    this.storageDatain,
    this.organisationDetails,
  });

  @override
  _StorageCardAState createState() => _StorageCardAState();
}

class _StorageCardAState extends State<StorageCardA> {
  @override
  Widget build(BuildContext context) {
    final equalSpaceinCard = 10.0;
    String storageLocationName = widget.storageDatain.name;
    String organisationName = Utils.getStringFromPreferences(
        widget.storageDatain.organisationId.toString());
    return Padding(
      padding: EdgeInsets.fromLTRB(
          equalSpaceinCard, 10, equalSpaceinCard, equalSpaceinCard + 10),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(60 + equalSpaceinCard, 0, 0, 0),
            child: Arc(
              height: 12.0 + equalSpaceinCard,
              edge: Edge.LEFT,
              arcType: ArcType.CONVEY,
              clipShadows: [
                ClipShadow(color: Colors.blue.shade100, elevation: 10)
              ],
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Card(
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
                        Text(
                          storageLocationName,
                          style: TextStyle(
                              fontSize: textsizein + 10, color: Colors.black),
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
                                        Text(
                                          organisationName,
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                  child: SvgPicture.asset('assets/dashB1.svg'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
