import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Servicio local de autenticación para propósitos educativos.
///
/// IMPORTANTE: guardar contraseñas en texto plano NO es seguro en producción.
/// Aquí se hace así porque el requisito del proyecto es autenticación local.
class SessionStorage {
  SessionStorage._();

  static const String _isLoggedInKey = 'is_logged_in';
  static const String _registeredUsersKey = 'registered_users';
  static const String _currentUserKey = 'current_user';

  static const int minUsernameLength = 4;
  static const int minPasswordLength = 6;

  static Future<bool> hasActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    final currentUser = prefs.getString(_currentUserKey);

    return isLoggedIn && currentUser != null && currentUser.trim().isNotEmpty;
  }

  static Future<void> saveSessionStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);

    if (!isLoggedIn) {
      await prefs.remove(_currentUserKey);
    }
  }

  static Future<void> registerUser({
    required String username,
    required String password,
  }) async {
    final sanitizedUsername = username.trim();

    if (sanitizedUsername.length < minUsernameLength) {
      throw SessionStorageException(
        'El username debe tener mínimo $minUsernameLength caracteres.',
      );
    }

    if (password.length < minPasswordLength) {
      throw SessionStorageException(
        'La contraseña debe tener mínimo $minPasswordLength caracteres.',
      );
    }

    final users = await _getRegisteredUsers();
    final usernameAlreadyExists = users.any(
      (user) => user.username.toLowerCase() == sanitizedUsername.toLowerCase(),
    );

    if (usernameAlreadyExists) {
      throw const SessionStorageException('Ese username ya está registrado.');
    }

    users.add(_LocalUser(username: sanitizedUsername, password: password));
    await _saveRegisteredUsers(users);
    await setCurrentAuthenticatedUser(sanitizedUsername);
    await saveSessionStatus(true);
  }

  static Future<bool> hasRegisteredUser() async {
    final users = await _getRegisteredUsers();
    return users.isNotEmpty;
  }

  static Future<bool> validateCredentials({
    required String username,
    required String password,
  }) async {
    final sanitizedUsername = username.trim();
    final users = await _getRegisteredUsers();

    final matchedUser = users.where(
      (user) =>
          user.username.toLowerCase() == sanitizedUsername.toLowerCase() &&
          user.password == password,
    );

    return matchedUser.isNotEmpty;
  }

  static Future<void> setCurrentAuthenticatedUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, username.trim());
  }

  static Future<String?> getCurrentAuthenticatedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  static Future<String?> getRegisteredUsername() async {
    final currentUser = await getCurrentAuthenticatedUser();
    if (currentUser != null && currentUser.trim().isNotEmpty) {
      return currentUser;
    }

    final users = await _getRegisteredUsers();
    return users.isEmpty ? null : users.first.username;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_currentUserKey);
  }

  static Future<List<_LocalUser>> _getRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final rawUsers = prefs.getStringList(_registeredUsersKey) ?? <String>[];

    return rawUsers.map((rawUser) => _LocalUser.fromRawJson(rawUser)).toList();
  }

  static Future<void> _saveRegisteredUsers(List<_LocalUser> users) async {
    final prefs = await SharedPreferences.getInstance();
    final rawUsers = users.map((user) => user.toRawJson()).toList();
    await prefs.setStringList(_registeredUsersKey, rawUsers);
  }
}

class SessionStorageException implements Exception {
  const SessionStorageException(this.message);

  final String message;

  @override
  String toString() => message;
}

class _LocalUser {
  const _LocalUser({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  String toRawJson() => jsonEncode({'username': username, 'password': password});

  factory _LocalUser.fromRawJson(String rawJson) {
    final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
    return _LocalUser(
      username: decoded['username'] as String? ?? '',
      password: decoded['password'] as String? ?? '',
    );
  }
}
