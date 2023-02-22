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
                    final lessons = snapshot1.data!.docs;
                    final progress = snapshot2.data!.docs;

                    final progressCompletion = progress.map((element) {
                      final data = element.data() as Map<String, dynamic>;
                      return {
                        'id': element.id,
                        'complete': data['complete'],
                      };
                    }).toList();

                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: ListView.builder(
                        itemCount: lessons.length,
                        itemBuilder: (context, index) {
                          final lesson = lessons[index];
                          final lessonId = lesson.id;
                          final lessonTitle = _convertIdToTitle(lessonId);

                          if (!progress
                              .any((element) => element.id == lessonId)) {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(user.uid)
                                .collection("progress")
                                .doc(lessonId)
                                .set({"complete": false});
                          }

                          // TODO is lesson is in progress, change trailing icon color to yellow
                          return Card(
                            child: ListTile(
                                title: Text(lessonTitle),
                                trailing: progressCompletion.firstWhere(
                                        (element) =>
                                            element['id'] ==
                                            lessonId)['complete']
                                    ? const Icon(Icons.check_circle_outline,
                                        color: Colors.green)
                                    : const Icon(Icons.check_circle_outline,
                                        color: Colors.red),
                                onTap: () => Navigator.pushNamed(
                                      context,
                                      '/lesson',
                                      arguments: {
                                        'lesson': lesson,
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
}
