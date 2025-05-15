import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wisata.dart';

class WisataService {
  static const String baseUrl = 'http://192.168.1.13/wisata-api';

  static Future<List<Wisata>> fetchAll() async {
    final response = await http.get(Uri.parse('$baseUrl/get.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map(
            (item) => Wisata.fromJson(
              item as Map<String, dynamic>,
              item['id'].toString(),
            ),
          )
          .toList();
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  static Future<bool> createWisata(Wisata wisata) async {
    final jsonBody = jsonEncode(wisata.toJson());
    print('Request body: $jsonBody'); // log json sebelum dikirim

    final response = await http.post(
      Uri.parse('$baseUrl/post.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response.statusCode == 200;
  }

  static Future<bool> updateWisata(String id, Wisata wisata) async {
    final response = await http.put(
      Uri.parse('$baseUrl/put.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"id": id, ...wisata.toJson()}),
    );

    return response.statusCode == 200;
  }

  static Future<bool> deleteWisata(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"id": id}),
    );

    return response.statusCode == 200;
  }
}
