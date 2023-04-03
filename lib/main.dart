import 'package:flutter/material.dart';
import 'package:xceed/Splash.dart';
import 'Styles/CommonColor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.dark,
      scrollBehavior: const ScrollBehavior(
          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
      theme: ThemeData(
        dividerColor: buttonForeground,
        primaryColor: Color(0xFF21446F),
        splashColor: Colors.transparent,
        scaffoldBackgroundColor: Styles.scaffoldBackgroundColor,
        scrollbarTheme: Styles.scrollbarTheme,
      ),
      title: 'Xceed',
      home: const Splash(),
    );
  }
}
