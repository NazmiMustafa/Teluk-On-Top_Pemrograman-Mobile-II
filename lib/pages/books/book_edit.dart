import 'package:flutter/material.dart';
import 'package:teluk_on_top__perpustakaan/services/firestore_service.dart';

class BookEditPage extends StatefulWidget {
  final String id;
  const BookEditPage({super.key, required this.id});

  @override
  State<BookEditPage> createState() => _BookEditPageState();
}

class _BookEditPageState extends State<BookEditPage> {
  final titleC = TextEditingController();
  final authorC = TextEditingController();
  final categoryC = TextEditingController();
  final stockC = TextEditingController();
  bool loading = true;

  final service = FirestoreService();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    final doc = await service.books.doc(widget.id).get();
    final data = doc.data() as Map<String, dynamic>;

    titleC.text = data['title'];
    authorC.text = data['author'];
    categoryC.text = data['category'];
    stockC.text = data['stock'].toString();

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Buku")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleC, decoration: const InputDecoration(labelText: "Judul")),
            TextField(controller: authorC, decoration: const InputDecoration(labelText: "Penulis")),
            TextField(controller: categoryC, decoration: const InputDecoration(labelText: "Kategori")),
            TextField(controller: stockC, decoration: const InputDecoration(labelText: "Stok")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                service.books.doc(widget.id).update({
                  "title": titleC.text,
                  "author": authorC.text,
                  "category": categoryC.text,
                  "stock": int.parse(stockC.text),
                });
                Navigator.pop(context);
              },
              child: const Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}
