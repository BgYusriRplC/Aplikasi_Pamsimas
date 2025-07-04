import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatDetailPage extends StatefulWidget {
  final Map<String, dynamic> riwayatItem;
  const RiwayatDetailPage({super.key, required this.riwayatItem});

  @override
  State<RiwayatDetailPage> createState() => _RiwayatDetailPageState();
}

class _RiwayatDetailPageState extends State<RiwayatDetailPage> {
  String? _loggedInUserId;

  @override
  void initState() {
    super.initState();
    _loadLoggedInUserId();
  }

  Future<void> _loadLoggedInUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _loggedInUserId = prefs.getInt('id_pelanggan')?.toString() ?? 'N/A';
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color headerColor = Color(0xFF82BABA);
    const Color backgroundColor = Color(0xFFD4E7E7);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildHeader(context, headerColor),
          _buildContentCard(context),
          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Tambahkan fungsi untuk mengunduh bukti
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6FCF97),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Unduh',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color color) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Detail Riwayat',
                  style: TextStyle(
                    color: Color.fromARGB(255, 2, 2, 2),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentCard(BuildContext context) {
    return Positioned(
      top: 150,
      left: 16,
      right: 16,
      bottom: 100.0,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem(
                  label: 'ID Pamsimas',
                  value: _loggedInUserId ?? 'Memuat...',
                  icon: Icons.person_pin_rounded,
                ),
                _buildDetailItem(
                  label: 'Nama',
                  value: widget.riwayatItem['nama_pelanggan'] ?? '-',
                  icon: Icons.person,
                ),
                _buildDetailItem(
                  label: 'Pembayaran',
                  value: '1 Bulan',
                  icon: Icons.receipt_long,
                ),
                _buildDetailItem(
                  label: 'Waktu',
                  value:
                      '${widget.riwayatItem['bulan']} ${widget.riwayatItem['tahun']}',
                  icon: Icons.calendar_today,
                ),
                _buildDetailItem(
                  label: 'Denda',
                  value: 'Rp ${widget.riwayatItem['denda'] ?? 0}',
                  icon: Icons.money_off,
                  isCurrency: true,
                ),
                _buildDetailItem(
                  label: 'Jumlah Pembayaran',
                  value: 'Rp ${widget.riwayatItem['jumlah_dibayar'] ?? 0}',
                  icon: Icons.monetization_on,
                  isCurrency: true,
                ),
                _buildDetailItem(
                  label: 'Status Pembayaran',
                  value: 'Selesai',
                  icon: Icons.check_circle,
                  valueColor: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required String label,
    required String value,
    required IconData icon,
    Color? valueColor,
    bool isCurrency = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        valueColor ?? (isCurrency ? Colors.blue : Colors.black),
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
