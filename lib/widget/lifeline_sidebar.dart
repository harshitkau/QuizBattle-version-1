import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kbc_quiz/screens/askTheExpert.dart';
import 'package:kbc_quiz/screens/audience_poll.dart';
import 'package:kbc_quiz/screens/fifty50.dart';
import 'package:kbc_quiz/screens/question.dart';
import 'package:kbc_quiz/services/localdb.dart';

class Lifeline_Drawer extends StatefulWidget {
  String question;
  String opt1;
  String opt2;
  String opt3;
  String opt4;
  String quizId;
  String userName;
  String correctAnswer;
  int currentQuesMoney;
  Lifeline_Drawer({
    required this.question,
    required this.opt1,
    required this.opt2,
    required this.opt3,
    required this.opt4,
    required this.quizId,
    required this.currentQuesMoney,
    required this.correctAnswer,
    required this.userName,
  });

  @override
  State<Lifeline_Drawer> createState() => _Lifeline_DrawerState();
}

class _Lifeline_DrawerState extends State<Lifeline_Drawer> {
  Future<bool> checkAudAvail() async {
    bool AudAvail = true;

    await LocalDB.getAud().then((value) {
      AudAvail = value!;
    });
    return AudAvail;
  }

  Future<bool> checkJokAvail() async {
    bool JokAvail = true;

    await LocalDB.getJoker().then((value) {
      JokAvail = value!;
    });
    return JokAvail;
  }

  Future<bool> checkF50Avail() async {
    bool F50Avail = true;

    await LocalDB.get50().then((value) {
      F50Avail = value!;
    });
    return F50Avail;
  }

  Future<bool> checkExpAvail() async {
    bool ExpAvail = true;

    await LocalDB.getExp().then((value) {
      ExpAvail = value!;
    });
    return ExpAvail;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Color.fromARGB(255, 223, 221, 243),
      child: SafeArea(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Lifeline",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () async {
                    if (await checkAudAvail()) {
                      await LocalDB.saveAud(false);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AudiencePoll(
                                  question: widget.question,
                                  opt1: widget.opt1,
                                  opt2: widget.opt2,
                                  opt3: widget.opt3,
                                  opt4: widget.opt4,
                                  currentAns: widget.correctAnswer)));
                    } else {
                      print("Audience Poll Already Used");
                    }
                  },
                  child: Column(
                    children: [
                      Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 17, 3, 141),
                          ),
                          child: Icon(
                            Icons.people,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Audience\n Poll",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (await checkJokAvail()) {
                      await LocalDB.saveJoker(false);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Question(
                                    quizID: widget.quizId,
                                    queMoney: widget.currentQuesMoney,
                                    userName: widget.userName,
                                  )));
                    } else {
                      print("Joker Lifeline is already used");
                    }
                  },
                  child: Column(
                    children: [
                      Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 17, 3, 141),
                          ),
                          child: Icon(
                            Icons.sync,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Joker\n Question",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (await checkF50Avail()) {
                      LocalDB.save50(false);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Fifty50(
                                  opt1: widget.opt1,
                                  opt2: widget.opt2,
                                  opt3: widget.opt2,
                                  opt4: widget.opt4,
                                  correctAns: widget.correctAnswer)));
                    } else {
                      print("Fifty is used already");
                    }
                  },
                  child: Column(
                    children: [
                      Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 17, 3, 141),
                          ),
                          child: Icon(
                            Icons.star_half,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Fifty\n50",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (await checkExpAvail()) {
                      await FirebaseFirestore.instance
                          .collection("quizzes")
                          .doc(widget.quizId)
                          .collection("questions")
                          .where("question", isEqualTo: widget.question)
                          .get()
                          .then((value) async {
                        String ytURL =
                            value.docs.elementAt(0).data()["AnswerYTLinkID"];
                        await LocalDB.saveExp(false);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AskTheExpert(
                                    question: widget.question,
                                    correctAnswer: widget.correctAnswer,
                                    ytUrl: ytURL)));
                      });
                    } else {
                      print("Ask the expert life line is used");
                    }
                  },
                  child: Column(
                    children: [
                      Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 17, 3, 141),
                          ),
                          child: Icon(
                            Icons.desktop_mac_outlined,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Ask The\n Expert",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Divider(
              color: Colors.black26,
              thickness: 1,
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Prizes",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 300,
                child: ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      if (2500 * (pow(2, index + 1)) ==
                          widget.currentQuesMoney) {
                        return ListTile(
                          tileColor: Color.fromARGB(255, 17, 3, 141),
                          leading: Text(
                            "${index + 1}.",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          title: Text(
                            "Rs.${2500 * (pow(2, index + 1))}",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.circle,
                            color: Colors.white,
                          ),
                        );
                      } else {
                        return ListTile(
                          leading: Text(
                            "${index + 1}.",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black26),
                          ),
                          title: Text(
                            "Rs.${2500 * (pow(2, index + 1))}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(Icons.circle),
                        );
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
