import 'package:flutter/material.dart';
import 'package:teluk_on_top__perpustakaan/services/firestore_service.dart';

class StudentAddPage extends StatefulWidget {
  const StudentAddPage({super.key});

  @override
  State<StudentAddPage> createState() => _StudentAddPageState();
}

class _StudentAddPageState extends State<StudentAddPage> {
  final nameC = TextEditingController();
  final classC = TextEditingController();
  final service = FirestoreService();

  @override
  void dispose() {
    nameC.dispose();
    classC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Siswa")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameC, decoration: const InputDecoration(labelText: "Nama Siswa")),
            TextField(controller: classC, decoration: const InputDecoration(labelText: "Kelas")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final name = nameC.text.trim();
                final kelas = classC.text.trim();

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nama tidak boleh kosong")));
                  return;
                }

                await service.students.add({
                  "name": name,
                  "class": kelas,
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
