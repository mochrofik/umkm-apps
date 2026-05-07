import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:umkm_store/model/UserModel.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_key';

  // Menyimpan Token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Mengambil Token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Menghapus Token (Logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<void> saveUser(UserData user) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonStr = json.encode(user.toJson());
    await prefs.setString(_userKey, jsonStr);
  }

  // Ambil Object UserModel
  Future<UserData?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonStr = prefs.getString(_userKey);
    if (jsonStr != null) {
      return UserData.fromKey(json.decode(jsonStr));
    }
    return null;
  }

  // Hapus data (Logout)
  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
