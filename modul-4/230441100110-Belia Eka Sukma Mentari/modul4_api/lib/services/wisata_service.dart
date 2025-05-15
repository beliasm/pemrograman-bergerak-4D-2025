import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wisata.dart';

class WisataService {
  static const baseUrl =
      'https://tempatwisata-2bba1-default-rtdb.asia-southeast1.firebasedatabase.app/wisata';

  static Future<List<Wisata>> fetchAll() async {
    final response = await http.get(Uri.parse('$baseUrl.json'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) return [];
      return data.entries.map((entry) {
        final key = entry.key;
        final value = entry.value as Map<String, dynamic>;
        return Wisata.fromJson(value, key);
      }).toList();
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  static Future<bool> addWisata(Wisata wisata) async {
    final response = await http.post(
      Uri.parse('$baseUrl.json'),
      body: json.encode(wisata.toJson()),
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      // Bisa simpan responseData['name'] sebagai id baru jika ingin.
      return true;
    }
    return false;
  }

  static Future<bool> updateWisata(String id, Wisata wisata) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id.json'),
      body: json.encode(wisata.toJson()),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteWisata(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id.json'));
    return response.statusCode == 200;
  }
}
