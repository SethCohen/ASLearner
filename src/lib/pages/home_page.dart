import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import 'creator_page.dart';
import 'dictionary_page.dart';
import 'lessons_page.dart';
import 'profile_page.dart';
import 'reviews_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    context.read<DataProvider>().loadLessons();
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
}
