import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class QuizQueCreator {
  static Future<Map> genQuizQue(String QuizId, int queMoney) async {
    late Map queData;
    await FirebaseFirestore.instance
        .collection("quizzes")
        .doc(QuizId)
        .collection("questions")
        .where("money", isEqualTo: queMoney)
        .get()
        .then((value) {
      // var random = Random().nextInt();
      queData = value.docs.elementAt(Random().nextInt(1)).data();
    });
    print(queData);
    return queData;
  }
}
