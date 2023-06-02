import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kbc_quiz/screens/finalwin.dart';
import 'package:kbc_quiz/screens/win.dart';
import 'package:kbc_quiz/screens/wrong_ans.dart';
import 'package:kbc_quiz/services/firedb.dart';
import 'package:kbc_quiz/services/localdb.dart';
import 'package:kbc_quiz/services/question_model.dart';

import '../services/quiz_ques_creater.dart';
import '../widget/lifeline_sidebar.dart';
import 'dart:async';

class Question extends StatefulWidget {
  String quizID;
  int queMoney;
  String userName;
  Question(
      {required this.quizID, required this.queMoney, required this.userName});
  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  QuestionModel questionModel = QuestionModel();
  bool isQuestionShow = false;
  bool isPlaying = false;
  final introPlayer = AudioPlayer();
  final player = AudioPlayer();
  final playertimer = AudioPlayer();
  final questionIntro = AudioPlayer();
  genQue() async {
    if (widget.queMoney == 5000) {
      await Future.delayed(Duration(seconds: 10));
      if (!mounted) return;
      setState(() {
        isQuestionShow = true;
      });
    }
    if (widget.queMoney != 5000) {
      questionIntro.play(AssetSource("audio_effects/QUESTION.mp3"));
    }
    await QuizQueCreator.genQuizQue(widget.quizID, widget.queMoney)
        .then((queData) {
      setState(() {
        questionModel.question = queData["question"];
        questionModel.correctAnswer = queData["correctAnswer"];

        List options = [
          queData["opt1"],
          queData["opt2"],
          queData["opt3"],
          queData["opt4"],
        ];
        options.shuffle();
        questionModel.option1 = options[0];
        questionModel.option2 = options[1];
        questionModel.option3 = options[2];
        questionModel.option4 = options[3];
      });
    });
  }

  bool optALocked = false;
  bool optBLocked = false;
  bool optCLocked = false;
  bool optDLocked = false;

  // change the timer seconds to according to the money won
  int maxSeconds = 30;
  int seconds = 30;
  Timer? timer;

