import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const _baseUrl = 'http://10.163.74.102:5000/api';
  final _storage = const FlutterSecureStorage();

  Future<String?> _readAccessToken() async => _storage.read(key: 'accessToken');
  Future<String?> _readRefreshToken() async =>
      _storage.read(key: 'refreshToken');
  Future<void> _clearTokens() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
  }

  Future<void> refreshAccessToken() async {
    final rt = await _storage.read(key: 'refreshToken');
    if (rt == null) throw Exception('No refresh token stored');

    final uri = Uri.parse('$_baseUrl/refresh-token');
    print(rt);
    final resp = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json', 'x-refresh-token': rt},
        )
        .timeout(const Duration(seconds: 10));

    print(resp);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      await _storage.write(key: 'accessToken', value: data['accessToken']);
    } else {
      final data = jsonDecode(resp.body);
      throw Exception(data['msg']);
    }
  }

  /// POST /login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/login');
    final resp = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(const Duration(seconds: 10));

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode == 200) {
      await _storage.write(key: 'accessToken', value: data['accessToken']);
      await _storage.write(key: 'refreshToken', value: data['refreshToken']);
      return data['user'] as Map<String, dynamic>;
    }
    throw Exception(data['msg'] ?? 'Login failed: \${resp.statusCode}');
  }

  /// POST /register
  Future<void> signUp({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('$_baseUrl/register');
    final resp = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'username': username,
            'password': password,
            'confirm': confirmPassword,
          }),
        )
        .timeout(const Duration(seconds: 10));
    final data = jsonDecode(resp.body);

    if (resp.statusCode != 200) {
      throw Exception('Registration failed: ${data['msg']}');
    }
  }

  /// GET /user/profile
  Future<Map<String, dynamic>> getProfile() async {
    final token = await _readAccessToken();
    if (token == null) throw Exception('No access token');

    final url = Uri.parse('$_baseUrl/user/profile');
    try {
      final resp = await http
          .get(url, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 3));

      if (resp.statusCode == 200) {
        return jsonDecode(resp.body) as Map<String, dynamic>;
      } else if (resp.statusCode == 403 || resp.statusCode == 401) {
        // Try to refresh token and retry once
        await refreshAccessToken();
        final retryToken = await _readAccessToken();
        final retryResp = await http
            .get(url, headers: {'Authorization': 'Bearer $retryToken'})
            .timeout(const Duration(seconds: 3));

        if (retryResp.statusCode == 200) {
          return jsonDecode(retryResp.body) as Map<String, dynamic>;
        } else {
          throw Exception('Profile retry failed: ${retryResp.statusCode}');
        }
      } else {
        throw Exception('Profile fetch failed: ${resp.statusCode}');
      }
    } catch (e) {
      throw Exception('Profile fetch error: $e');
    }
  }

  /// DELETE /logout
  Future<void> logout() async {
    final refreshToken = await _readRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token');

    final url = Uri.parse('$_baseUrl/logout');
    final resp = await http
        .delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            'x-refresh-token': refreshToken,
          },
        )
        .timeout(const Duration(seconds: 10));

    if (resp.statusCode == 200) {
      await _clearTokens();
      return;
    }
    throw Exception('Logout failed: ${resp.statusCode}');
  }

  Future<bool> staySignIn() async {
    try {
      await refreshAccessToken();
    } catch (e) {
      return false;
    }
    final accessToken = await _readAccessToken();
    if (accessToken == null) {
      return false;
    } else {
      return true;
    }
  }

  //   /// POST /products
  //   Future<Map<String, dynamic>> addProduct({
  //     required String name,
  //     required String description,
  //     required double price,
  //     required String imageUrl,
  //   }) async {
  //     final token = await _readAccessToken();
  //     if (token == null) throw Exception('No access token');

  //     final url = Uri.parse('$_baseUrl/products');
  //     final resp = await http
  //         .post(
  //           url,
  //           headers: {
  //             'Content-Type': 'application/json',
  //             'Authorization': 'Bearer \$token',
  //           },
  //           body: jsonEncode({
  //             'name': name,
  //             'description': description,
  //             'price': price,
  //             'imageUrl': imageUrl,
  //           }),
  //         )
  //         .timeout(const Duration(seconds: 10));

  //     if (resp.statusCode == 201) {
  //       return jsonDecode(resp.body) as Map<String, dynamic>;
  //     }
  //     throw Exception('Add product failed: \${resp.statusCode}');
  //   }
}
