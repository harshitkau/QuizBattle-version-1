import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AskTheExpert extends StatefulWidget {
  String question;
  String correctAnswer;
  String ytUrl;
  AskTheExpert({
    required this.question,
    required this.correctAnswer,
    required this.ytUrl,
  });

  @override
  State<AskTheExpert> createState() => _AskTheExpertState();
}

class _AskTheExpertState extends State<AskTheExpert> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final player = AudioPlayer();
  playLifeLine() async {
    await player.play(AssetSource("audio_effects/LIFELINE.mp3"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 3, 75),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 180, horizontal: 20),
          padding: EdgeInsets.all(32),
          // margin: EdgeInsets.symmetric(vertical: 210, horizontal: 30),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 38, 30, 108),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Ask the Expert \nLifeline",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20),
              Text("Question - ${widget.question} ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)),
              SizedBox(
                height: 50,
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   child: YoutubePlayer(
              //     controller: YoutubePlayerController(
              //         initialVideoId: widget.ytUrl,
              //         flags: YoutubePlayerFlags(
              //           hideControls: true,
              //           controlsVisibleAtStart: false,
              //           autoPlay: true,
              //           mute: false,
              //         )),
              //   ),
              // ),

              Column(children: [
                Text("Correct Answer is",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Colors.white)),
                Text("${widget.correctAnswer}",
                    style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
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
              ])
            ],
          ),
        ),
      ),
    );
  }
}
