import 'package:farmhand/pages/login.dart';
import 'package:farmhand/widgets/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import 'splashLoad/load_screenData.dart';

class NoInternetPage extends StatefulWidget {
  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyin: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Image.asset("assets/noInternet.png")),
            Flexible(
              child: Text(
                "No Internet Connection",
                style: TextStyle(fontSize: 25, color: Colors.black),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.green)),
                  onPressed: () async {
                    final SharedPreferences prefs = await sharePrefs;
                    bool jwtExp =
                        JwtDecoder.isExpired(prefs.getString("jwtToken"));
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              jwtExp ? FormLogin() : LoadScreenData(),
                        ),
                        (route) => false);
                  },
                  child: Text(
                    "Try again",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
