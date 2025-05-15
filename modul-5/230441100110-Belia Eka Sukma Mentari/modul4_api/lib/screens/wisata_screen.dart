import 'package:flutter/material.dart';
import '../models/wisata.dart';
import '../services/wisata_service.dart';
import 'wisata_form_screen.dart';

class WisataListScreen extends StatefulWidget {
  const WisataListScreen({Key? key}) : super(key: key);

  @override
  _WisataListScreenState createState() => _WisataListScreenState();
}

class _WisataListScreenState extends State<WisataListScreen> {
  late Future<List<Wisata>> _futureWisata;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _futureWisata = WisataService.fetchAll();
    });
  }

  Future<void> _confirmDelete(Wisata wisata) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: Text('Hapus ${wisata.nama}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await WisataService.deleteWisata(wisata.id);
        _refreshData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wisata berhasil dihapus')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Wisata'),
        backgroundColor: Colors.green[800],
      ),
      body: FutureBuilder<List<Wisata>>(
        future: _futureWisata,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final wisataList = snapshot.data ?? [];

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: wisataList.length,
            separatorBuilder:
                (context, index) =>
                    const Divider(height: 32, thickness: 2, color: Colors.grey),
            itemBuilder: (context, index) {
              final wisata = wisataList[index];

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            wisata.nama,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                          ),
                          PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder:
                                (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text(
                                      'Hapus',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                            onSelected: (value) async {
                              if (value == 'edit') {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            WisataFormScreen(wisata: wisata),
                                  ),
                                );
                                _refreshData();
                              } else if (value == 'delete') {
                                await _confirmDelete(wisata);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Detail tanpa gambar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jenis: ${wisata.jenis}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Lokasi: ${wisata.lokasi}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Harga: Rp${wisata.hargaTiket}',
                            style: TextStyle(
                              color: Colors.green[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            wisata.deskripsi,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WisataFormScreen()),
          );
          _refreshData();
        },
        backgroundColor: Colors.green[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
