import 'package:asl/pages/creator_page.dart';
import 'package:asl/pages/dictionary_page.dart';
import 'package:asl/pages/lessons_page.dart';
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
              // TODO replace with ManagePage()
              PopupMenuButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.photoURL!),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: TextButton(
                      onPressed: _signOut,
                      child: const Text('Sign Out'),
                    ),
                  ),
                  PopupMenuItem(
                    child: TextButton(
                      onPressed: _deleteAccount,
                      child: const Text('Delete Account'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: _widgetPages.elementAt(_selectedIndex)),
    );
  }

  void _signOut() {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    provider.googleLogout();
    Navigator.pop(context);
  }

  void _deleteAccount() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              backgroundColor: Colors.grey.shade900,
              title: const Text('Are You Sure?',
                  style: TextStyle(color: Colors.white)),
              content: const Text(
                  'You\'re trying to delete your account.\nYour account and data will be deleted immediately. This action is not reversible.\nPlease hold YES to confirm.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style:
                      const ButtonStyle(splashFactory: NoSplash.splashFactory),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onLongPress: () {
                    FirebaseAuth.instance.currentUser!.delete();
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.googleLogout();
                    Navigator.pop(context);

                    const snackBar = SnackBar(
                      content: Text('Account Deleted'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    Navigator.pop(context);
                  },
                  onPressed: () {},
                  child:
                      const Text('Yes', style: TextStyle(color: Colors.white)),
                ),
              ],
            ));
  }
}
