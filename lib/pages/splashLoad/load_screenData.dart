import 'dart:async';
import 'package:farmhand/pages/MapDownloader/MapImageDownloader.dart';
import 'package:farmhand/pages/splashLoad/extensions/loadScreenExt.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadScreenData extends StatefulWidget {
  @override
  LoadScreenDataState createState() => LoadScreenDataState();
}

class LoadScreenDataState extends State<LoadScreenData> {
  SharedPreferences preferences;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadAllApi();
    });
  }

  void dispose() {
    super.dispose();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  var loadvalueGet;
  @override
  Widget build(BuildContext context) {
    if (loadvalueGet == 1) {
      Future.delayed(
        Duration(seconds: 3),
        () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => MapImageDownloader(),
            ),
            (router) => false),
      );
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              fit: BoxFit.contain,
              width: 150,
              height: 150,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Text("Loading Data..."),
            SizedBox(
              height: 20,
            ),
            LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 10,
              value: loadvalueGet,
            ),
          ],
        ),
      ),
    );
  }
}
