import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kbc_quiz/screens/home.dart';
import 'package:kbc_quiz/services/auth.dart';
import 'package:kbc_quiz/services/net_connectivity.dart';
import 'package:overlay_support/overlay_support.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    InternetConnectionChecker().onStatusChange.listen((status) {
      final connected = status == InternetConnectionStatus.connected;
      connected
          ? showSimpleNotification(
              Text(
                "Internet Connected",
                style: TextStyle(color: Colors.white),
              ),
              background: Color.fromARGB(255, 15, 12, 44),
            )
          : showSimpleNotification(Text("No Internet"), background: Colors.red);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 12, 44),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/tune/app_logo.png"),
            SizedBox(height: 25),
            const Text(
              "Welcome To\n QUIZ BATTLE - KBC",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            SignInButton(Buttons.Google, onPressed: () async {
              await signWithGoogle();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            }),
            SizedBox(
              height: 10,
            ),
            Text(
              "By continuing, You are Agree with our TnC",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
