import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../error/exceptions.dart';

class ApiClient {
  final http.Client client;

  ApiClient({http.Client? client}) : client = client ?? http.Client();

  Future<dynamic> get(String path, {Map<String, String>? queryParams}) async {
    final uri = Uri.parse(ApiConfig.baseUrl + path).replace(
      queryParameters: queryParams,
    );

    final response = await client.get(uri);

    return _handleResponse(response);
  }

  Future<dynamic> post(
      String path, {
        Map<String, dynamic>? body,
      }) async {
    final uri = Uri.parse(ApiConfig.baseUrl + path);

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body ?? {}),
    );

    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final decoded = jsonDecode(response.body);

    if (statusCode >= 200 && statusCode < 300) {
      return decoded;
    } else {
      final msg = (decoded is Map && decoded['error'] != null)
          ? decoded['error'].toString()
          : 'Server xətası: $statusCode';
      throw ServerException(msg);
    }
  }
}
