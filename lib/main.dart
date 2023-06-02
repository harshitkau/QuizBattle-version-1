import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kbc_quiz/screens/home.dart';
import 'package:kbc_quiz/screens/login.dart';
import 'package:kbc_quiz/screens/profile.dart';
import 'package:kbc_quiz/screens/quiz_intro.dart';
import 'package:kbc_quiz/screens/question.dart';
import 'package:kbc_quiz/screens/win.dart';
import 'package:kbc_quiz/screens/wrong_ans.dart';
import 'package:kbc_quiz/services/localdb.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogIn = false;
  getLoggedInState() async {
    await LocalDB.getUserId().then((value) {
      setState(() {
        isLogIn = value.toString() != "null";
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getLoggedInState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KBC Quiz',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: isLogIn ? Home() : LoginPage(),
      ),
    );
  }
}
