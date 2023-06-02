import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:share_plus/share_plus.dart';

import 'package:kbc_quiz/screens/question.dart';
import 'package:kbc_quiz/services/firedb.dart';

class Win extends StatefulWidget {
  int queMoney;
  String quizID;
  String userName;
  Win(this.queMoney, this.quizID, this.userName);
  @override
  State<Win> createState() => _WinState();
}

class _WinState extends State<Win> {
  late ConfettiController confettiController = ConfettiController();
  Timer? questiontimer;
  int showQuesTime = 7;

  final player = AudioPlayer();
  playWinSound() async {
    await player.play(AssetSource("audio_effects/CORRECT.mp3"));
  }

  ShowQuesTimer() {
    questiontimer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() => showQuesTime--);
      if (showQuesTime == 0) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Question(
                    userName: widget.userName,
                    quizID: widget.quizID,
                    queMoney: (widget.queMoney) * 2)));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      initController();
    });
    playWinSound();
    confettiController.play();
    ShowQuesTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    questiontimer?.cancel();
  }

  void initController() {
    confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    Future<bool?> showWarning(
            {required BuildContext context,
            required String title,
            required String content}) =>
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(title),
                  content: Text(content),
                  actions: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          Color.fromARGB(255, 38, 30, 108),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text("No"),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          Color.fromARGB(255, 38, 30, 108),
                        ),
                      ),
                      onPressed: () async {
                        await FireDB.updateMoney(widget.queMoney);
                        Navigator.pop(context, true);
                      },
                      child: Text("Yes"),
                    ),
                  ],
                ));
    return WillPopScope(
      onWillPop: () async {
        final exitQuiz = await showWarning(
            context: context,
            title: "Do you want to EXIT QUIZ?",
            content: "You Will Get Rs.${widget.queMoney}");
        return exitQuiz ?? false;
      },
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/img/win.png"), fit: BoxFit.cover)),
        child: Scaffold(
          // floatingActionButton: ElevatedButton(
          //   style: ButtonStyle(
          //     backgroundColor: MaterialStatePropertyAll<Color>(
          //       Color.fromARGB(255, 38, 30, 108),
          //     ),
          //   ),
          //   onPressed: () {
          //     player.stop();
          //     questiontimer!.cancel();
          //     Share.share(
          //       'Welcome to the Quiz Battle - KBC ${widget.userName} and ${widget.queMoney} and win KBC Money \n Download the application from playstore and Enjoy the Game \n Downlaod link https://play.google.com/store/apps/details?id=com.chess  \n Thank You  ',
          //     );
          //     ShowQuesTimer();
          //   },
          //   child: Text("Share with Friends"),
          // ),
          backgroundColor: Colors.transparent,
          body: Stack(children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Congratulations!",
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Your Answer is Correct",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "You Won",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Rs.${widget.queMoney}",
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 25),
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Image.asset("assets/img/cheque.jpg")),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => Question(
                  //                   quizID: widget.quizID,
                  //                   queMoney: (widget.queMoney) * 2)));
                  //     },
                  //     child: Text("Next Question"))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Next Question will be shown in",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                      Text(
                        " ${showQuesTime} seconds",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            buildconfettiAnimation(confettiController, pi / 2),
          ]),
        ),
      ),
    );
  }

  Widget buildconfettiAnimation(controller, double blastDirection) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        maximumSize: Size(30, 30),
        shouldLoop: false,
        confettiController: controller,
        blastDirection: blastDirection,
        blastDirectionality: BlastDirectionality.explosive,
        maxBlastForce: 20,
        minBlastForce: 8,
        emissionFrequency: 0.1,
        numberOfParticles: 15,
        gravity: 0.6,
      ),
    );
  }
}
