import 'package:flutter/material.dart';
import '../../features/lesson/lesson_page.dart';
import '../../features/review/review_page.dart';
import '../../features/authentication/page_manager.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  if (settings.name == '/') {
    return MaterialPageRoute(
        builder: (_) => const PageManager(), settings: settings);
  } else if (settings.name!.contains("lesson")) {
    final args = settings.arguments as Map<String, dynamic>;
    return MaterialPageRoute(
        builder: (_) => Lesson(lesson: args['lesson']), settings: settings);
  } else if (settings.name!.contains("review")) {
    final args = settings.arguments as Map<String, dynamic>;
    return MaterialPageRoute(
        builder: (_) => Review(cards: args['cards']), settings: settings);
  } else {
    return MaterialPageRoute(
        builder: (_) => const PageManager(), settings: settings);
  }
}
