import 'package:flutter/material.dart';
import '../models/wisata.dart';
import '../services/wisata_service.dart';

class WisataFormScreen extends StatefulWidget {
  final Wisata? wisata;

  const WisataFormScreen({Key? key, this.wisata}) : super(key: key);

  @override
  State<WisataFormScreen> createState() => _WisataFormScreenState();
}

class _WisataFormScreenState extends State<WisataFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _jenisController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _hargaTiketController = TextEditingController();
  final _deskripsiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.wisata != null) {
      _namaController.text = widget.wisata!.nama;
      _jenisController.text = widget.wisata!.jenis;
      _lokasiController.text = widget.wisata!.lokasi;
      _hargaTiketController.text = widget.wisata!.hargaTiket.toString();
      _deskripsiController.text = widget.wisata!.deskripsi;
    }
  }

  Future<void> _saveWisata() async {
    if (_formKey.currentState!.validate()) {
      final isNew = widget.wisata == null;

      final wisata = Wisata(
        id:
            isNew
                ? DateTime.now().millisecondsSinceEpoch.toString()
                : widget.wisata!.id,
        nama: _namaController.text,
        jenis: _jenisController.text,
        lokasi: _lokasiController.text,
        hargaTiket: int.tryParse(_hargaTiketController.text) ?? 0,
        deskripsi: _deskripsiController.text,
      );

      try {
        final success =
            isNew
                ? await WisataService.createWisata(wisata)
                : await WisataService.updateWisata(widget.wisata!.id, wisata);

        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Data berhasil ${isNew ? 'ditambahkan' : 'diupdate'}',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Gagal menyimpan data')));
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jenisController.dispose();
    _lokasiController.dispose();
    _hargaTiketController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wisata == null ? 'Tambah Wisata' : 'Edit Wisata'),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Wisata'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _jenisController,
                decoration: const InputDecoration(labelText: 'Jenis'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _lokasiController,
                decoration: const InputDecoration(labelText: 'Lokasi'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _hargaTiketController,
                decoration: const InputDecoration(labelText: 'Harga Tiket'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveWisata,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  widget.wisata == null ? 'Simpan' : 'Update',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
