import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference books =
      FirebaseFirestore.instance.collection("books");

  final CollectionReference students =
      FirebaseFirestore.instance.collection("students");

  final CollectionReference borrows =
      FirebaseFirestore.instance.collection("borrows");
}
