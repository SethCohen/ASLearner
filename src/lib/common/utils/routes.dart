import 'package:flutter/material.dart';
import '../../features/lesson/lesson_details_page.dart';
import '../../features/review/review_details_page.dart';
import '../../features/authentication/page_manager.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  if (settings.name == '/') {
    return MaterialPageRoute(
        builder: (_) => const PageManager(), settings: settings);
  } else if (settings.name!.contains("lesson")) {
    final args = settings.arguments as Map<String, dynamic>;
    return MaterialPageRoute(
        builder: (_) => LessonDetails(
            lessonId: args['lessonId'], lessonData: args['lessonData']),
        settings: settings);
  } else if (settings.name!.contains("review")) {
    final args = settings.arguments as Map<String, dynamic>;
    return MaterialPageRoute(
        builder: (_) => Review(title: args['title'], cards: args['cards']),
        settings: settings);
  } else {
    return MaterialPageRoute(
        builder: (_) => const PageManager(), settings: settings);
  }
}
