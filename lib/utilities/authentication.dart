class Authentication {
  // // this method initializes the Firebase App
  // static Future<FirebaseApp> initializeFirebase({
  //   required final BuildContext context,
  // }) async {
  //   final FirebaseApp firebaseApp = await Firebase.initializeApp();

  //   // attempt auto-login
  //   final User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     await Navigator.of(context).pushReplacement(
  //       MaterialPageRoute<dynamic>(
  //         builder: (final BuildContext context) => const LibraryScreen(),
  //       ),
  //     );
  //   }

  //   return firebaseApp;
  // }
}
