import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kbc_quiz/screens/question.dart';
import 'package:kbc_quiz/services/check_quiz-unlock.dart';
import 'package:kbc_quiz/services/quiz_dhandha.dart';
import 'package:kbc_quiz/services/quiz_ques_creater.dart';

import '../services/localdb.dart';

class QuizIntro extends StatefulWidget {
  String QuizName;
  String QuizImgUrl;
  String QuizTopics;
  String QuizDurations;
  String QuizAbout;
  String QuizId;
  String QuizPrice;
  String userName;
  QuizIntro({
    required this.QuizName,
    required this.QuizImgUrl,
    required this.QuizTopics,
    required this.QuizDurations,
    required this.QuizAbout,
    required this.QuizId,
    required this.QuizPrice,
    required this.userName,
  });

  @override
  State<QuizIntro> createState() => _QuizIntroState();
}

class _QuizIntroState extends State<QuizIntro> {
  String k_m_b_generator(num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }

  bool isLoading = true;
  setLifeLAvail() async {
    await LocalDB.saveAud(true);
    await LocalDB.saveJoker(true);
    await LocalDB.save50(true);
    await LocalDB.saveExp(true);
    final player = AudioPlayer();
    // await player.play(AssetSource("audio_effects/KBC_INTRO.mp3"));
    // await player.play(AssetSource("assets/tune/kbcwinn.mp3"));
    // await Future.delayed(Duration(seconds: 5));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Question(
                  quizID: widget.QuizId,
                  queMoney: 5000,
                  userName: widget.userName,
                )));
  }

  bool quizIsUnlocked = false;
  getQuizUnlockedStatus() async {
    await CheckQuizUnlock.checkQuizUnlock(widget.QuizId).then((unlockStatus) {
      setState(() {
        isLoading = false;
        quizIsUnlocked = unlockStatus;
      });
    });
  }

  @override
  void initState() {
    getQuizUnlockedStatus();
    super.initState();
  }

  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Color.fromARGB(255, 235, 234, 239),
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: CircularProgressIndicator(),
                ),
              ],
            )),
          )
        : Scaffold(
            backgroundColor: Color.fromARGB(255, 235, 234, 239),
            floatingActionButton: ElevatedButton(
              onPressed: () async {
                quizIsUnlocked
                    ? setLifeLAvail()
                    : QuizDhandha.buyQuiz(
                            QuizPrice: int.parse(widget.QuizPrice),
                            QuizId: widget.QuizId)
                        .then((QuizKharidLiya) {
                        if (QuizKharidLiya) {
                          setState(() {
                            quizIsUnlocked = true;
                          });
                        } else {
                          return showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("Insufficient Money!"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("OK"))
                                    ],
                                  ));
                        }
                      });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                  Color.fromARGB(255, 38, 30, 108),
                ),
              ),
              child: Text(
                quizIsUnlocked ? "Start Quiz" : "Unlock Quiz",
                style: TextStyle(fontSize: 20),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 23, 17, 75),
              title: Text("KBC Quiz App"),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.QuizName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Image.network(
                      widget.QuizImgUrl,
                      fit: BoxFit.cover,
                      height: 230,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Container(
                      padding: EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.topic_outlined),
                              SizedBox(width: 6),
                              Text(
                                "Releted To - ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Text(
                            widget.QuizTopics,
                            style: TextStyle(fontSize: 17),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.timer),
                              SizedBox(width: 6),
                              Text(
                                "Duration - ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Text(
                            "${widget.QuizDurations} Miniutes - ",
                            style: TextStyle(fontSize: 17),
                          )
                        ],
                      ),
                    ),
                    quizIsUnlocked
                        ? Container()
                        : Container(
                            padding: EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.timer),
                                    SizedBox(width: 6),
                                    Text(
                                      "Unlocked Price - ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Text(
                                  // " Rs.${widget.QuizPrice}",
                                  "Rs. ${k_m_b_generator(int.parse(widget.QuizPrice))}",
                                  style: TextStyle(fontSize: 17),
                                )
                              ],
                            ),
                          ),
                    Container(
                      padding: EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.topic_outlined),
                              SizedBox(width: 6),
                              Text(
                                "About Quiz -",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Text(
                            widget.QuizAbout,
                            style: TextStyle(fontSize: 17),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
