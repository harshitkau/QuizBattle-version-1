import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:kbc_quiz/screens/home.dart';
import 'package:share_plus/share_plus.dart';

class FinalWin extends StatefulWidget {
  int queMoney;
  String name;
  FinalWin({required this.queMoney, required this.name});

  @override
  State<FinalWin> createState() => _FinalWinState();
}

class _FinalWinState extends State<FinalWin> {
  late ConfettiController confettiController = ConfettiController();
  final player = AudioPlayer();
  playWinSound() async {
    await player.play(AssetSource("tune/kbcwinn.mp3"));
  }

  @override
  void initState() {
    super.initState();
    playWinSound();
    setState(() {
      initController();
    });
    confettiController.play();
  }

  void initController() {
    confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/final.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        floatingActionButton: ElevatedButton(
          onPressed: () {
            player.stop();
            Share.share(
              'Welcome to the Quiz Battle - KBC ${widget.name} win ${widget.queMoney} Rs KBC Money. If you want to win KBC money \n To Download the application from playstore and Enjoy the Game \n Downlaod link https://play.google.com/store/apps/details?id=com.appionic.quizbattle  \nThank You',
            );
          },
          child: Text("Share with Friends"),
        ),
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Congratulations!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "You Won",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  "Rs.${widget.queMoney}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                    padding: EdgeInsets.all(20),
                    child: Image.asset("assets/img/cheque.jpg")),
                ElevatedButton(
                    onPressed: () {
                      player.stop();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: Text("Back to Home"))
              ],
            ),
          ),
          buildconfettiAnimation(confettiController, pi / 2),
        ]),
      ),
    );
  }

  Widget buildconfettiAnimation(controller, double blastDirection) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        maximumSize: Size(30, 30),
        shouldLoop: true,
        confettiController: controller,
        blastDirection: blastDirection,
        blastDirectionality: BlastDirectionality.explosive,
        maxBlastForce: 30,
        minBlastForce: 18,
        emissionFrequency: 0.1,
        numberOfParticles: 20,
        gravity: 0.8,
      ),
    );
  }
}
