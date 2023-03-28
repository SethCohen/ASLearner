import 'package:flutter/material.dart';

class LessonModel {
  final String title;
  final String description;
  final String id;
  final int cardsCompleted;
  final int cardsTotal;

  LessonModel({
    required this.cardsCompleted,
    required this.cardsTotal,
    required this.title,
    required this.description,
    required this.id,
  });

  factory LessonModel.fromMap(id, cardsCompleted, Map<String, dynamic> data) =>
      LessonModel(
        cardsCompleted: cardsCompleted,
        cardsTotal: data['cardCount'],
        title: data['title'],
        description: data['description'],
        id: id,
      );

  LessonModel copyWith({
    int? cardsCompleted,
    int? cardsTotal,
    String? title,
    String? description,
    String? id,
  }) =>
      LessonModel(
        cardsCompleted: cardsCompleted ?? this.cardsCompleted,
        cardsTotal: cardsTotal ?? this.cardsTotal,
        title: title ?? this.title,
        description: description ?? this.description,
        id: id ?? this.id,
      );

  void navigateToLesson(BuildContext context) => Navigator.pushNamed(
        context,
        '/${title.toLowerCase().replaceAll(' ', '_')}',
        arguments: {
          'lesson': this,
        },
      );
}
