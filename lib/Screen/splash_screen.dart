import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habbit/Screen/tap_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routeName = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
          child: TextButton(
        child: Text('Loading...'),
        onPressed: () {
         
        },
      )),
    );
  }
}
