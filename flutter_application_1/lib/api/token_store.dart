import 'package:shared_preferences/shared_preferences.dart';

class TokenStore {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _usernameKey = 'username';
  static const String _userIdKey = 'user_id';

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String username,
    required int userId,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setString(_usernameKey, username);
    await prefs.setInt(_userIdKey, userId);
  }

  Future<StoredSession?> readSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString(_accessTokenKey);
    final String? refreshToken = prefs.getString(_refreshTokenKey);
    final String? username = prefs.getString(_usernameKey);
    final int? userId = prefs.getInt(_userIdKey);

    if (accessToken == null ||
        refreshToken == null ||
        username == null ||
        userId == null) {
      return null;
    }

    return StoredSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      username: username,
      userId: userId,
    );
  }

  Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_userIdKey);
  }
}

class StoredSession {
  const StoredSession({
    required this.accessToken,
    required this.refreshToken,
    required this.username,
    required this.userId,
  });

  final String accessToken;
  final String refreshToken;
  final String username;
  final int userId;
}
