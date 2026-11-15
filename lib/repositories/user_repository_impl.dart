import 'dart:convert'; 
import 'dart:io'; 
import 'package:flutter/services.dart' show rootBundle; 
import '../models/user.dart';
import '../services/api_service.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService;

  UserRepositoryImpl({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  @override
  Future<List<User>> getUsers() async {
    
    try {
      
      final String jsonString = await rootBundle.loadString('mahasiswa.json');
      final List<dynamic> data = jsonDecode(jsonString);
      return data.asMap().entries.map((entry) {
        final Map<String, dynamic> item = Map<String, dynamic>.from(entry.value);
        if (!item.containsKey('id')) {
          item['id'] = entry.key + 1; 
        }
        return User.fromJson(item);
      }).toList();
    } catch (e) {
      
      try {
        final String jsonString = await rootBundle.loadString('assets/mahasiswa.json');
        final List<dynamic> data = jsonDecode(jsonString);
        return data.asMap().entries.map((entry) {
          final Map<String, dynamic> item = Map<String, dynamic>.from(entry.value);
          if (!item.containsKey('id')) {
            item['id'] = entry.key + 1; 
          }
          return User.fromJson(item);
        }).toList();
      } catch (_) {
        try {
          final file = File('mahasiswa.json');
          if (await file.exists()) {
            final content = await file.readAsString();
            final List<dynamic> data = jsonDecode(content);
            return data.asMap().entries.map((entry) {
              final Map<String, dynamic> item = Map<String, dynamic>.from(entry.value);
              if (!item.containsKey('id')) {
                item['id'] = entry.key + 1;
              }
              return User.fromJson(item);
            }).toList();
          }
        } catch (_) {}

        return await _apiService.getUsers();
      }
    }
  }

  @override
  Future<User> getUserById(int id) async {
    try {
      final users = await getUsers();
      return users.firstWhere(
        (user) => user.id == id,
        orElse: () => users.isNotEmpty ? users[0] : throw Exception('Pengguna tidak ditemukan'),
      );
    } catch (_) {
      return await _apiService.getUserById(id);
    }
  }

  void dispose() {
    _apiService.dispose();
  }
}