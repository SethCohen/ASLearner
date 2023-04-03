import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/widgets/custom_tab.dart';
import '../authentication/google_provider.dart';
import '../creator/creator_page.dart';
import '../dictionary/dictionary_page.dart';
import '../lesson/lessons_list_page.dart';
import '../profile/profile_page.dart';
import '../review/reviews_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _updateLastLogin();
  }

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
                      CustomTab(
                        message: 'Lessons',
                        icon: Icons.school,
                      ),
                      CustomTab(
                        message: 'Review',
                        icon: Icons.history,
                      ),
                      CustomTab(
                        message: 'Dictionary',
                        icon: Icons.find_in_page,
                      ),
                      CustomTab(
                        message: 'Creator',
                        icon: Icons.design_services,
                      ),
                      CustomTab(
                        message: 'Profile',
                        icon: Icons.account_circle,
                      ),
                    ],
                  ),
                ],
              ),
              body: const TabBarView(
                children: <Widget>[
                  LessonsPage(),
                  ReviewPage(),
                  DictionaryPage(),
                  CreatorPage(),
                  ProfilePage(),
                ],
              )),
        ),
      ),
    );
  }

  void _updateLastLogin() async {
    final user = context.read<GoogleSignInProvider>().user;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((user) {
      final userData = user.data() as Map<String, dynamic>;
      final lastLogin = userData['lastLogin'] as Timestamp;
      final lastLearnt = userData['lastLearnt'] as Timestamp;
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final loginTimeDifference = startOfDay.difference(lastLogin.toDate());
      final lastLearntTimeDifference =
          startOfDay.difference(lastLearnt.toDate());

      if (loginTimeDifference.inHours >= 24 ||
          lastLearntTimeDifference.inHours >= 24) {
        FirebaseFirestore.instance.collection('users').doc(user.id).set({
          'streak': 0,
          'lastLogin': now,
        }, SetOptions(merge: true));
      } else {
        FirebaseFirestore.instance.collection('users').doc(user.id).set({
          'lastLogin': now,
        }, SetOptions(merge: true));
      }
    }).catchError((error) {
      debugPrint(error);
    });
  }
}
