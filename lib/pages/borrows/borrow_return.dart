import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teluk_on_top__perpustakaan/services/firestore_service.dart';

class BorrowReturnPage extends StatefulWidget {
  final String id;
  const BorrowReturnPage({super.key, required this.id});

  @override
  State<BorrowReturnPage> createState() => _BorrowReturnPageState();
}

class _BorrowReturnPageState extends State<BorrowReturnPage> {
  final service = FirestoreService();
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengembalian Buku")),
      body: Center(
        child: ElevatedButton(
          onPressed: processing
              ? null
              : () async {
                  setState(() => processing = true);

                  final borrowRef = service.borrows.doc(widget.id);
                  final doc = await borrowRef.get();
                  final data = doc.data() as Map<String, dynamic>;
                  final bookId = data['bookId'];

                  await borrowRef.update({
                    "returnDate": Timestamp.now(),
                    "status": "dikembalikan",
                  });

                  final bookRef = service.books.doc(bookId);
                  final bookDoc = await bookRef.get();
                  final stock = bookDoc['stock'];

                  await bookRef.update({"stock": stock + 1});

                  setState(() => processing = false);
                  Navigator.pop(context);
                },
          child: const Text("Kembalikan Buku"),
        ),
      ),
    );
  }
}
