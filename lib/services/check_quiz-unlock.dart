import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kbc_quiz/services/localdb.dart';

class CheckQuizUnlock {
  static Future<bool> checkQuizUnlock(String quiz_doc_id) async {
    bool unlocked = false;
    String user_id = "";
    await LocalDB.getUserId().then((value) {
      user_id = value!;
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user_id)
        .collection("unlocked_quiz")
        .doc(quiz_doc_id)
        .get()
        .then((value) {
      unlocked = value.data().toString() != "null";
    });
    return unlocked;
  }
}
