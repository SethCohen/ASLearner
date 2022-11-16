import 'package:asl/pages/manage_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asl/pages/home_page.dart';
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
            primarySwatch: Colors.deepPurple,
            scaffoldBackgroundColor: const Color(0xFF000000),
            disabledColor: Colors.white70,
            textTheme: const TextTheme(
              subtitle1: TextStyle(color: Colors.white70),
              caption: TextStyle(color: Colors.white70),
              bodyText2: TextStyle(color: Colors.white70),
              headline4: TextStyle(color: Colors.white70),
            ),
            cardTheme: const CardTheme(
              color: Color(0xFF121219),
              shadowColor: Colors.white38,
              elevation: 3,
            ),
            popupMenuTheme: const PopupMenuThemeData(
                color: Color(0xFF15151C),
                textStyle: TextStyle(color: Colors.white70)),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const HomePage(),
          routes: <String, WidgetBuilder>{
            '/manageAccount': (BuildContext context) => const ManagePage(),
          },
        ));
  }
}

