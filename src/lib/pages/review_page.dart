import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    // TODO get all cards from user's in progress collection and allow the user to review over them either by lesson or by all cards
    return StreamBuilder<QuerySnapshot>(
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

                  return ListView.builder(
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
                      final lessonId = lesson.id;
                      final lessonTitle = _convertIdToTitle(lessonId);

                      if (!progress.any((element) => element.id == lessonId)) {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(user.uid)
                            .collection("progress")
                            .doc(lessonId)
                            .set({"complete": false});
                      }

                      return Card(
                        child: ListTile(
                            title: Text(lessonTitle),
                            trailing: const Icon(Icons.check),
                            onTap: () => Navigator.pushNamed(
                                  context,
                                  '/lesson',
                                  arguments: {
                                    'lesson': lesson,
                                    'isReview': true,
                                  },
                                )),
                      );
                    },
                  );
                } else if (snapshot2.hasError) {
                  return const Center(child: Text('Something went wrong!'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          } else if (snapshot1.hasError) {
            return const Center(child: Text('Something went wrong!'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  String _convertIdToTitle(String input) {
    return input.replaceAll('lesson', 'Lesson ');
  }
}
