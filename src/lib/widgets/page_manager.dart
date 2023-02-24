import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:asl/pages/home_page.dart';
import 'package:asl/pages/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PageManager extends StatelessWidget {
  const PageManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _manageUser();
              return const HomePage();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            } else {
              return const LandingPage();
            }
          },
        ),
      );

  void _manageUser() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (user) {
        if (!user.exists) {
          _createUser();
        } else {
          _updateUser(user);
        }
      },
    );
  }

  void _createUser() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "lastLogin": DateTime.now(),
      "streak": 0,
    });
  }

  void _updateUser(DocumentSnapshot user) {
    // TODO only increment streak if user has reviewed cards on a new day

    // If user has logged in between 12:00am the next day to the following day, streak increments.
    if (DateTime.now().difference(user["lastLogin"].toDate()).inDays == 0) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "lastLogin": DateTime.now(),
        "streak": user["streak"] + 1,
      });
    }

    // If user has logged in more than 2 days since last login, streak resets.
    if (DateTime.now().difference(user["lastLogin"].toDate()).inDays > 1) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "lastLogin": DateTime.now(),
        "streak": 0,
      });
    }
  }
}
