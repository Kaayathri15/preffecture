import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static final String _baseUrl = dotenv.get('API_BASE_URL');
  static String get _customerEndpoint => "$_baseUrl/customer";

  static http.Client _createClient() {
    if (kDebugMode) {
      final HttpClient ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return IOClient(ioc);
    }
    return http.Client();
  }

  // Standard Login/Register
  static Future<Map<String, dynamic>> authenticate({
    required Map<String, dynamic> body,
    bool isLogin = true,
  }) async {
    final String endpoint = isLogin
        ? "$_customerEndpoint/login"
        : "$_customerEndpoint/register";
    return _postRequest(endpoint, body);
  }

  // Social Login (Token Exchange)
  static Future<Map<String, dynamic>> socialAuthenticate({
    required String provider,
    required String token,
  }) async {
    final String endpoint = "$_customerEndpoint/login/$provider/callback";
    return _postRequest(endpoint, {'token': token});
  }

  static Future<Map<String, dynamic>> _postRequest(
  String url,
  Map<String, dynamic> body,
) async {
  final http.Client client = _createClient();

  try {
    final http.Response response = await client.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    debugPrint("RAW RESPONSE STATUS: ${response.statusCode}");
    debugPrint("RAW RESPONSE BODY: ${response.body}");

    Map<String, dynamic> decoded;

    if (response.body.isNotEmpty) {
      decoded = jsonDecode(response.body);
    } else {
      decoded = {"message": "Empty server response"};
    }

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
}
