import 'dart:convert';

import 'package:asl/pages/manage_page.dart';
import 'package:asl/widgets/lesson.dart';
import 'package:asl/widgets/review.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:json_theme/json_theme_schemas.dart';
import 'package:provider/provider.dart';
import 'package:asl/widgets/page_manager.dart';
import 'package:asl/providers/google_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';
import 'package:asl/themes/comfy.dart';

void main() async {
  SchemaValidator.enabled = false;
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setPathUrlStrategy();

  final themeStr = await rootBundle.loadString('assets/themes/comfy.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(MyApp(theme: theme));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
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
