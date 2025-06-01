import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../models/photo_model.dart';
import '../pages/gallery_page.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/connectivity_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? _imageFile;
  String? _location;
  final List<PhotoModel> _photoList = [];

  final _titleController = TextEditingController();
  final _ownerController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _ownerController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    final isOnline = await ConnectivityService().checkConnection();
    if (!isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada koneksi internet!')),
      );
      return;
    }

    await [
      Permission.camera,
      Permission.storage,
      Permission.location,
      Permission.notification,
    ].request();

    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    final file = File(image.path);

    await GallerySaver.saveImage(file.path);

    final position = await LocationService().getCurrentLocation();
    final locText = '${position.latitude}, ${position.longitude}';

    final photo = PhotoModel(
      imagePath: file.path,
      location: locText,
      timestamp: DateTime.now(),
      paintingName: _titleController.text,
      ownerName: _ownerController.text,
    );
    _photoList.add(photo);

    setState(() {
      _imageFile = image;
      _location = locText;
    });

    NotificationService().showNotification(
      title: 'Gambar Disimpan!',
      body: 'Lokasi: $_location',
    );
  }

  Future<void> _pickFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final file = File(image.path);

    final photo = PhotoModel(
      imagePath: file.path,
      location: 'Dari Galeri',
      timestamp: DateTime.now(),
      paintingName: _titleController.text,
      ownerName: _ownerController.text,
    );
    _photoList.add(photo);

    setState(() {
      _imageFile = image;
      _location = 'Dari Galeri';
    });

    NotificationService().showNotification(
      title: 'Foto Ditambahkan dari Galeri!',
      body: 'Nama Lukisan: ${_titleController.text}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'ArtSnap',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Ambil Gambar & Simpan Lokasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              _imageFile != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(File(_imageFile!.path), height: 200),
                  )
                  : Column(
                    children: const [
                      Icon(
                        Icons.image_not_supported,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Belum ada gambar',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
              const SizedBox(height: 20),

              _location != null
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, color: Colors.redAccent),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          'Lokasi: $_location',
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                  : const SizedBox(),

              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lukisan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.brush),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _ownerController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pemilik',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 45, 213, 255),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.camera_alt),
                label: const Text(
                  'Ambil Gambar',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: _takePicture,
              ),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 61, 213, 255),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.image),
                label: const Text(
                  'Ambil dari Galeri',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: _pickFromGallery,
              ),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.photo_library),
                label: const Text(
                  'Lihat Galeri',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GalleryPage(photos: _photoList),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
