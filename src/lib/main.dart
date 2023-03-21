import 'package:asl/pages/manage_page.dart';
import 'package:asl/providers/data_provider.dart';
import 'package:asl/themes/comfy.dart';
import 'package:asl/widgets/lesson.dart';
import 'package:asl/widgets/review.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asl/widgets/page_manager.dart';
import 'package:asl/providers/google_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setPathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
          ChangeNotifierProvider(create: (_) => DataProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ASL Learner',
          theme: comfyTheme,
          home: const PageManager(),
          routes: <String, WidgetBuilder>{
            '/manageAccount': (BuildContext context) => const ManagePage(),
            '/lesson': (BuildContext context) => const Lesson(),
            '/review': (BuildContext context) => const Review(),
          },
        ));
  }
}
