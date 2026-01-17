import 'package:flutter/material.dart';
import 'books/books_list.dart';
import 'students/students_list.dart';
import 'borrows/borrow_list.dart';
import 'landing_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 118, 121, 118),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LandingPage()),
            );
          },
        ),
        title: const Text(
          "Manajemen Perpustakaan",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      /// ================= BODY =================
      body: Column(
        children: [
          /// ===== ISI UTAMA (BISA SCROLL KALAU NANTI PANJANG) =====
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// ===== PINJAMAN =====
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const BorrowListPage()),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.menu_book, color: Colors.white, size: 32),
                            SizedBox(width: 12),
                            Text(
                              "Peminjaman Buku",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ===== SISWA & BUKU =====
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const StudentsListPage(),
                                ),
                              );
                            },
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person, size: 32),
                                  SizedBox(height: 8),
                                  Text(
                                    "Data Siswa",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const BooksListPage(),
                                ),
                              );
                            },
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 64, 70),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.book, size: 32),
                                  SizedBox(height: 8),
                                  Text(
                                    "Data Buku",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// ===== FOOTER (DIAM DI BAWAH) =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: const Color.fromARGB(255, 118, 121, 118),
            child: const Column(
              children: [
                Text(
                  "SD 2 RAWA LAUT",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Aplikasi Manajemen Perpustakaan",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
