import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:teluk_on_top__perpustakaan/services/firestore_service.dart';
import 'borrow_add.dart';
import 'borrow_return.dart';

class BorrowListPage extends StatefulWidget {
  const BorrowListPage({super.key});

  @override
  State<BorrowListPage> createState() => _BorrowListPageState();
}

class _BorrowListPageState extends State<BorrowListPage> {
  final service = FirestoreService();
  String search = "";

  String fmt(Timestamp t) => DateFormat('dd MMM yyyy').format(t.toDate());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 26),
        onPressed: () => Navigator.pop(context),
        ),
        title: const Text("📖 Peminjaman Buku"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (v) => setState(() => search = v.toLowerCase()),
              decoration: const InputDecoration(
                hintText: "Cari siswa atau buku...",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BorrowAddPage()),
        ),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: service.borrows.snapshots(),
        builder: (_, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snap.data!.docs.where((d) {
            final data = d.data() as Map<String, dynamic>;
            return data['studentName'].toLowerCase().contains(search) ||
                data['bookTitle'].toLowerCase().contains(search);
          }).toList();

          if (docs.isEmpty) return const Center(child: Text("Data tidak ditemukan"));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              final id = docs[i].id;

              final borrow = data['borrowDate'] as Timestamp;
              final due = data['dueDate'] as Timestamp;
              final status = data['status'];
              final late = status == "dipinjam" && DateTime.now().isAfter(due.toDate());

              return Card(
                child: ListTile(
                  title: Text("${data['studentName']} — ${data['bookTitle']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📅 Pinjam: ${fmt(borrow)}"),
                      Text("⏰ Jatuh tempo: ${fmt(due)}"),
                      if (late)
                        const Text("💸 Denda: Rp 10.000", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  trailing: status == "dipinjam"
                      ? IconButton(
                          icon: Icon(
                            late ? Icons.close : Icons.schedule,
                            color: late ? Colors.red : Colors.orange,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => BorrowReturnPage(id: id)),
                          ),
                        )
                      : const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          );
        },
      ),
      /// FOOTER
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: const Color.fromARGB(255, 118, 121, 118),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("SD 2 RAWA LAUT",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text("Manajemen Perpustakaan",
                style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
