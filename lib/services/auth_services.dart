import 'package:anime_app/provider/anime_library.dart';
import 'package:anime_app/screens/divider_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthService {
  Future signInWithGoogle(BuildContext context) async {
    final CollectionReference postsRef =
        FirebaseFirestore.instance.collection('liked_collection');
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  verifyEmail() async {
    String message = '';
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (!user!.emailVerified) {
        await user.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      message = e.code;
    } finally {
      return message;
    }
  }

  resetPassword(String email) async {
    String message = '';
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'User is not found.';
      }
    } finally {
      return message;
    }
  }
}
