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

  int _selectedIndex = 0;

  static const List<Widget> _widgetPages = <Widget>[
    LessonsPage(),
    DictionaryPage(),
    ReviewPage(),
    CreatorPage(),
    ManagePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('ASLearner'),
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                child: const Text(
                  'Lessons',
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                child: const Text(
                  'Review',
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                child: const Text(
                  'Dictionary',
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 3;
                  });
                },
                child: const Text(
                  'Creator',
                ),
              ),
              IconButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.photoURL!),
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 4;
                  });
                },
              ),
            ],
          ),
          body: _widgetPages.elementAt(_selectedIndex)),
    );
  }
}
