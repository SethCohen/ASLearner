import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_strategy/url_strategy.dart';
import 'features/authentication/google_provider.dart';
import 'firebase_options.dart';
import 'common/utils/routes.dart';
import 'common/themes/comfy_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseFirestore.instance
      .enablePersistence(const PersistenceSettings(synchronizeTabs: true));
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
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ASL Learner',
          theme: comfyTheme,
          initialRoute: '/',
          onGenerateRoute: generateRoute,
        ));
  }
}
