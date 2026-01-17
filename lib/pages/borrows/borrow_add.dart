import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teluk_on_top__perpustakaan/services/firestore_service.dart';

class BorrowAddPage extends StatefulWidget {
  const BorrowAddPage({super.key});

  @override
  State<BorrowAddPage> createState() => _BorrowAddPageState();
}

class _BorrowAddPageState extends State<BorrowAddPage> {
  final service = FirestoreService();

  String? selectedStudentId;
  String? selectedStudentName;
  String? selectedBookId;
  String? selectedBookTitle;
  int selectedBookStock = 0;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Peminjaman")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// PILIH SISWA
            StreamBuilder<QuerySnapshot>(
              stream: service.students.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final docs = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Pilih Siswa"),
                  items: docs.map((d) {
                    final data = d.data() as Map<String, dynamic>;
                    return DropdownMenuItem(
                      value: d.id,
                      child: Text(data['name'] ?? "-"),
                    );
                  }).toList(),
                  onChanged: (val) {
                    final doc = docs.firstWhere((e) => e.id == val);
                    setState(() {
                      selectedStudentId = val;
                      selectedStudentName = doc['name'];
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            /// PILIH BUKU
            StreamBuilder<QuerySnapshot>(
              stream: service.books.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final docs = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Pilih Buku"),
                  items: docs.map((d) {
                    final data = d.data() as Map<String, dynamic>;
                    return DropdownMenuItem(
                      value: d.id,
                      child: Text("${data['title']} (stok: ${data['stock']})"),
                    );
                  }).toList(),
                  onChanged: (val) {
                    final doc = docs.firstWhere((e) => e.id == val);
                    setState(() {
                      selectedBookId = val;
                      selectedBookTitle = doc['title'];
                      selectedBookStock = doc['stock'];
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      if (selectedStudentId == null || selectedBookId == null) return;
                      if (selectedBookStock <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Stok buku habis")),
                        );
                        return;
                      }

                      setState(() => loading = true);

                      final now = Timestamp.now();
                      final dueDate = Timestamp.fromDate(
                        DateTime.now().add(const Duration(days: 7)),
                      );

                      await service.borrows.add({
                        "studentId": selectedStudentId,
                        "studentName": selectedStudentName,
                        "bookId": selectedBookId,
                        "bookTitle": selectedBookTitle,
                        "borrowDate": now,
                        "dueDate": dueDate,
                        "returnDate": null,
                        "status": "dipinjam",
                      });

                      /// KURANGI STOK
                      await service.books.doc(selectedBookId).update({
                        "stock": selectedBookStock - 1,
                      });

                      setState(() => loading = false);
                      Navigator.pop(context);
                    },
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
