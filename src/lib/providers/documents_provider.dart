import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Documents with ChangeNotifier {
  List<QueryDocumentSnapshot>? _documents;

  List<QueryDocumentSnapshot>? get documents => _documents;

  void setDocuments(documents) {
    _documents = List.from(documents);
    notifyListeners();
  }

}