import 'package:flutter/material.dart';
import 'package:teluk_on_top__perpustakaan/services/firestore_service.dart';

class BookAddPage extends StatefulWidget {
  const BookAddPage({super.key});

  @override
  State<BookAddPage> createState() => _BookAddPageState();
}

class _BookAddPageState extends State<BookAddPage> {
  final titleC = TextEditingController();
  final authorC = TextEditingController();
  final categoryC = TextEditingController();
  final stockC = TextEditingController();

  final service = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Buku")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleC, decoration: const InputDecoration(labelText: "Judul")),
            TextField(controller: authorC, decoration: const InputDecoration(labelText: "Penulis")),
            TextField(controller: categoryC, decoration: const InputDecoration(labelText: "Kategori")),
            TextField(controller: stockC, decoration: const InputDecoration(labelText: "Stok"), keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                service.books.add({
                  "title": titleC.text,
                  "author": authorC.text,
                  "category": categoryC.text,
                  "stock": int.parse(stockC.text),
                });
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
