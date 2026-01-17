import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teluk_on_top__perpustakaan/services/firestore_service.dart';
import 'student_add.dart';
import 'student_edit.dart';

class StudentsListPage extends StatefulWidget {
  const StudentsListPage({super.key});

  @override
  State<StudentsListPage> createState() => _StudentsListPageState();
}

class _StudentsListPageState extends State<StudentsListPage> {
  final service = FirestoreService();
  String search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 26),
        onPressed: () => Navigator.pop(context),
        ),
        title: const Text("👤 Data Siswa"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (v) => setState(() => search = v.toLowerCase()),
              decoration: const InputDecoration(
                hintText: "Cari nama atau kelas...",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StudentAddPage()),
        ),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: service.students.snapshots(),
        builder: (_, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snap.data!.docs.where((d) {
            final data = d.data() as Map<String, dynamic>;
            return data['name'].toString().toLowerCase().contains(search) ||
                data['class'].toString().toLowerCase().contains(search);
          }).toList();

          if (docs.isEmpty) return const Center(child: Text("Data siswa tidak ditemukan"));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              final id = docs[i].id;

              return Card(
                child: ListTile(
                  title: Text(data['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("🏫 Kelas: ${data['class']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => StudentEditPage(id: id)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => service.students.doc(id).delete(),
                      ),
                    ],
                  ),
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
