import 'dart:io';
import 'package:flutter/material.dart';
import '../models/photo_model.dart';

class GalleryPage extends StatelessWidget {
  final List<PhotoModel> photos;

  const GalleryPage({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Galeri ArtSnap'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body:
          photos.isEmpty
              ? const Center(
                child: Text(
                  'Belum ada gambar tersimpan.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(photo.imagePath),
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            photo.paintingName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pemilik: ${photo.ownerName}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.redAccent,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  photo.location,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${photo.timestamp.toLocal()}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
