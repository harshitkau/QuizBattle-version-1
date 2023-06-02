import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kbc_quiz/services/localdb.dart';

class QuizDhandha {
  static Future<bool> buyQuiz(
      {required int QuizPrice, required String QuizId}) async {
    String user_id = "";
    bool paisaHaiKya = false;
    await LocalDB.getUserId().then((uId) {
      user_id = uId!;
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user_id)
        .get()
        .then((user) {
      paisaHaiKya = QuizPrice <= user.data()!["money"];
    });
    if (paisaHaiKya) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user_id)
          .collection("unlocked_quiz")
          .doc(QuizId)
          .set({"unlocked_at": DateTime.now()});
      print("Quiz has been unlocked");

      ////updated balance

      final FirebaseAuth _myauth = FirebaseAuth.instance;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_myauth.currentUser!.uid)
          .get()
          .then((value) async {
        await LocalDB.saveMoney(
            (value.data()!["money"] - QuizPrice).toString());
        await FirebaseFirestore.instance
            .collection("users")
            .doc(_myauth.currentUser!.uid)
            .update({"money": value.data()!["money"] - QuizPrice});
      });

      return true;
    } else {
      print("balance is low");
      return false;
    }
  }
}
