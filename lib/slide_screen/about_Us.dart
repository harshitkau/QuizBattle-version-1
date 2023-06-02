import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 234, 239),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 38, 30, 108),
        title: Text("About Game"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            children: [
              Text(
                "Welcome to \nQuiz Battle - KBC",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "1. This game 'Quiz Battle - KBC' is based on the Kaun Bnega Carorpati Scheme and Kaun Banega Crorepati is one of the most famous Hindi television reality shows. The show is back on television with its 14th installment. Yet again, the show’s host is none other than our Big B, meaning Amitabh Bachchan.\n\n2. Everyone dreams of being a part of this reality show and being a crorepati. In the latest installment of Kaun Banega Crorepati, we already have a name that became the first crorepati. Kavita Chawla, a homemaker from Kolhapur, became the first contest that won one crore rupees due to her intellect and grace",
                      softWrap: true,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
