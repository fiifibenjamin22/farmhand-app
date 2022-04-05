import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommonScaffold extends StatefulWidget {
  final PreferredSize appBarin;
  final Widget bodyin;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final Widget floatingActionButtonin;
  final Widget bottomNavigationBarin;
  final Widget bottomNavigationSheetin;
  CommonScaffold(
      {this.appBarin,
      this.bodyin,
      this.floatingActionButtonin,
      this.bottomNavigationBarin,
      this.bottomNavigationSheetin,
      this.floatingActionButtonLocation});
  @override
  _CommonScaffoldState createState() => _CommonScaffoldState();
}

class _CommonScaffoldState extends State<CommonScaffold> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xfff9f9f9),
          image: DecorationImage(
            image: AssetImage(
              "assets/commonBackground.png",
            ),
            scale: 3,
            centerSlice: Rect.zero,
          )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        resizeToAvoidBottomInset: false,
        appBar: widget.appBarin,
        body: SafeArea(child: widget.bodyin),
        floatingActionButton: widget.floatingActionButtonin,
        bottomNavigationBar: widget.bottomNavigationBarin,
        bottomSheet: widget.bottomNavigationSheetin,
      ),
    );
  }
}

class CommonScaffoldLogin extends StatefulWidget {
  final PreferredSize appBarin;
  final Widget bodyin;
  final Widget floatingActionButtonin;
  final Widget bottomNavigationBarin;
  CommonScaffoldLogin(
      {this.appBarin,
      this.bodyin,
      this.floatingActionButtonin,
      this.bottomNavigationBarin});
  @override
  _CommonScaffoldLoginState createState() => _CommonScaffoldLoginState();
}

class _CommonScaffoldLoginState extends State<CommonScaffoldLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: widget.appBarin,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Image.asset(
                "assets/sky.png",
                fit: BoxFit.cover,
              )),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset('assets/login_ground.svg',
                  fit: BoxFit.cover)),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: widget.bodyin,
          )
        ],
      )),
      floatingActionButton: widget.floatingActionButtonin,
      bottomNavigationBar: widget.bottomNavigationBarin,
    );
  }
}
