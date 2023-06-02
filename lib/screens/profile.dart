import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kbc_quiz/services/localdb.dart';
import 'package:share_plus/share_plus.dart';

class Profile extends StatefulWidget {
  String name;
  String proUrl;
  String rank;
  String level;
  String money;
  Profile({
    required this.name,
    required this.proUrl,
    required this.rank,
    required this.level,
    required this.money,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> LeaderLists = [];
  getLeaders() async {
    await FirebaseFirestore.instance
        .collection("users")
        .orderBy("money")
        .get()
        .then((value) {
      setState(() {
        value.docs.forEach((element) {
          LeaderLists = value.docs.reversed.toList();
          widget.rank = (LeaderLists.indexWhere((element) =>
                      element.data()["photoUrl"] == widget.proUrl) +
                  1)
              .toString();
        });
      });
    });
    await LocalDB.saveRank(widget.rank);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLeaders();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Profile(
                      name: widget.name,
                      level: widget.level,
                      proUrl: widget.proUrl,
                      money: widget.money,
                      rank: widget.rank,
                    )));
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 235, 234, 239),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 38, 30, 108),
          actions: [
            IconButton(
              onPressed: () {
                Share.share(
                    "Welcome to Quiz Battle - KBC \n${widget.name} won ${widget.money}Rs KBC money and placed #${widget.rank} position.\nCan you beat ${widget.name}? Join the Quiz Battle - KBC and Play and beat others and get higher position\n App is available on playstore. Download link is https://play.google.com/store/apps/details?id=com.appionic.quizbattle\n Thank You");
              },
              icon: Icon(Icons.share),
              splashRadius: 15,
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(Icons.person_add),
            //   splashRadius: 15,
            // ),
          ],
          title: Text(
            "Profile",
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 40),
                height: 350,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 38, 30, 108),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.proUrl),
                          radius: 60,
                        ),
                        // Positioned(
                        //   bottom: 0.0,
                        //   right: 0.0,
                        //   child: Container(
                        //     padding: EdgeInsets.all(4),
                        //     decoration: BoxDecoration(
                        //         shape: BoxShape.circle, color: Colors.white),
                        //     child: Icon(Icons.edit, color: Colors.purpleAccent),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Text(
                          "${widget.name}",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Divider(thickness: 1, endIndent: 20, indent: 20),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${k_m_b_generator(int.parse(widget.money))}",
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                            Text(
                              "Money",
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "#${widget.rank}",
                              style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white.withOpacity(0.9)),
                            ),
                            Text(
                              "Rank",
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "LeaderBoard",
                style: TextStyle(fontSize: 20),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 540,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: LeaderLists.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(thickness: 1, endIndent: 10, indent: 10);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                LeaderLists[index]
                                    .data()["photoUrl"]
                                    .toString(),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              LeaderLists[index]
                                          .data()["name"]
                                          .toString()
                                          .length >=
                                      12
                                  ? "${LeaderLists[index].data()["name"].toString().substring(0, 12)}..."
                                  : LeaderLists[index]
                                      .data()["name"]
                                      .toString(),
                            )
                          ],
                        ),
                        leading: Text(
                          "#${index + 1}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        trailing: Text(
                          "Rs. ${k_m_b_generator(int.parse(LeaderLists[index].data()["money"].toString()))}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // ElevatedButton(
              //     style: ButtonStyle(
              //       backgroundColor: MaterialStatePropertyAll<Color>(
              //         Color.fromARGB(255, 38, 30, 108),
              //       ),
              //     ),
              //     onPressed: () {

              //     },
              //     child: Text("Show my Position"))
            ],
          ),
        ),
      ),
    );
  }
}
