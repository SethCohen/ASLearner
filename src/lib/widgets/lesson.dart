import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Lesson extends StatefulWidget {
  const Lesson({super.key});

  @override
  State<Lesson> createState() => _LessonState();
}

class _LessonState extends State<Lesson> {
  @override
  Widget build(BuildContext context) {
    final lesson =
        ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;

    return Scaffold(
        appBar: AppBar(
          title: Text(lesson.id),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: lesson.reference.collection('cards').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                    child: ListView(
                  children: snapshot.data!.docs.map((document) {
                    final data = document.data() as Map<String, dynamic>;
                    return Card(
                        child: Column(children: [
                      Text(data['title']),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.network(data['assetUrl']),
                      ),
                    ]));
                  }).toList(),
                ));
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong!'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
