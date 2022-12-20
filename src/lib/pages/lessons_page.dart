import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  CollectionReference dreams = FirebaseFirestore.instance.collection('lessons');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("lessons").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: ListView(
              children: snapshot.data!.docs.map((document) {
                return Card(
                    child: ListTile(
                  title: Text(document.id),
                  onTap: () async {
                    await Navigator.pushNamed(context, '/lesson',
                        arguments: document);
                  },
                ));
              }).toList(),
            ));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
