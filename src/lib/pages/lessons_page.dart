import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("lessons").snapshots(),
          builder: (context, snapshot1) {
            if (snapshot1.hasData) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .collection("progress")
                    .snapshots(),
                builder: (context, snapshot2) {
                  if (snapshot2.hasData) {
                    final lessonsCollection = snapshot1.data!.docs;
                    final progressCollection = snapshot2.data!.docs;

                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: ListView.builder(
                        itemCount: lessonsCollection.length,
                        itemBuilder: (context, index) {
                          final lesson = lessonsCollection[index];
                          final lessonTitle = _convertIdToTitle(lesson.id);

                          final lessonProgress =
                              _getLessonProgress(progressCollection, lesson);

                          final iconColour =
                              _lessonColour(lessonProgress, lesson.id);

                          return Card(
                            child: ListTile(
                                title: Text(lessonTitle),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      lessonProgress[index]
                                              ['lessonCardsRemaining']
                                          .toString(),
                                      style: TextStyle(color: iconColour),
                                    ),
                                    Icon(Icons.check_circle, color: iconColour),
                                  ],
                                ),
                                onTap: () => Navigator.pushNamed(
                                      context,
                                      '/lesson',
                                      arguments: {
                                        'lessonId': lesson.id,
                                        'isReview': false,
                                      },
                                    )),
                          );
                        },
                      ),
                    );
                  } else if (snapshot2.hasError) {
                    return const Text('Something went wrong!');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              );
            } else if (snapshot1.hasError) {
              return const Text('Something went wrong!');
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  String _convertIdToTitle(String input) {
    return input.replaceAll('lesson', 'Lesson ');
  }

  List<Map<String, dynamic>> _getLessonProgress(
    List<QueryDocumentSnapshot> progressCollection,
    QueryDocumentSnapshot lesson,
  ) {
    _initializeLessonProgress(progressCollection, lesson);

    return progressCollection.map((lessonProgress) {
      final data = lessonProgress.data() as Map<String, dynamic>;
      return {
        'id': lessonProgress.id,
        'complete': data['complete'],
        'inProgress': data['inProgress'],
        'lessonCardsRemaining': data['lessonCardsRemaining'],
      };
    }).toList();
  }

  void _initializeLessonProgress(
    List<QueryDocumentSnapshot> progressCollection,
    QueryDocumentSnapshot lesson,
  ) {
    bool lessonDoesntExist = !progressCollection
        .any((lessonProgress) => lessonProgress.id == lesson.id);

    if (lessonDoesntExist) {
      FirebaseFirestore.instance
          .collection("lessons")
          .doc(lesson.id)
          .collection('cards')
          .get()
          .then(
        (value) {
          final lessonCardsRemaining = value.size;
          FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .collection("progress")
              .doc(lesson.id)
              .set(
            {
              "complete": false,
              "inProgress": false,
              "lessonCardsRemaining": lessonCardsRemaining
            },
            SetOptions(merge: true),
          );
        },
      );
    }
  }

  Color _lessonColour(
    List<Map<String, dynamic>> currentLessonProgress,
    String lessonId,
  ) {
    return currentLessonProgress
            .where((element) => element['id'] == lessonId)
            .first['complete']
        ? Colors.green
        : currentLessonProgress
                .where((element) => element['id'] == lessonId)
                .first['inProgress']
            ? Colors.orange
            : Colors.black38;
  }
}
