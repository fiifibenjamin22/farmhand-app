import 'package:farmhand/services/api/jwt_worker.dart';
import 'package:farmhand/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';
import 'providers/workTaskDataProviders.dart';
import 'routes_navigate.dart';
import 'sizeConfig.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Utils.initPreferences();

  final SharedPreferences _preferences = await sharePrefs;
  // String refreshToken = _preferences.getString("jwtToken");
  // if (refreshToken != null && refreshToken.isNotEmpty) {
  //   print("refresh token is not null $refreshToken");
  //   await JWTWorkerInterceptor.refreshToken();
  // }

  var expiresDT;
  if (_preferences.getString("expiresUTC") != null) {
    var expiresUTCstring = _preferences.getString("expiresUTC");
    expiresDT = DateTime.parse(expiresUTCstring);
  }
  var currentDT = DateTime.now().toUtc();
  print("expires UTC $expiresDT current: $currentDT");

  bool refreshTokenDT = _preferences.getString("expiresUTC") != null
      ? expiresDT.isBefore(currentDT)
      : true;
  print('refreshTokenDT :: $refreshTokenDT');
  runApp(MyApp(
    screenChange: refreshTokenDT,
  ));
}

class MyApp extends StatelessWidget {
  final bool screenChange;
  MyApp({this.screenChange});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => WorkTaskDataProvider())
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'FarmHand',
            theme: appTheme,
            routes: routes,
            initialRoute: screenChange ? "/" : "/dashboard",
            onGenerateRoute: routeSettings,
          ),
        );
      });
    });
  }
}

ThemeData appTheme = ThemeData(
  primarySwatch: Colors.green,
  accentColor: Colors.white,
  buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Colors.green),
    bodyText2: TextStyle(color: Colors.green),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
