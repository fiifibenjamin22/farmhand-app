import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LocationsRowItem extends StatelessWidget {
  final String locationName;
  final String locationType;

  const LocationsRowItem({
    Key key,
    this.locationType,
    this.locationName,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final markerThumbnail = new Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.centerLeft,
      child: Container(
        width: 80,
        height: 80,
        decoration: new BoxDecoration(
          color: Color(0xfff9f9f9),
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black45,
              blurRadius: 10.0,
              offset: new Offset(3.0, 3.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: locationType == "farm"
              ? SvgPicture.asset(
                  "assets/map_dash.svg",
                  fit: BoxFit.contain,
                )
              : SvgPicture.asset(
                  "assets/storage_dash.svg",
                  fit: BoxFit.contain,
                ),
        ),
      ),
    );

    final regularTextStyle = TextStyle(
      color: Colors.grey,
      fontSize: 9.0,
      fontWeight: FontWeight.w400,
    );
    final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 12.0);
    final headerTextStyle = TextStyle(
      color: Colors.green,
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
    );

    final cardContent = new Container(
      margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 10.0),
          FittedBox(
            fit: BoxFit.cover,
            child: new Text(
              locationName,
              style: headerTextStyle,
            ),
          ),
          new Container(height: 10.0),
          new Text(
            locationType.toUpperCase(),
            style: subHeaderTextStyle,
          ),
        ],
      ),
    );

    final card = new Container(
      child: cardContent,
      height: 100.0,
      margin: new EdgeInsets.only(left: 40.0),
      decoration: new BoxDecoration(
        color: Color(0xfff9f9f9),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black45,
            blurRadius: 20.0,
            offset: new Offset(5.0, 10.0),
          ),
        ],
      ),
    );

    return new Container(
      height: 100.0,
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: new Stack(
        children: <Widget>[
          card,
          markerThumbnail,
        ],
      ),
    );
  }
}
