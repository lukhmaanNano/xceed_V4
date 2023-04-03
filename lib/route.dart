import 'package:flutter/material.dart';
import './Splash.dart';
import './model/Login/login.dart';
import './model/helpdesk/status.dart';

// route names
const String splash = 'splash';
const String login = 'login';
const String helpdeskStatus = 'helpdeskStatus';

// controller function to control page route flow
Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case splash: //initial screen
      return MaterialPageRoute(builder: (context) => const Splash());
    case login: //0 screen
      return MaterialPageRoute(builder: (context) => const Login());
    case helpdeskStatus: //1 screen
      return MaterialPageRoute(builder: (context) => HelpdeskStatus());

    default:
      throw ('this route name does not exist');
  }
}
