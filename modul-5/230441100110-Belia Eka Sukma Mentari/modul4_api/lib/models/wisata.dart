class Wisata {
  final String id;
  final String nama;
  final String jenis;
  final String lokasi;
  final int hargaTiket;
  final String deskripsi;

  Wisata({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.lokasi,
    required this.hargaTiket,
    required this.deskripsi,
  });

  factory Wisata.fromJson(Map<String, dynamic> json, String id) {
    return Wisata(
      id: id,
      nama: json['nama'] ?? '',
      jenis: json['jenis'] ?? '',
      lokasi: json['lokasi'] ?? '',
      hargaTiket:
          json['harga_tiket'] is int
              ? json['harga_tiket']
              : int.tryParse(json['harga_tiket'].toString()) ?? 0,
      deskripsi: json['deskripsi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'jenis': jenis,
      'lokasi': lokasi,
      'harga_tiket': hargaTiket,
      'deskripsi': deskripsi,
    };
  }
}
