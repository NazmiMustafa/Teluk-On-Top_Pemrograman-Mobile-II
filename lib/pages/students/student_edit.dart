import 'package:flutter/material.dart';
import 'package:teluk_on_top__perpustakaan/services/firestore_service.dart';

class StudentEditPage extends StatefulWidget {
  final String id;
  const StudentEditPage({super.key, required this.id});

  @override
  State<StudentEditPage> createState() => _StudentEditPageState();
}

class _StudentEditPageState extends State<StudentEditPage> {
  final nameC = TextEditingController();
  final classC = TextEditingController();
  final service = FirestoreService();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    nameC.dispose();
    classC.dispose();
    super.dispose();
  }

  loadData() async {
    if (widget.id.isEmpty) {
      setState(() => loading = false);
      return;
    }

    final doc = await service.students.doc(widget.id).get();
    if (!doc.exists) {
      setState(() => loading = false);
      return;
    }

    final data = doc.data() as Map<String, dynamic>;
    nameC.text = data['name'] ?? "";
    classC.text = data['class'] ?? "";

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Edit Siswa")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Siswa")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameC, decoration: const InputDecoration(labelText: "Nama Siswa")),
            TextField(controller: classC, decoration: const InputDecoration(labelText: "Kelas")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await service.students.doc(widget.id).update({
                  "name": nameC.text.trim(),
                  "class": classC.text.trim(),
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
