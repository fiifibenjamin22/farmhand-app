import 'package:farmhand/pages/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'pages/login.dart';

Route routeSettings(RouteSettings settings) {
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          settings: settings,
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route = MaterialPageRoute(
          settings: settings,
          builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
  return null;
}

final routes = {
  "/": (_) => FormLogin(),
  "/dashboard": (_) => FormHandDashboard()
};
