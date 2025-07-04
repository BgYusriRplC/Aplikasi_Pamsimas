import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TagihanPage extends StatelessWidget {
  const TagihanPage({super.key});

  Future<List<Map<String, dynamic>>> fetchTagihan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id_pelanggan');

    if (id == null) throw Exception('ID pelanggan tidak ditemukan');

    final response = await http.get(
      Uri.parse(
        'http://12.10.8.247/pamsimas/api/tagihan/index.php?id_pelanggan=$id',
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List data = jsonData['data'];
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Gagal memuat data tagihan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tagihan'),
        centerTitle: true,
        backgroundColor: const Color(0xFFCDEEFE),
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
      backgroundColor: const Color(
        0xFFCDEEFE,
      ), // Memberi warna latar belakang body
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTagihan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada tagihan tersedia'));
          } else {
            final tagihanList = snapshot.data!;
            return ListView.builder(
              itemCount: tagihanList.length,
              itemBuilder: (context, index) {
                final t = tagihanList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      "${t['bulan']} ${t['tahun']}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text(
                          "Jumlah Tagihan: Rp${double.parse(t['jumlah_tagihan']).toStringAsFixed(0)}",
                        ),
                        Text("Status: ${t['status_pembayaran']}"),
                        Text("Jatuh Tempo: ${t['tanggal_jatuh_tempo']}"),
                        Text("ID Pelanggan: ${t['id_pelanggan']}"),
                      ],
                    ),
                    trailing: Icon(
                      t['status_pembayaran'] == "Lunas"
                          ? Icons.check_circle
                          : Icons.warning,
                      color:
                          t['status_pembayaran'] == "Lunas"
                              ? Colors.green
                              : Colors.orange,
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
}

/*import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'tagihan.dart';

class TagihanList extends StatefulWidget {
  const TagihanList({Key? key}) : super(key: key);

  @override
  TagihanListState createState() => TagihanListState();
}

class TagihanListState extends State<TagihanList> {
  static const String URL = 'http://192.168.56.1/pamsimas/api';
  late Future<List<tagihan>> result_data;

  @override
  void initState() {
    super.initState();
    result_data = _fetchTagihan();
  }

  Future<void> _pullRefresh() async {
    setState(() {
      result_data = _fetchTagihan();
    });
  }

  Future<List<tagihan>> _fetchTagihan() async {
    final uri = Uri.parse('$URL/tagihan/index.php');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      List data = jsonResponse['data'];
      return data.map<tagihan>((e) => tagihan.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data tagihan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tagihan')),
      body: FutureBuilder<List<tagihan>>(
        future: result_data,
        builder: (context, snapshot) {
          return RefreshIndicator(
            onRefresh: _pullRefresh,
            child:
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : snapshot.hasError
                    ? Center(child: Text('Error: ${snapshot.error}'))
                    : _listView(snapshot.data!),
          );
        },
      ),
    );
  }

  Widget _listView(List<tagihan> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final t = data[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              "${t.bulan} ${t.tahun}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text("Jumlah Tagihan: Rp${t.jumlahTagihan.toStringAsFixed(0)}"),
                Text("Status: ${t.statusPembayaran}"),
                Text("Jatuh Tempo: ${t.tanggalJatuhTempo}"),
                Text("ID Pelanggan: ${t.idPelanggan}"),
              ],
            ),
            trailing: Icon(
              t.statusPembayaran == "Lunas"
                  ? Icons.check_circle
                  : Icons.warning,
              color:
                  t.statusPembayaran == "Lunas" ? Colors.green : Colors.orange,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Tagihan ${t.bulan} ${t.tahun} dipilih"),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
*/
