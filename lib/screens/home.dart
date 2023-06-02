import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kbc_quiz/screens/quiz_intro.dart';
import 'package:kbc_quiz/services/home_fire.dart';
import 'package:kbc_quiz/widget/sidenavbar.dart';

import '../services/localdb.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "Name";
  String money = "--";
  String lead = "--";
  String proUrl = "--";
  String level = "0";

  List quizzes = [];
  bool isLoading = true;

  getUserDetails() async {
    await LocalDB.getName().then((value) {
      setState(() {
        name = value.toString();
      });
    });

    await LocalDB.getMoney().then((value) {
      setState(() {
        money = value.toString();
      });
    });

    await LocalDB.getRank().then((value) {
      setState(() {
        lead = value.toString();
      });
    });
    await LocalDB.getUrl().then((value) {
      setState(() {
        proUrl = value.toString();
      });
    });
    await LocalDB.getLevel().then((value) {
      setState(() {
        level = value.toString();
      });
    });
  }

  String k_m_b_generator(num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }

  getquiz() async {
    await HomeFire.getquizzes().then((returned_quizzes) {
      setState(() {
        quizzes = returned_quizzes;
        isLoading = false;
      });
    });
  }

  late Map<String, dynamic> topPlayer;
  getTopPlayer() async {
    await FirebaseFirestore.instance
        .collection("users")
        .orderBy("money", descending: true)
        .get()
        .then((value) {
      setState(() {
        topPlayer = value.docs.elementAt(0).data();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    getquiz();
    getTopPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Color.fromARGB(255, 223, 221, 243),
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome to\nQuiz Battle - KBC",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: LinearProgressIndicator(),
                ),
              ],
            )),
          )
        : RefreshIndicator(
            onRefresh: () async {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
            child: Scaffold(
              // backgroundColor: Color.fromARGB(255, 216, 213, 249),
              backgroundColor: Color.fromARGB(255, 235, 234, 239),
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 38, 30, 108),
                title: Text("Quiz Battle - KBC Game"),
              ),
              drawer: SideNavigation(
                money: money,
                name: name,
                rank: lead,
                proUrl: proUrl,
                level: level,
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [
                      CarouselSlider(
                        items: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/app_banner/Slide5.JPG"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/app_banner/HISTORY.png"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/app_banner/areyouready.png"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ],
                        options: CarouselOptions(
                          height: 180,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                      ),
                      //circle quiz
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => QuizIntro(
                                          userName: name,
                                          QuizAbout: (quizzes[0])['about_quiz'],
                                          QuizDurations:
                                              (quizzes[0])['duration'],
                                          QuizImgUrl:
                                              (quizzes[0])['quiz_thumnail'],
                                          QuizName: (quizzes[0])['quiz_Name'],
                                          QuizTopics: (quizzes[0])['topics'],
                                          QuizId: (quizzes[0])['Quizid'],
                                          QuizPrice:
                                              (quizzes[0])['unlock_money'],
                                        )),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  (quizzes[0])["quiz_thumnail"],
                                ),
                                radius: 40,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => QuizIntro(
                                          userName: name,
                                          QuizAbout: (quizzes[4])['about_quiz'],
                                          QuizDurations:
                                              (quizzes[4])['duration'],
                                          QuizImgUrl:
                                              (quizzes[4])['quiz_thumnail'],
                                          QuizName: (quizzes[4])['quiz_Name'],
                                          QuizTopics: (quizzes[4])['topics'],
                                          QuizId: (quizzes[4])['Quizid'],
                                          QuizPrice:
                                              (quizzes[4])['unlock_money'],
                                        )),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  (quizzes[4])["quiz_thumnail"],
                                ),
                                radius: 40,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => QuizIntro(
                                          userName: name,
                                          QuizAbout: (quizzes[6])['about_quiz'],
                                          QuizDurations:
                                              (quizzes[6])['duration'],
                                          QuizImgUrl:
                                              (quizzes[6])['quiz_thumnail'],
                                          QuizName: (quizzes[6])['quiz_Name'],
                                          QuizTopics: (quizzes[6])['topics'],
                                          QuizId: (quizzes[6])['Quizid'],
                                          QuizPrice:
                                              (quizzes[6])['unlock_money'],
                                        )),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  (quizzes[6])["quiz_thumnail"],
                                ),
                                radius: 40,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => QuizIntro(
                                          userName: name,
                                          QuizAbout: (quizzes[3])['about_quiz'],
                                          QuizDurations:
                                              (quizzes[3])['duration'],
                                          QuizImgUrl:
                                              (quizzes[3])['quiz_thumnail'],
                                          QuizName: (quizzes[3])['quiz_Name'],
                                          QuizTopics: (quizzes[3])['topics'],
                                          QuizId: (quizzes[3])['Quizid'],
                                          QuizPrice:
                                              (quizzes[3])['unlock_money'],
                                        )),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  (quizzes[3])["quiz_thumnail"],
                                ),
                                radius: 40,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => QuizIntro(
                                          userName: name,
                                          QuizAbout: (quizzes[1])['about_quiz'],
                                          QuizDurations:
                                              (quizzes[1])['duration'],
                                          QuizImgUrl:
                                              (quizzes[1])['quiz_thumnail'],
                                          QuizName: (quizzes[1])['quiz_Name'],
                                          QuizTopics: (quizzes[1])['topics'],
                                          QuizId: (quizzes[1])['Quizid'],
                                          QuizPrice:
                                              (quizzes[1])['unlock_money'],
                                        )),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Card(
                                    elevation: 8,
                                    child: Container(
                                      height: 150,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Image.network(
                                        (quizzes[1])["quiz_thumnail"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => QuizIntro(
                                          userName: name,
                                          QuizAbout: (quizzes[3])['about_quiz'],
                                          QuizDurations:
                                              (quizzes[3])['duration'],
                                          QuizImgUrl:
                                              (quizzes[3])['quiz_thumnail'],
                                          QuizName: (quizzes[3])['quiz_Name'],
                                          QuizTopics: (quizzes[3])['topics'],
                                          QuizId: (quizzes[3])['Quizid'],
                                          QuizPrice:
                                              (quizzes[3])['unlock_money'],
                                        )),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Card(
                                    elevation: 8,
                                    child: Container(
                                      height: 150,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Image.network(
                                        (quizzes[3])["quiz_thumnail"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),

                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => QuizIntro(
                                          userName: name,
                                          QuizAbout: (quizzes[2])['about_quiz'],
                                          QuizDurations:
                                              (quizzes[2])['duration'],
                                          QuizImgUrl:
                                              (quizzes[2])['quiz_thumnail'],
                                          QuizName: (quizzes[2])['quiz_Name'],
                                          QuizTopics: (quizzes[2])['topics'],
                                          QuizId: (quizzes[2])['Quizid'],
                                          QuizPrice:
                                              (quizzes[2])['unlock_money'],
                                        )),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Card(
                                    elevation: 8,
                                    child: Container(
                                      height: 150,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Image.network(
                                        (quizzes[2])["quiz_thumnail"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => QuizIntro(
                                          userName: name,
                                          QuizAbout: (quizzes[6])['about_quiz'],
                                          QuizDurations:
                                              (quizzes[6])['duration'],
                                          QuizImgUrl:
                                              (quizzes[6])['quiz_thumnail'],
                                          QuizName: (quizzes[6])['quiz_Name'],
                                          QuizTopics: (quizzes[6])['topics'],
                                          QuizId: (quizzes[6])['Quizid'],
                                          QuizPrice:
                                              (quizzes[6])['unlock_money'],
                                        )),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Card(
                                    elevation: 8,
                                    child: Container(
                                      height: 150,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Image.network(
                                        (quizzes[6])["quiz_thumnail"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                      //1st banner
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Stack(
                          children: [
                            Card(
                              elevation: 8,
                              child: Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset(
                                  "assets/app_banner/Slide6.JPG",
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                        color: Colors.black26,
                      ),
                      // highest richest
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Top Player Quiz Battle - KBC",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(alignment: Alignment.center, children: [
                                    Image.asset(
                                      "assets/img/image.png",
                                      height: 132,
                                    ),
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          NetworkImage(topPlayer["photoUrl"]),
                                      // backgroundColor: Colors.red,
                                    ),
                                  ]),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          topPlayer["name"].toString().length >=
                                                  16
                                              ? "${topPlayer["name"].toString().substring(0, 16)}..."
                                              : topPlayer["name"],
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      // Text("Player ID - ABD7445",
                                      //     style: TextStyle(
                                      //         fontSize: 15,
                                      //         fontWeight: FontWeight.w400)),
                                      Text(
                                          "Rs.${k_m_b_generator(topPlayer["money"])}",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              )
                            ]),
                      ),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                        color: Colors.black26,
                      ),
                      // unlock quizzes
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              " Premium Quizzes",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(children: [
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) => QuizIntro(
                                                userName: name,
                                                QuizAbout:
                                                    (quizzes[10])['about_quiz'],
                                                QuizDurations:
                                                    (quizzes[10])['duration'],
                                                QuizImgUrl: (quizzes[10])[
                                                    'quiz_thumnail'],
                                                QuizName:
                                                    (quizzes[10])['quiz_Name'],
                                                QuizTopics:
                                                    (quizzes[10])['topics'],
                                                QuizId: (quizzes[10])['Quizid'],
                                                QuizPrice: (quizzes[10])[
                                                    'unlock_money'],
                                              )),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Card(
                                          elevation: 8,
                                          child: Container(
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Image.network(
                                              (quizzes[10])["quiz_thumnail"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) => QuizIntro(
                                                userName: name,
                                                QuizAbout:
                                                    (quizzes[4])['about_quiz'],
                                                QuizDurations:
                                                    (quizzes[4])['duration'],
                                                QuizImgUrl: (quizzes[4])[
                                                    'quiz_thumnail'],
                                                QuizName:
                                                    (quizzes[4])['quiz_Name'],
                                                QuizTopics:
                                                    (quizzes[4])['topics'],
                                                QuizId: (quizzes[4])['Quizid'],
                                                QuizPrice: (quizzes[4])[
                                                    'unlock_money'],
                                              )),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Card(
                                          elevation: 8,
                                          child: Container(
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Image.network(
                                              (quizzes[4])["quiz_thumnail"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(children: [
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) => QuizIntro(
                                                userName: name,
                                                QuizAbout:
                                                    (quizzes[0])['about_quiz'],
                                                QuizDurations:
                                                    (quizzes[0])['duration'],
                                                QuizImgUrl: (quizzes[0])[
                                                    'quiz_thumnail'],
                                                QuizName:
                                                    (quizzes[0])['quiz_Name'],
                                                QuizTopics:
                                                    (quizzes[0])['topics'],
                                                QuizId: (quizzes[0])['Quizid'],
                                                QuizPrice: (quizzes[0])[
                                                    'unlock_money'],
                                              )),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Card(
                                          elevation: 8,
                                          child: Container(
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Image.network(
                                              (quizzes[0])["quiz_thumnail"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) => QuizIntro(
                                                userName: name,
                                                QuizAbout:
                                                    (quizzes[5])['about_quiz'],
                                                QuizDurations:
                                                    (quizzes[5])['duration'],
                                                QuizImgUrl: (quizzes[5])[
                                                    'quiz_thumnail'],
                                                QuizName:
                                                    (quizzes[5])['quiz_Name'],
                                                QuizTopics:
                                                    (quizzes[5])['topics'],
                                                QuizId: (quizzes[5])['Quizid'],
                                                QuizPrice: (quizzes[5])[
                                                    'unlock_money'],
                                              )),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Card(
                                          elevation: 8,
                                          child: Container(
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Image.network(
                                              (quizzes[5])["quiz_thumnail"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(children: [
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) => QuizIntro(
                                                userName: name,
                                                QuizAbout:
                                                    (quizzes[9])['about_quiz'],
                                                QuizDurations:
                                                    (quizzes[9])['duration'],
                                                QuizImgUrl: (quizzes[9])[
                                                    'quiz_thumnail'],
                                                QuizName:
                                                    (quizzes[9])['quiz_Name'],
                                                QuizTopics:
                                                    (quizzes[9])['topics'],
                                                QuizId: (quizzes[9])['Quizid'],
                                                QuizPrice: (quizzes[9])[
                                                    'unlock_money'],
                                              )),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Card(
                                          elevation: 8,
                                          child: Container(
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Image.network(
                                              (quizzes[9])["quiz_thumnail"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) => QuizIntro(
                                                userName: name,
                                                QuizAbout:
                                                    (quizzes[8])['about_quiz'],
                                                QuizDurations:
                                                    (quizzes[8])['duration'],
                                                QuizImgUrl: (quizzes[8])[
                                                    'quiz_thumnail'],
                                                QuizName:
                                                    (quizzes[8])['quiz_Name'],
                                                QuizTopics:
                                                    (quizzes[8])['topics'],
                                                QuizId: (quizzes[8])['Quizid'],
                                                QuizPrice: (quizzes[8])[
                                                    'unlock_money'],
                                              )),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Card(
                                          elevation: 8,
                                          child: Container(
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Image.network(
                                              (quizzes[8])["quiz_thumnail"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(children: [
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) => QuizIntro(
                                                userName: name,
                                                QuizAbout:
                                                    (quizzes[6])['about_quiz'],
                                                QuizDurations:
                                                    (quizzes[6])['duration'],
                                                QuizImgUrl: (quizzes[6])[
                                                    'quiz_thumnail'],
                                                QuizName:
                                                    (quizzes[6])['quiz_Name'],
                                                QuizTopics:
                                                    (quizzes[6])['topics'],
                                                QuizId: (quizzes[6])['Quizid'],
                                                QuizPrice: (quizzes[6])[
                                                    'unlock_money'],
                                              )),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Card(
                                          elevation: 8,
                                          child: Container(
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Image.network(
                                              (quizzes[6])["quiz_thumnail"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) => QuizIntro(
                                                userName: name,
                                                QuizAbout:
                                                    (quizzes[7])['about_quiz'],
                                                QuizDurations:
                                                    (quizzes[7])['duration'],
                                                QuizImgUrl: (quizzes[7])[
                                                    'quiz_thumnail'],
                                                QuizName:
                                                    (quizzes[7])['quiz_Name'],
                                                QuizTopics:
                                                    (quizzes[7])['topics'],
                                                QuizId: (quizzes[7])['Quizid'],
                                                QuizPrice: (quizzes[7])[
                                                    'unlock_money'],
                                              )),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Card(
                                          elevation: 8,
                                          child: Container(
                                            height: 150,
                                            child: Image.network(
                                              (quizzes[7])["quiz_thumnail"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(children: [
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) => QuizIntro(
                                                userName: name,
                                                QuizAbout:
                                                    (quizzes[1])['about_quiz'],
                                                QuizDurations:
                                                    (quizzes[1])['duration'],
                                                QuizImgUrl: (quizzes[1])[
                                                    'quiz_thumnail'],
                                                QuizName:
                                                    (quizzes[1])['quiz_Name'],
                                                QuizTopics:
                                                    (quizzes[1])['topics'],
                                                QuizId: (quizzes[1])['Quizid'],
                                                QuizPrice: (quizzes[1])[
                                                    'unlock_money'],
                                              )),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Card(
                                          elevation: 8,
                                          child: Container(
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Image.network(
                                              (quizzes[1])["quiz_thumnail"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) => QuizIntro(
                                                userName: name,
                                                QuizAbout:
                                                    (quizzes[3])['about_quiz'],
                                                QuizDurations:
                                                    (quizzes[3])['duration'],
                                                QuizImgUrl: (quizzes[3])[
                                                    'quiz_thumnail'],
                                                QuizName:
                                                    (quizzes[3])['quiz_Name'],
                                                QuizTopics:
                                                    (quizzes[3])['topics'],
                                                QuizId: (quizzes[3])['Quizid'],
                                                QuizPrice: (quizzes[3])[
                                                    'unlock_money'],
                                              )),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Card(
                                          elevation: 8,
                                          child: Container(
                                            height: 150,
                                            child: Image.network(
                                              (quizzes[3])["quiz_thumnail"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Stack(
                          children: [
                            Card(
                              elevation: 8,
                              child: Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset(
                                  "assets/app_banner/Slide6.JPG",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      CarouselSlider(
                        items: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/app_banner/Slide3.JPG"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/app_banner/Slide5.JPG"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/app_banner/areyouready.png"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ],
                        options: CarouselOptions(
                          height: 180,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => QuizIntro(
                                          userName: name,
                                          QuizAbout: (quizzes[0])['about_quiz'],
                                          QuizDurations:
                                              (quizzes[0])['duration'],
                                          QuizImgUrl:
                                              (quizzes[0])['quiz_thumnail'],
                                          QuizName: (quizzes[0])['quiz_Name'],
                                          QuizTopics: (quizzes[0])['topics'],
                                          QuizId: (quizzes[0])['Quizid'],
                                          QuizPrice:
                                              (quizzes[0])['unlock_money'],
                                        )),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  (quizzes[0])["quiz_thumnail"],
                                ),
                                radius: 50,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => QuizIntro(
                                          userName: name,
                                          QuizAbout: (quizzes[4])['about_quiz'],
                                          QuizDurations:
                                              (quizzes[4])['duration'],
                                          QuizImgUrl:
                                              (quizzes[4])['quiz_thumnail'],
                                          QuizName: (quizzes[4])['quiz_Name'],
                                          QuizTopics: (quizzes[4])['topics'],
                                          QuizId: (quizzes[4])['Quizid'],
                                          QuizPrice:
                                              (quizzes[4])['unlock_money'],
                                        )),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  (quizzes[4])["quiz_thumnail"],
                                ),
                                radius: 50,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => QuizIntro(
                                          userName: name,
                                          QuizAbout: (quizzes[6])['about_quiz'],
                                          QuizDurations:
                                              (quizzes[6])['duration'],
                                          QuizImgUrl:
                                              (quizzes[6])['quiz_thumnail'],
                                          QuizName: (quizzes[6])['quiz_Name'],
                                          QuizTopics: (quizzes[6])['topics'],
                                          QuizId: (quizzes[6])['Quizid'],
                                          QuizPrice:
                                              (quizzes[6])['unlock_money'],
                                        )),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  (quizzes[6])["quiz_thumnail"],
                                ),
                                radius: 50,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),
                      Text(
                        "Version 1.0 Made By Harshit",
                        style: TextStyle(
                            color: Colors.grey.withOpacity(0.5),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
