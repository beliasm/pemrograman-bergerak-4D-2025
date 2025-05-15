import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WisataScreenFirestore extends StatelessWidget {
  const WisataScreenFirestore({super.key});

  @override
  Widget build(BuildContext context) {
    final wisataCollection = FirebaseFirestore.instance.collection('wisata');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Wisata (Firestore)'),
        backgroundColor: Colors.green[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: wisataCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('Belum ada data wisata.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final id = docs[index].id;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    data['nama'] ?? 'Tanpa nama',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jenis: ${data['jenis'] ?? '-'}'),
                      Text('Lokasi: ${data['lokasi'] ?? '-'}'),
                      Text('Harga: Rp${data['harga_tiket'] ?? '0'}'),
                      const SizedBox(height: 4),
                      Text(
                        data['deskripsi'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final controllerNama = TextEditingController(
                            text: data['nama'],
                          );
                          final controllerJenis = TextEditingController(
                            text: data['jenis'],
                          );
                          final controllerLokasi = TextEditingController(
                            text: data['lokasi'],
                          );
                          final controllerHarga = TextEditingController(
                            text: (data['harga_tiket'] ?? 0).toString(),
                          );
                          final controllerDeskripsi = TextEditingController(
                            text: data['deskripsi'],
                          );

                          await showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text('Edit Wisata'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: controllerNama,
                                          decoration: const InputDecoration(
                                            labelText: 'Nama',
                                          ),
                                        ),
                                        TextField(
                                          controller: controllerJenis,
                                          decoration: const InputDecoration(
                                            labelText: 'Jenis',
                                          ),
                                        ),
                                        TextField(
                                          controller: controllerLokasi,
                                          decoration: const InputDecoration(
                                            labelText: 'Lokasi',
                                          ),
                                        ),
                                        TextField(
                                          controller: controllerHarga,
                                          decoration: const InputDecoration(
                                            labelText: 'Harga Tiket',
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                        TextField(
                                          controller: controllerDeskripsi,
                                          decoration: const InputDecoration(
                                            labelText: 'Deskripsi',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Batal'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await wisataCollection.doc(id).update({
                                          'nama': controllerNama.text,
                                          'jenis': controllerJenis.text,
                                          'lokasi': controllerLokasi.text,
                                          'harga_tiket':
                                              int.tryParse(
                                                controllerHarga.text,
                                              ) ??
                                              0,
                                          'deskripsi': controllerDeskripsi.text,
                                        });
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Data berhasil diperbarui',
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Simpan'),
                                    ),
                                  ],
                                ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text('Konfirmasi'),
                                  content: Text(
                                    'Hapus wisata "${data['nama']}"?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            await wisataCollection.doc(id).delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data berhasil dihapus'),
                              ),
                            );
                          }
                        },
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
        backgroundColor: Colors.green[800],
        onPressed: () async {
          final controllerNama = TextEditingController();
          final controllerJenis = TextEditingController();
          final controllerLokasi = TextEditingController();
          final controllerHarga = TextEditingController();
          final controllerDeskripsi = TextEditingController();

          await showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text('Tambah Wisata'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: controllerNama,
                          decoration: const InputDecoration(labelText: 'Nama'),
                        ),
                        TextField(
                          controller: controllerJenis,
                          decoration: const InputDecoration(labelText: 'Jenis'),
                        ),
                        TextField(
                          controller: controllerLokasi,
                          decoration: const InputDecoration(
                            labelText: 'Lokasi',
                          ),
                        ),
                        TextField(
                          controller: controllerHarga,
                          decoration: const InputDecoration(
                            labelText: 'Harga Tiket',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: controllerDeskripsi,
                          decoration: const InputDecoration(
                            labelText: 'Deskripsi',
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await wisataCollection.add({
                          'nama': controllerNama.text,
                          'jenis': controllerJenis.text,
                          'lokasi': controllerLokasi.text,
                          'harga_tiket':
                              int.tryParse(controllerHarga.text) ?? 0,
                          'deskripsi': controllerDeskripsi.text,
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data berhasil ditambahkan'),
                          ),
                        );
                      },
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
