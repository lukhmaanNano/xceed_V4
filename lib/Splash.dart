import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'model/Login/login.dart';
import 'model/dashboard/dashboard.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  int? sessionId;
  @override
  void initState() {
    super.initState();
    splashFunction();
  }

  Future<void> splashFunction() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionId = prefs.getInt('SessionId');
    });
    if (sessionId == null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Login())));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Dashboard())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[100],
        child: Image.asset('assets/images/lognano.png'));
  }
}
