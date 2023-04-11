import 'package:flutter/material.dart';
import '../../common/utils/user_data_util.dart';
import '../../common/widgets/custom_tab.dart';
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
    UserDataUtil.updateLastLogin();
  }

  // TODO add custom animations between tab views, e.g. fade in/out between lessons and review

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.25),
          child: Scaffold(
            appBar: _buildAppBar(),
            body: _buildTabBarBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarBody() {
    return const TabBarView(
      children: <Widget>[
        LessonsPage(),
        ReviewPage(),
        DictionaryPage(),
        CreatorPage(),
        ProfilePage(),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('ASLearner'),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        _buildTabBar(),
      ],
    );
  }

  Widget _buildTabBar() {
    return const TabBar(
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
    );
  }
}
