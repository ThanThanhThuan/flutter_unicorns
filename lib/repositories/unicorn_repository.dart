// lib/repositories/unicorn_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/unicorn.dart';

class UnicornRepository {
  /// Replace <YOUR-UNIQUE-ID> with the id that crudcrud.com gives you.
  static const String _baseUrl =
      'https://crudcrud.com/api/110840d80d69433d95f6c23515188f5d/unicorns';

  final http.Client _client;

  UnicornRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Unicorn>> fetchAll() async {
    final resp = await _client.get(Uri.parse(_baseUrl));
    if (resp.statusCode != 200) throw Exception('Failed to load unicorns');
    final List<dynamic> data = jsonDecode(resp.body);
    return data.map((e) => Unicorn.fromJson(e)).toList();
  }

  Future<Unicorn> createUnicorn(String name, int age, String color) async {
    final resp = await _client.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'age': age, 'colour': color}),
    );
    if (resp.statusCode != 201) throw Exception('Failed to create unicorn');
    final Map<String, dynamic> data = jsonDecode(resp.body);
    return Unicorn.fromJson(data);
  }

  Future<void> updateUnicorn(Unicorn u) async {
    final resp = await _client.put(
      Uri.parse('$_baseUrl/${u.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(u.toJson()),
    );
    if (resp.statusCode != 200) throw Exception('Failed to update unicorn');
  }

  Future<void> deleteUnicorn(String id) async {
    final resp = await _client.delete(Uri.parse('$_baseUrl/$id'));
    if (resp.statusCode != 200) throw Exception('Failed to delete unicorn');
  }
}
