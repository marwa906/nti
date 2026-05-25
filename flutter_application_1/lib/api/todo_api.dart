import 'dart:convert';

import 'package:http/http.dart' as http;

class TodoApiException implements Exception {
  TodoApiException(this.message, {this.statusCode, this.responseBody});

  final String message;
  final int? statusCode;
  final String? responseBody;

  @override
  String toString() => 'TodoApiException(statusCode: $statusCode, $message)';
}

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.username,
  });

  final String accessToken;
  final String refreshToken;
  final int userId;
  final String username;
}

class ApiTask {
  const ApiTask({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAtRaw,
    required this.imagePath,
  });

  final int id;
  final String title;
  final String description;
  final String createdAtRaw;
  final String? imagePath;
}

ApiTask _apiTaskFromJson(Map<String, dynamic> map) {
  return ApiTask(
    id: (map['id'] as num).toInt(),
    title: (map['title'] as String?) ?? '',
    description: (map['description'] as String?) ?? '',
    createdAtRaw: (map['created_at'] as String?) ?? '',
    imagePath: map['image_path'] as String?,
  );
}

class TodoApi {
  TodoApi({
    http.Client? client,
    String baseUrl = 'https://ntitodo-production-463a.up.railway.app',
  })  : _client = client ?? http.Client(),
        baseUrl = _normalizeBaseUrl(baseUrl);

  final http.Client _client;
  final String baseUrl;

  static String _normalizeBaseUrl(String raw) {
    String url = raw.trim();
    while (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    if (url.endsWith('/api')) {
      url = url.substring(0, url.length - 4);
    }
    return url;
  }

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<void> register({
    required String username,
    required String password,
  }) async {
    final http.Response res = await _client.post(
      _uri('/api/register'),
      body: <String, String>{'username': username, 'password': password},
    );

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw TodoApiException(
        'Register failed.',
        statusCode: res.statusCode,
        responseBody: res.body,
      );
    }

    try {
      final Object? decoded = jsonDecode(res.body);
      if (decoded is Map) {
        final Map<String, dynamic> json = decoded.cast<String, dynamic>();
        final Object? status = json['status'];
        if (status is bool && status == false) {
          throw TodoApiException(
            (json['message'] as String?) ?? 'Register failed.',
            statusCode: res.statusCode,
            responseBody: res.body,
          );
        }
      }
    } catch (_) {
      // Ignore non-JSON responses.
    }
  }

  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    final http.Response res = await _client.post(
      _uri('/api/login'),
      body: <String, String>{'username': username, 'password': password},
    );

    if (res.statusCode != 200) {
      throw TodoApiException(
        'Login failed.',
        statusCode: res.statusCode,
        responseBody: res.body,
      );
    }

    final Map<String, dynamic> json =
        jsonDecode(res.body) as Map<String, dynamic>;
    if (json['status'] != true) {
      throw TodoApiException(
        (json['message'] as String?) ?? 'Login failed.',
        statusCode: res.statusCode,
        responseBody: res.body,
      );
    }

    final Map<String, dynamic> user = (json['user'] as Map)
        .cast<String, dynamic>();

    return AuthSession(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      userId: user['id'] as int,
      username: user['username'] as String,
    );
  }

  Future<List<ApiTask>> myTasks({required String accessToken}) async {
    final http.Response res = await _client.get(
      _uri('/api/my_tasks'),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (res.statusCode == 401) {
      throw TodoApiException('Unauthorized.', statusCode: 401);
    }
    if (res.statusCode != 200) {
      throw TodoApiException(
        'Failed to load tasks.',
        statusCode: res.statusCode,
      );
    }

    final Map<String, dynamic> json =
        jsonDecode(res.body) as Map<String, dynamic>;
    final List<dynamic> tasks =
        (json['tasks'] as List<dynamic>?) ?? <dynamic>[];

    return tasks.whereType<Map<dynamic, dynamic>>().map((
      Map<dynamic, dynamic> raw,
    ) {
      return _apiTaskFromJson(raw.cast<String, dynamic>());
    }).toList();
  }

  Future<ApiTask?> createTask({
    required String accessToken,
    required String title,
    required String description,
  }) async {
    final http.Response res = await _client.post(
      _uri('/api/new_task'),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
      body: <String, String>{'title': title, 'description': description},
    );

    if (res.statusCode == 401) {
      throw TodoApiException('Unauthorized.', statusCode: 401);
    }
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw TodoApiException(
        'Create task failed.',
        statusCode: res.statusCode,
        responseBody: res.body,
      );
    }

    if (res.body.trim().isEmpty) {
      return null;
    }

    final Object? decoded = jsonDecode(res.body);
    if (decoded is! Map) {
      return null;
    }
    final Map<String, dynamic> json = decoded.cast<String, dynamic>();
    final Object? status = json['status'];
    if (status is bool && !status) {
      throw TodoApiException(
        (json['message'] as String?) ?? 'Create task failed.',
        statusCode: res.statusCode,
        responseBody: res.body,
      );
    }

    final Object? task = json['task'] ?? json['data'];
    if (task is Map) {
      return _apiTaskFromJson(task.cast<String, dynamic>());
    }
    return null;
  }

  Future<void> updateTask({
    required String accessToken,
    required int id,
    required String title,
    required String description,
  }) async {
    final http.Response res = await _client.put(
      _uri('/api/tasks/$id'),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
      body: <String, String>{'title': title, 'description': description},
    );

    if (res.statusCode == 401) {
      throw TodoApiException('Unauthorized.', statusCode: 401);
    }
    if (res.statusCode == 403) {
      throw TodoApiException('Forbidden.', statusCode: 403);
    }
    if (res.statusCode != 200) {
      throw TodoApiException('Update failed.', statusCode: res.statusCode);
    }
  }

  Future<void> deleteTask({
    required String accessToken,
    required int id,
  }) async {
    final http.Response res = await _client.delete(
      _uri('/api/tasks/$id'),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (res.statusCode == 401) {
      throw TodoApiException('Unauthorized.', statusCode: 401);
    }
    if (res.statusCode == 403) {
      throw TodoApiException('Forbidden.', statusCode: 403);
    }
    if (res.statusCode != 200) {
      throw TodoApiException('Delete failed.', statusCode: res.statusCode);
    }
  }
}
