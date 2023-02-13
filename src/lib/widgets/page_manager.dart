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
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get()
                  .then(
                (value) {
                  if (!value.exists) {
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .set({
                      "lastLogin": DateTime.now(),
                      "streak": 0,
                    });
                  } else {
                    if (DateTime.now()
                            .difference(value.data()!["lastLogin"].toDate())
                            .inDays >
                        1) {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        "lastLogin": DateTime.now(),
                        "streak": value.data()!["streak"] + 1,
                      });
                    }
                  }
                },
              );

              return const HomePage();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            } else {
              return const LandingPage();
            }
          }));
}
