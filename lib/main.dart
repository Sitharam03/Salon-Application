import 'package:flutter/material.dart';
// import 'package:salon/Onboarding/onboarding.dart';
import 'package:salon/login.dart';
// import 'package:salon/maps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScren(),
    );
  }
}
