import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowModel {
  String studentId;
  String bookId;
  Timestamp borrowDate;
  Timestamp dueDate;
  Timestamp? returnDate;
  String status;

  BorrowModel({
    required this.studentId,
    required this.bookId,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    this.status = "dipinjam",
  });
}
