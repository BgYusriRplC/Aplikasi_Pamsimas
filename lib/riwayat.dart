import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'detail_riwayat.dart'; // <-- 1. PASTIKAN IMPORT INI ADA

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  Future<List<dynamic>> fetchRiwayat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id_pelanggan');

    // Pastikan alamat IP ini sudah benar
    final response = await http.get(
      Uri.parse('http://12.10.8.247/pamsimas/api/riwayat/index.php?id=$id'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['data'] != null) {
        return jsonData['data'];
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal memuat data riwayat');
    }
  }

  String formatRupiah(dynamic number) {
    if (number == null) return 'Rp0';
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(double.tryParse(number.toString()) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pembayaran'),
        centerTitle: true,
        backgroundColor: const Color(0xFFCDEEFE),
        elevation: 0, // Menghilangkan bayangan AppBar
        actions: [
          // Ikon Notifikasi (yang sudah kita pindahkan)
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Color.fromARGB(255, 14, 13, 13),
              size: 28,
            ),
            onPressed: () {
              // Aksi ketika notifikasi di-klik
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFCDEEFE),
      body: FutureBuilder<List<dynamic>>(
        future: fetchRiwayat(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${snapshot.error}\n\nPastikan server API Anda berjalan dan alamat IP sudah benar.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada riwayat pembayaran.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 8.0,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                // 2. KARTU SEKARANG BISA DIKLIK
                return InkWell(
                  onTap: () {
                    // Navigasi ke halaman detail saat di-klik
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RiwayatDetailPage(riwayatItem: item),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  child: Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item['bulan']} ${item['tahun']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 7, 8, 8),
                                ),
                              ),
                              Text(
                                item['nama_pelanggan'] ?? 'Nama Pelanggan',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20, thickness: 1),
                          _buildDetailRow(
                            'Jumlah Dibayar',
                            formatRupiah(item['jumlah_dibayar']),
                          ),
                          const SizedBox(height: 8),
                          _buildDetailRow('Denda', formatRupiah(item['denda'])),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Dibayar pada: ${item['tanggal_pembayaran'] ?? 'N/A'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 15, color: Colors.grey[800])),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
