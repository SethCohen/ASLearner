import 'package:asl/pages/manage_page.dart';
import 'package:asl/widgets/lesson.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asl/widgets/page_manager.dart';
import 'package:asl/providers/google_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ASL Learner',
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0XFF292929),
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const PageManager(),
          routes: <String, WidgetBuilder>{
            '/manageAccount': (BuildContext context) => const ManagePage(),
            '/lesson': (BuildContext context) => const Lesson(),
          },
        ));
  }
}
