import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kbc_quiz/services/localdb.dart';
import 'firedb.dart ';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<User?> signWithGoogle() async {
  try {
    final GoogleSignInAccount? googlesignInAccount =
        await googleSignIn.signIn();
    if (googlesignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googlesignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      final usercredential = await _auth.signInWithCredential(credential);
      final User? user = usercredential.user;

      assert(!user!.isAnonymous);
      assert(await user!.getIdToken() != null);
      final User? currentUser = await _auth.currentUser;
      assert(currentUser!.uid == user!.uid);
      print(user);
      await FireDB().createNewUser(
        user!.displayName.toString(),
        user.email.toString(),
        user.uid.toString(),
        user.photoURL.toString(),
      );
      await LocalDB.saveUserId(user.uid.toString());
      await LocalDB.saveName(user.displayName.toString());
      await LocalDB.saveUrl(user.photoURL.toString());

      print(user);
    }
  } on FirebaseAuthException catch (e) {
    print("Error occurred while signing");
    print(e.message);
    throw e;
  }
}

Future<String> signOut() async {
  await googleSignIn.signOut();
  await _auth.signOut();
  await LocalDB.saveUserId("null");
  return "SUCCESS";
}
