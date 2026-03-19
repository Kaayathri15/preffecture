import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {

  static final String _baseUrl = dotenv.get('API_BASE_URL');

  /// STORE ACCESS TOKEN
  static String? accessToken;

  static http.Client _createClient() {
    if (kDebugMode) {
      final HttpClient ioc = HttpClient()
        ..badCertificateCallback = (cert, host, port) => true;
      return IOClient(ioc);
    }
    return http.Client();
  }

  /// LOGIN / REGISTER
  static Future<Map<String, dynamic>> authenticate({
    required Map<String, dynamic> body,
    required bool isLogin,
  }) async {

    final String url = isLogin
        ? "$_baseUrl/login"
        : "$_baseUrl/register";

    final result = await _postRequest(url, body);

    /// SAVE TOKEN
    if (result["success"] && result["data"]["access_token"] != null) {
      accessToken = result["data"]["access_token"];
    }

    return result;
  }

  /// GOOGLE LOGIN
  static Future<Map<String, dynamic>> googleLogin({
    required String token,
  }) async {

    final String url = "$_baseUrl/auth/google/login";

    final result = await _postRequest(url, {'token': token});

    if (result["success"] && result["data"]["access_token"] != null) {
      accessToken = result["data"]["access_token"];
    }

    return result;
  }

  /// GOOGLE REGISTER
  static Future<Map<String, dynamic>> googleRegister({
    required String token,
  }) async {

    final String url = "$_baseUrl/auth/google/register";

    final result = await _postRequest(url, {'token': token});

    if (result["success"] && result["data"]["access_token"] != null) {
      accessToken = result["data"]["access_token"];
    }

    return result;
  }

  /// POST REQUEST
  static Future<Map<String, dynamic>> _postRequest(
      String url,
      Map<String, dynamic> body,
      ) async {

    final client = _createClient();

    try {

      final response = await client.post(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          if (accessToken != null)
            "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(body),
      );

      final decoded = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : {"message": "Empty server response"};

      return {
        "success": response.statusCode >= 200 && response.statusCode < 300,
        "data": decoded,
      };

    } catch (e) {

      return {
        "success": false,
        "data": {"message": "Connection error: $e"},
      };

    } finally {
      client.close();
    }
  }

  /// GET REQUEST
  static Future<Map<String, dynamic>> _getRequest(String url) async {

    final client = _createClient();

    try {

      final response = await client.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          if (accessToken != null)
            "Authorization": "Bearer $accessToken"
        },
      );

      final decoded = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : {"message": "Empty response"};

      return {
        "success": response.statusCode >= 200 && response.statusCode < 300,
        "data": decoded,
      };

    } catch (e) {

      return {
        "success": false,
        "data": {"message": "Connection error: $e"}
      };

    } finally {
      client.close();
    }
  }

  /// GET USER PROFILE
  static Future<Map<String, dynamic>> getUser() async {

    final String url = "$_baseUrl/user";

    return _getRequest(url);
  }

  /// UPDATE PROFILE
  static Future<Map<String, dynamic>> updateProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String nationality,
    required String gender,
  }) async {

    final String url = "$_baseUrl/profile/update";

    return _postRequest(url, {
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phoneNumber,
      "nationality": nationality,
      "gender": gender
    });
  }

}