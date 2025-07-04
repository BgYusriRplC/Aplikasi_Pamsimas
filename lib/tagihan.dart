class tagihan {
  final int id;
  final int idPelanggan;
  final String bulan;
  final int tahun;
  final double jumlahTagihan;
  final String statusPembayaran;
  final String tanggalJatuhTempo;

  const tagihan({
    required this.id,
    required this.idPelanggan,
    required this.bulan,
    required this.tahun,
    required this.jumlahTagihan,
    required this.statusPembayaran,
    required this.tanggalJatuhTempo,
  });

  factory tagihan.fromJson(Map<String, dynamic> json) {
    return tagihan(
      id: int.parse(json['id_tagihan'].toString()),
      idPelanggan: int.parse(json['id_pelanggan'].toString()),
      bulan: json['bulan'] ?? '',
      tahun: int.parse(json['tahun'].toString()),
      jumlahTagihan: double.parse(json['jumlah_tagihan'].toString()),
      statusPembayaran: json['status_pembayaran'] ?? '',
      tanggalJatuhTempo: json['tanggal_jatuh_tempo'] ?? '',
    );
  }
}
