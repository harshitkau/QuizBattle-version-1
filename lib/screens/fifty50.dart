import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Fifty50 extends StatefulWidget {
  String opt1;
  String opt2;
  String opt3;
  String opt4;
  String correctAns;
  Fifty50(
      {required this.opt1,
      required this.opt2,
      required this.opt3,
      required this.opt4,
      required this.correctAns});

  @override
  State<Fifty50> createState() => _Fifty50State();
}

class _Fifty50State extends State<Fifty50> {
  late String WrongOpt1;
  late String WrongOpt2;
  List WrongOptions = [];
  fetchWrongAns() {
    setState(() {
      if (widget.opt1 != widget.correctAns) {
        WrongOptions.add(widget.opt1);
      }
      if (widget.opt2 != widget.correctAns) {
        WrongOptions.add(widget.opt2);
      }
      if (widget.opt3 != widget.correctAns) {
        WrongOptions.add(widget.opt3);
      }
      if (widget.opt4 != widget.correctAns) {
        WrongOptions.add(widget.opt4);
      }
    });
  }

  final player = AudioPlayer();
  playLifeLine() async {
    await player.play(AssetSource("audio_effects/LIFELINE.mp3"));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchWrongAns();
    playLifeLine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 3, 75),
      body: Center(
        child: Container(
          height: 400,
          width: 360,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 38, 30, 108),
              borderRadius: BorderRadius.circular(20)),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 250),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Fifty 50 Lifeline",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Incorrect Options are",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              " ${WrongOptions[0]}\n and \n${WrongOptions[1]}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                    Color.fromARGB(183, 7, 77, 240),
                  ),
                ),
                onPressed: () {
                  player.stop();
                  Navigator.pop(context);
                },
                child: Text(
                  "Go Back",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ))
          ]),
        ),
      ),
    );
  }
}
