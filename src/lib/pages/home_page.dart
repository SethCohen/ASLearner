import 'package:asl/pages/creator_page.dart';
import 'package:asl/pages/dictionary_page.dart';
import 'package:asl/pages/lessons_page.dart';
import 'package:asl/pages/manage_page.dart';
import 'package:asl/pages/review_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference lessons =
      FirebaseFirestore.instance.collection('lessons');
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.25),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('ASLearner'),
              automaticallyImplyLeading: false,
              actions: const <Widget>[
                TabBar(
                  dividerColor: Colors.transparent,
                  isScrollable: true,
                  tabs: <Widget>[
                    Tooltip(
                        message: 'Lessons',
                        child: Tab(icon: Icon(Icons.school))),
                    Tooltip(
                        message: 'Review',
                        child: Tab(icon: Icon(Icons.history))),
                    Tooltip(
                        message: 'Dictionary',
                        child: Tab(icon: Icon(Icons.find_in_page))),
                    Tooltip(
                        message: 'Creator',
                        child: Tab(icon: Icon(Icons.design_services))),
                    Tooltip(
                        message: 'Profile',
                        child: Tab(icon: Icon(Icons.account_circle))),
                  ],
                ),
              ],
            ),
            body: const TabBarView(children: <Widget>[
              LessonsPage(),
              ReviewPage(),
              DictionaryPage(),
              CreatorPage(),
              ManagePage(),
            ]),
          ),
        ),
      ),
    );
  }
}
