import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AudiencePoll extends StatefulWidget {
  String question;
  String opt1;
  String opt2;
  String opt3;
  String opt4;
  String currentAns;

  AudiencePoll(
      {required this.question,
      required this.opt1,
      required this.opt2,
      required this.opt3,
      required this.opt4,
      required this.currentAns});

  @override
  State<AudiencePoll> createState() => _AudiencePollState();
}

class _AudiencePollState extends State<AudiencePoll> {
  final player = AudioPlayer();
  playLifeLine() async {
    await player.play(AssetSource("audio_effects/LIFELINE.mp3"));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playLifeLine();
    VotingMachin();
  }

  int opt1Votes = 0;
  int opt2Votes = 0;
  int opt3Votes = 0;
  int opt4Votes = 0;
  bool isVoting = true;
  VotingMachin() {
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        if (widget.opt1 == widget.currentAns) {
          opt1Votes = Random().nextInt(100);
        } else {
          opt1Votes = Random().nextInt(40);
        }

        if (widget.opt2 == widget.currentAns) {
          opt2Votes = Random().nextInt(100);
        } else {
          opt2Votes = Random().nextInt(40);
        }
        if (widget.opt3 == widget.currentAns) {
          opt3Votes = Random().nextInt(100);
        } else {
          opt3Votes = Random().nextInt(40);
        }
        if (widget.opt4 == widget.currentAns) {
          opt4Votes = Random().nextInt(100);
        } else {
          opt4Votes = Random().nextInt(40);
        }
        isVoting = false;
      });
      // Future.delayed(Duration(seconds: 5), () {
      //   player.stop();
      //   Navigator.pop(context);
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 3, 75),
      // backgroundColor: Color.fromARGB(255, 38, 30, 108),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          margin: EdgeInsets.symmetric(vertical: 180, horizontal: 20),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 38, 30, 108),
              // color: Color.fromARGB(255, 18, 3, 75),
              borderRadius: BorderRadius.circular(20)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Audience Poll LifeLine",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              "Question - ${widget.question}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              isVoting ? "Audience Is Voting" : "Here are the Result",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                  color: Colors.white),
            ),
            SizedBox(height: 20),
            isVoting
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(),
                  )
                : Container(),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                "A. ${widget.opt1}",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white),
              ),
              Text(
                "$opt1Votes Votes",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ]),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                "B. ${widget.opt2}",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white),
              ),
              Text(
                "$opt2Votes Votes",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ]),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                "C. ${widget.opt3}",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white),
              ),
              Text(
                "$opt3Votes Votes",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ]),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                "D. ${widget.opt4}",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white),
              ),
              Text(
                "$opt4Votes Votes",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ]),
            SizedBox(height: 40),
            isVoting
                ? Container()
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromARGB(183, 7, 77, 240),
                      ),
                    ),
                    onPressed: () {
                      player.stop();
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Go Back",
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
          ]),
        ),
      ),
    );
  }
}
