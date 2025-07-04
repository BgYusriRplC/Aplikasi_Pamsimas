import 'package:flutter/material.dart';

// --- (PENTING) Ganti path ini sesuai struktur folder Anda ---
import 'login.dart';
import 'profil.dart';
import 'riwayat.dart';
import 'tagihan_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pamsimas App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Definisikan warna yang konsisten dengan halaman profil
        scaffoldBackgroundColor: const Color(0xFFD4E7E7),
        // Atur agar font default aplikasi lebih modern
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,

      // Menggunakan initialRoute dan routes untuk alur navigasi yang benar
      initialRoute: '/login', // Aplikasi akan selalu mulai dari halaman login
      routes: {
        '/login': (context) => const LoginPage(),
        '/main':
            (context) =>
                const MainMenu(), // Rute untuk halaman utama setelah login
      },
    );
  }
}

// ===================================================================
// KELAS UNTUK MENU UTAMA DENGAN NAVIGASI KUSTOM
// ===================================================================

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _selectedIndex = 0;

  // Sesuaikan urutan halaman ini dengan ikon di navigasi kustom
  final List<Widget> _pages = [
    const TagihanPage(), // Halaman untuk ikon kiri (index 0)
    const RiwayatPage(), // Halaman untuk ikon tengah (index 1)
    const ProfilPage(), // Halaman untuk ikon kanan (index 2)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan Stack untuk menumpuk halaman dan navigasi kustom
      // Ini memungkinkan navigasi kustom kita 'melayang' di atas konten
      body: Stack(
        children: [
          // Konten halaman yang aktif (Tagihan/Riwayat/Profil)
          _pages[_selectedIndex],

          // Posisi navigasi kustom di bagian bawah layar
          Positioned(left: 0, right: 0, bottom: 0, child: _buildCustomNavBar()),
        ],
      ),
    );
  }

  // Widget untuk membuat Bottom Navigation Bar Kustom
  Widget _buildCustomNavBar() {
    const Color primaryColor = Color(0xFF82BABA);

    return Container(
      height: 80,
      // Beri sedikit margin untuk efek "floating"
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Item Navigasi Kiri (Tagihan)
          _buildNavItem(
            icon: Icons.receipt_long_outlined,
            index: 0,
            label: "Tagihan",
          ),

          // Item Navigasi Tengah (Riwayat) - Dibuat menonjol
          _buildCenterNavItem(
            icon: Icons.bar_chart,
            index: 1,
            label: "Riwayat",
          ),

          // Item Navigasi Kanan (Profil)
          _buildNavItem(icon: Icons.person_outline, index: 2, label: "Profil"),
        ],
      ),
    );
  }

  // Widget untuk membuat item navigasi biasa (kiri dan kanan)
  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required String label,
  }) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior:
          HitTestBehavior
              .translucent, // Memastikan area kosong di Column juga bisa di-tap
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? Colors.white.withOpacity(0.9)
                      : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 28,
              color: isSelected ? const Color(0xFF1A5F7A) : Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk membuat item navigasi tengah yang lebih besar dan menonjol
  Widget _buildCenterNavItem({
    required IconData icon,
    required int index,
    required String label,
  }) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            // Pindahkan ke atas sedikit untuk efek menonjol
            transform: Matrix4.translationValues(0, -15, 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.white : const Color(0xFF63A3A3),
              border: Border.all(color: const Color(0xFF82BABA), width: 4),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: Icon(
              icon,
              size: 32,
              color: isSelected ? const Color(0xFF1A5F7A) : Colors.white,
            ),
          ),
          // Geser label agar tidak tertimpa oleh widget lain
          Transform(
            transform: Matrix4.translationValues(0, -15, 0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
