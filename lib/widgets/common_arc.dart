import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum ArcType { CONVEY, CONVEX }
enum Edge { TOP, RIGHT, BOTTOM, LEFT, TOPCENTER }

class ArcClipper extends CustomClipper<Path> {
  ArcClipper(this.height, this.edge, this.arcType, this.circleRadius);

  ///The height of the arc
  final double height;

  final double circleRadius;

  ///The edge of the widget which clipped as arc
  final Edge edge;

  ///The type of arc which can be [ArcType.CONVEX] or [ArcType.CONVEY]
  final ArcType arcType;

  @override
  Path getClip(Size size) {
    switch (edge) {
      case Edge.TOP:
        return _getTopPath(size);
      case Edge.RIGHT:
        return _getRightPath(size);
      case Edge.BOTTOM:
        return _getBottomPath(size);
      case Edge.LEFT:
        return _getLeftPath(size);
      case Edge.TOPCENTER:
        return _getTopCenterPath(size);
      default:
        return _getRightPath(size);
    }
  }

  Path _getBottomPath(Size size) {
    var path = Path();
    if (arcType == ArcType.CONVEX) {
      path.lineTo(0.0, size.height - height);
      //Adds a quadratic bezier segment that curves from the current point
      //to the given point (x2,y2), using the control point (x1,y1).
      path.quadraticBezierTo(
          size.width / 4, size.height, size.width / 2, size.height);
      path.quadraticBezierTo(
          size.width * 3 / 4, size.height, size.width, size.height - height);

      path.lineTo(size.width, 0.0);
    } else {
      path.moveTo(0.0, size.height);
      path.quadraticBezierTo(size.width / 4, size.height - height,
          size.width / 2, size.height - height);
      path.quadraticBezierTo(
          size.width * 3 / 4, size.height - height, size.width, size.height);
      path.lineTo(size.width, 0.0);
      path.lineTo(0.0, 0.0);
    }
    path.close();

    return path;
  }

  Path _getTopPath(Size size) {
    var path = Path();
    if (arcType == ArcType.CONVEX) {
      path.moveTo(0.0, height);

      path.quadraticBezierTo(size.width / 4, 0.0, size.width / 2, 0.0);
      path.quadraticBezierTo(size.width * 3 / 4, 0.0, size.width, height);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
    } else {
      path.quadraticBezierTo(size.width / 4, height, size.width / 2, height);
      path.quadraticBezierTo(size.width * 3 / 4, height, size.width, 0.0);
      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
    }
    path.close();

    return path;
  }

  Path _getLeftPath(Size size) {
    var path = Path();
    if (arcType == ArcType.CONVEX) {
      path.moveTo(height, 0.0);

      path.quadraticBezierTo(0.0, size.height / 4, 0.0, size.height / 2);
      path.quadraticBezierTo(0.0, size.height * 3 / 4, height, size.height);

      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
    } else {
      path.quadraticBezierTo(height, size.height / 4, height, size.height / 2);
      path.quadraticBezierTo(height, size.height * 3 / 4, 0.0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
    }
    path.close();

    return path;
  }

  Path _getRightPath(Size size) {
    var path = Path();
    if (arcType == ArcType.CONVEX) {
      path.moveTo(size.width - height, 0.0);

      path.quadraticBezierTo(
          size.width, size.height / 4, size.width, size.height / 2);
      path.quadraticBezierTo(
          size.width, size.height * 3 / 4, size.width - height, size.height);

      path.lineTo(0.0, size.height);
      path.lineTo(0.0, 0.0);
    } else {
      path.moveTo(size.width, 0.0);
      path.quadraticBezierTo(size.width - height, size.height / 4,
          size.width - height, size.height / 2);
      path.quadraticBezierTo(
          size.width - height, size.height * 3 / 4, size.width, size.height);
      path.lineTo(0.0, size.height);
      path.lineTo(0.0, 0.0);
    }
    path.close();

    return path;
  }

  Path _getTopCenterPath(Size size) {
    var path = Path();
    final shapbonds = Rect.fromLTWH(
        0,
        0,
        size.width,
        arcType == ArcType.CONVEX
            ? height / (height / circleRadius) - 2.5
            : size.height - height);
    final centerAvatar = Offset(shapbonds.center.dx,
        arcType == ArcType.CONVEX ? shapbonds.bottom : shapbonds.top);
    final avatarBounds =
        Rect.fromCircle(center: centerAvatar, radius: circleRadius);
    if (arcType == ArcType.CONVEX) {
      path.moveTo(0.0, size.height);
      path.lineTo(size.width / height * 0.2, 0.0);
      path.arcTo(avatarBounds, -3.14, 3.14, false);
      path.lineTo(size.width, 0.0);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0.0, size.height);
      path.lineTo(size.width / height * 0.2, 0.0);
      path.arcTo(avatarBounds, 3.14, -3.14, false);
      path.lineTo(size.width, 0.0);
      path.lineTo(size.width, size.height);
    }
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    ArcClipper oldie = oldClipper as ArcClipper;
    return height != oldie.height ||
        arcType != oldie.arcType ||
        edge != oldie.edge;
  }
}

class Arc extends StatelessWidget {
  const Arc(
      {key,
      this.height,
      this.child,
      this.edge = Edge.BOTTOM,
      this.arcType = ArcType.CONVEX,
      this.clipShadows = const [],
      this.circleRadius})
      : super(key: key);

  /// The widget which one of [edge]s is going to be clippddddded as arc
  final Widget child;

  ///The height of the arc
  final double height;

  final double circleRadius;

  ///The edge of the widget which clipped as arc
  final Edge edge;

  ///The type of arc which can be [ArcType.CONVEX] or [ArcType.CONVEY]
  final ArcType arcType;

  ///List of shadows to be cast on the border
  final List<ClipShadow> clipShadows;

  @override
  Widget build(BuildContext context) {
    var clipper = ArcClipper(height, edge, arcType, circleRadius);
    return CustomPaint(
      painter: ClipShadowPainter(clipper, clipShadows),
      child: ClipPath(
        clipper: clipper,
        child: child,
      ),
    );
  }
}

class ClipShadowPainter extends CustomPainter {
  final CustomClipper<Path> clipper;
  final List<ClipShadow> clipShadows;

  ClipShadowPainter(this.clipper, this.clipShadows);

  @override
  void paint(Canvas canvas, Size size) {
    // var paint = Paint();
    // paint.color = Colors.green[800];
    // paint.style = PaintingStyle.stroke;
    // paint.strokeWidth = 2.0;
    clipShadows.forEach((ClipShadow shadow) {
      // print(shadow);
      // canvas.clipRRect(clipper.getClip(size));
      canvas.drawShadow(
          clipper.getClip(size), shadow.color, shadow.elevation, true);
      // canvas.drawPath(clipper.getClip(size), paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ClipShadow {
  final Color color;
  final double elevation;

  ClipShadow({this.color, this.elevation = 5});
}
