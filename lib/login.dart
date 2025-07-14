import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart'; // Pastikan MainMenu() ada di file main.dart

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller tetap menggunakan nama email & password untuk konsistensi dengan logika API
  final emailController =
      TextEditingController(); // Ini akan digunakan untuk "Nomer Pamsimas"
  final passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> login() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://e-pamsimas.polbeng.web.id/web_pamsimas/api/pelanggan/login.php'),
        body: jsonEncode({
          // Kunci 'email' dikirim ke API, sesuai dengan kode backend Anda
          'email': emailController.text,
          'password': passwordController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success']) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final data = json['data'];

          // Memberikan nilai default jika data dari API null untuk mencegah error
          await prefs.setInt('id_pelanggan', data['id_pelanggan'] ?? 0);
          await prefs.setString('nama', data['nama'] ?? 'Tanpa Nama');
          await prefs.setString('email', data['email'] ?? '');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainMenu()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(json['message'] ?? 'Login gagal')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background disesuaikan dengan gambar
      backgroundColor: const Color(0xFFCDEEFE),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Logo Pamsimas
                // PASTIKAN Anda sudah menambahkan file logo.png di dalam folder assets/images/
                Image.asset(
                  'images/logo.png', // Ganti dengan path logo Anda
                  width: 350,
                  height: 350,
                ),

                // 2. Teks Petunjuk
                const Text(
                  'Masukan Email PAMSIMAS dan Password!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xFF005A9A)),
                ),
                const SizedBox(height: 24),

                // 3. Input Field "Nomer Pamsimas"
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Masukan Email Pamsimas!",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none, // Menghilangkan border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Color(0xFF5AB25E),
                      ), // Border saat aktif
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),

                // 4. Input Field "Password"
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Masukan Password!",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Color(0xFF5AB25E)),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 32),

                // 5. Tombol "Masuk"
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF5AB25E,
                    ), // Warna tombol hijau
                    minimumSize: const Size(200, 50), // Ukuran tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5, // Memberi sedikit bayangan
                  ),
                  onPressed: _isLoading ? null : login,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Masuk",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
