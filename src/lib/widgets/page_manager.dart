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
            bool isSignedIn = false;

            if (snapshot.connectionState == ConnectionState.active) {
              isSignedIn = snapshot.hasData;
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return isSignedIn ? const HomePage() : const LandingPage();
          }));
}
