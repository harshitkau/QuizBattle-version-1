import 'package:flutter/material.dart';
import 'package:kbc_quiz/screens/home.dart';
import 'package:kbc_quiz/screens/login.dart';
import 'package:kbc_quiz/screens/profile.dart';
import 'package:kbc_quiz/services/auth.dart';
import 'package:kbc_quiz/services/localdb.dart';
import 'package:kbc_quiz/slide_screen/about_Us.dart';
import 'package:kbc_quiz/slide_screen/how_to_use.dart';

class SideNavigation extends StatelessWidget {
  String name;
  String money;
  String rank;
  String proUrl;
  String level;
  SideNavigation(
      {required this.name,
      required this.money,
      required this.rank,
      required this.proUrl,
      required this.level});

  @override
  Widget build(BuildContext context) {
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

    return Drawer(
      child: Material(
        // color: Color.fromRGBO(128, 0, 128, 1),
        color: Color.fromARGB(255, 23, 17, 75),
        child: ListView(
          // padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(
                              name: name,
                              level: level,
                              proUrl: proUrl,
                              money: money,
                              rank: rank,
                            )));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(proUrl),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name.length > 15
                                ? "${name.substring(0, 15)}..."
                                : name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Rs.${k_m_b_generator(int.parse(money))}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      "Leaderboard - $rank th Rank",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Divider(
              color: Colors.white,
              thickness: 1,
              endIndent: 10,
              indent: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: Row(children: [
                      Icon(
                        Icons.quiz,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(width: 30),
                      Text(
                        "Daily Quiz",
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ]),
                  ),
                  /////////////////////////////////////////
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile(
                                    name: name,
                                    level: level,
                                    proUrl: proUrl,
                                    money: money,
                                    rank: rank,
                                  )));
                    },
                    child: Row(children: [
                      Icon(
                        Icons.leaderboard,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(width: 30),
                      Text(
                        "Leaderboard",
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ]),
                  ),
/////////////////////////////////////////
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HowToUse()));
                    },
                    child: Row(children: const [
                      Icon(
                        Icons.question_mark,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(width: 30),
                      Text(
                        "How To Play",
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ]),
                  ),
///////////////////////////
                  SizedBox(height: 15),

                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AboutUs()));
                    },
                    child: Row(children: [
                      Icon(
                        Icons.gamepad_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(width: 30),
                      Text(
                        "About Game",
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ]),
                  ),
                  SizedBox(height: 15),

                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Row(children: [
                      Icon(
                        Icons.logout_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(width: 30),
                      Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
