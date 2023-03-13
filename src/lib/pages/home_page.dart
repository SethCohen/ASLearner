import 'package:asl/pages/creator_page.dart';
import 'package:asl/pages/dictionary_page.dart';
import 'package:asl/pages/lessons_page.dart';
import 'package:asl/pages/manage_page.dart';
import 'package:asl/pages/review_page.dart';
import 'package:asl/providers/google_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            toolbarHeight: 80,
            backgroundColor: const Color(0XFF292929),
            title: const Text('ASLearner'),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
            elevation: 10,
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                child: const Text(
                  'Lessons',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                child: const Text(
                  'Review',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                child: const Text(
                  'Dictionary',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 3;
                  });
                },
                child: const Text(
                  'Creator',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
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