  QueTimer() async {
    if (widget.queMoney == 5000) {
      setState(() {
        isQuestionShow = true;
      });
      await Future.delayed(Duration(seconds: 10));
      if (!mounted) return;
      setState(() {
        isQuestionShow = false;
      });
    }

    await playertimer.play(AssetSource("audio_effects/30_SEC_TIMER.mp3"));
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() => seconds--);
      if (seconds == 0) {
        timer?.cancel();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Looser(
                    wonMoney:
                        widget.queMoney == 5000 ? 0 : widget.queMoney ~/ 2,
                    correctAns: questionModel.correctAnswer)));
      }
    });
  }

  Timer? questiontimer;
  int showQuesTime = 10;

  ShowQuesTimer() async {
    if (widget.queMoney == 5000) {
      await introPlayer.play(AssetSource("audio_effects/KBC_INTRO.mp3"));
      questiontimer = Timer.periodic(Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => showQuesTime--);
      });
    }
  }

  playLock() async {
    final player = AudioPlayer();
    await player.play(AssetSource("audio_effects/LOCK_SCREEN_trim.mp3"));
  }

  playLooserSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource("audio_effects/WORNG_ANSWER.mp3"));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
    questiontimer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    genQue();
    QueTimer();
    ShowQuesTimer();
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
                        playertimer.stop();
                        await FireDB.updateMoney(
                            widget.queMoney == 5000 ? 0 : widget.queMoney ~/ 2);

                        Navigator.pop(context, true);
                      },
                      child: Text("Yes"),
                    ),
                  ],
                ));
    Future<bool?> showDia() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Long Press to lock the option"),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                      Color.fromARGB(255, 38, 30, 108),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"),
                ),
              ],
            ));

    Future<bool?> showStartWarning({
      required BuildContext context,
      required String title,
    }) =>
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(title),
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
                        questiontimer?.cancel();
                        introPlayer.stop();
                        Navigator.pop(context, true);
                      },
                      child: Text("Yes"),
                    ),
                  ],
                ));
    return isQuestionShow
        ? Scaffold(
            body: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/img/background.png"),
                  fit: BoxFit.cover),
            ),
            child: WillPopScope(
              onWillPop: () async {
                final exitQuiz = await showStartWarning(
                  context: context,
                  title: "Do you want to EXIT QUIZ?",
                );
                return exitQuiz ?? false;
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to the \nHot Seat",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 35),
                  Text(
                    "Quiz Start",
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "In",
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "${showQuesTime} Seconds",
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ))
        : Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/img/background.png"))),
            child: WillPopScope(
              onWillPop: () async {
                final exitQuiz = await showWarning(
                    context: context,
                    title: "Do you want to EXIT QUIZ?",
                    content:
                        "You will Get Rs. ${widget.queMoney == 5000 ? 0 : widget.queMoney / 2}");
                return exitQuiz ?? false;
              },
              child: Scaffold(
                onDrawerChanged: (isOpened) {
                  if (widget.queMoney != 5000) {
                    timer?.cancel();
                    playertimer.pause();
                    if (isOpened) {
                      timer?.cancel();
                      playertimer.pause();
                    } else {
                      QueTimer();
                      playertimer.resume();
                    }
                  }
                },
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Color.fromARGB(255, 38, 30, 108),
                  title: Text("Rs. ${widget.queMoney}",
                      style: TextStyle(fontSize: 25)),
                  centerTitle: true,
                ),
                drawer: Lifeline_Drawer(
                  userName: widget.userName,
                  question: questionModel.question,
                  opt1: questionModel.option1,
                  opt2: questionModel.option2,
                  opt3: questionModel.option3,
                  opt4: questionModel.option4,
                  correctAnswer: questionModel.correctAnswer,
                  quizId: widget.quizID,
                  currentQuesMoney: widget.queMoney,
                ),
                floatingActionButton: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                      Color.fromARGB(255, 38, 30, 108),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Do You Want to Quit Game"),
                              content: Text(
                                  "You will get Rs.${widget.queMoney == 5000 ? 0 : widget.queMoney / 2} in your Account."),
                              actions: [
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll<Color>(
                                        Color.fromARGB(255, 38, 30, 108),
                                      ),
                                    ),
                                    onPressed: () async {
                                      await FireDB.updateMoney(
                                          widget.queMoney == 5000
                                              ? 0
                                              : widget.queMoney ~/ 2);
                                      timer?.cancel();
                                      playertimer.stop();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Text("Quit")),
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll<Color>(
                                        Color.fromARGB(255, 38, 30, 108),
                                      ),
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel")),
                              ],
                            ));
                  },
                  child: Text(
                    "Quit",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              strokeWidth: 10,
                              backgroundColor: Colors.yellow,
                              value: seconds / maxSeconds,
                              color: Colors.purple,
                            ),
                            Center(
                              child: Text(
                                seconds.toString(),
                                style: TextStyle(
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(14),
                        margin:
                            EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          questionModel.question,
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () async {
                          await showDia();
                          print("Double tap for lock");
                        },
                        onLongPress: () {
                          playertimer.stop();
                          playLock();
                          timer?.cancel();
                          setState(() {
                            optALocked = true;
                          });
                          Future.delayed(Duration(seconds: 2), () async {
                            if (questionModel.option1 ==
                                questionModel.correctAnswer) {
                              if (widget.queMoney == 10240000) {
                                await FireDB.updateMoney(widget.queMoney);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FinalWin(
                                              queMoney: widget.queMoney,
                                              name: widget.userName,
                                            )));
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Win(
                                            widget.queMoney,
                                            widget.quizID,
                                            widget.userName)));
                              }
                            } else {
                              await FireDB.updateMoney(widget.queMoney ~/ 2);
                              playLooserSound();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Looser(
                                            wonMoney: widget.queMoney ~/ 2,
                                            correctAns:
                                                questionModel.correctAnswer,
                                          )));
                            }
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(14),
                          margin:
                              EdgeInsets.symmetric(horizontal: 17, vertical: 5),
                          decoration: BoxDecoration(
                            color: optALocked
                                ? Colors.yellow.withOpacity(0.4)
                                : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(34),
                          ),
                          child: Text(
                            "A. ${questionModel.option1}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await showDia();
                          print("Double tap for lock");
                        },
                        onLongPress: () {
                          playertimer.stop();

                          playLock();
                          timer?.cancel();
                          setState(() {
                            optBLocked = true;
                          });
                          Future.delayed(Duration(seconds: 2), () async {
                            if (questionModel.option2 ==
                                questionModel.correctAnswer) {
                              if (widget.queMoney == 10240000) {
                                await FireDB.updateMoney(widget.queMoney);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FinalWin(
                                            name: widget.userName,
                                            queMoney: widget.queMoney)));
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Win(
                                            widget.queMoney,
                                            widget.quizID,
                                            widget.userName)));
                              }
                            } else {
                              await FireDB.updateMoney(widget.queMoney ~/ 2);
                              playLooserSound();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Looser(
                                            wonMoney: widget.queMoney ~/ 2,
                                            correctAns:
                                                questionModel.correctAnswer,
                                          )));
                            }
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(14),
                          margin:
                              EdgeInsets.symmetric(horizontal: 17, vertical: 5),
                          decoration: BoxDecoration(
                            color: optBLocked
                                ? Colors.yellow.withOpacity(0.4)
                                : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(34),
                          ),
                          child: Text(
                            "B. ${questionModel.option2}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await showDia();
                          print("Double tap for lock");
                        },
                        onLongPress: () {
                          playertimer.stop();
                          playLock();
                          timer?.cancel();
                          setState(() {
                            optCLocked = true;
                          });
                          Future.delayed(Duration(seconds: 2), () async {
                            if (questionModel.option3 ==
                                questionModel.correctAnswer) {
                              if (widget.queMoney == 10240000) {
                                await FireDB.updateMoney(widget.queMoney);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FinalWin(
                                            name: widget.userName,
                                            queMoney: widget.queMoney)));
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Win(
                                            widget.queMoney,
                                            widget.quizID,
                                            widget.userName)));
                              }
                            } else {
                              await FireDB.updateMoney(widget.queMoney ~/ 2);
                              playLooserSound();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Looser(
                                            wonMoney: widget.queMoney ~/ 2,
                                            correctAns:
                                                questionModel.correctAnswer,
                                          )));
                            }
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(14),
                          margin:
                              EdgeInsets.symmetric(horizontal: 17, vertical: 5),
                          decoration: BoxDecoration(
                            color: optCLocked
                                ? Colors.yellow.withOpacity(0.4)
                                : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(34),
                          ),
                          child: Text(
                            "C. ${questionModel.option3}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await showDia();
                          print("Double tap for lock");
                        },
                        onLongPress: () {
                          playertimer.stop();
                          playLock();
                          timer?.cancel();
                          setState(() {
                            optDLocked = true;
                          });
                          Future.delayed(Duration(seconds: 2), () async {
                            if (questionModel.option4 ==
                                questionModel.correctAnswer) {
                              if (widget.queMoney == 10240000) {
                                await FireDB.updateMoney(widget.queMoney);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FinalWin(
                                            name: widget.userName,
                                            queMoney: widget.queMoney)));
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Win(
                                            widget.queMoney,
                                            widget.quizID,
                                            widget.userName)));
                              }
                            } else {
                              await FireDB.updateMoney(widget.queMoney ~/ 2);
                              playLooserSound();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Looser(
                                            wonMoney: widget.queMoney ~/ 2,
                                            correctAns:
                                                questionModel.correctAnswer,
                                          )));
                            }
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(14),
                          margin:
                              EdgeInsets.symmetric(horizontal: 17, vertical: 5),
                          decoration: BoxDecoration(
                            color: optDLocked
                                ? Colors.yellow.withOpacity(0.4)
                                : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(34),
                          ),
                          child: Text(
                            "D. ${questionModel.option4}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          );
  }
}
