import 'package:shared_preferences/shared_preferences.dart';

/// Servicio local de autenticación para propósitos educativos.
///
/// IMPORTANTE: guardar contraseñas en texto plano NO es seguro en producción.
/// Aquí se hace así porque el requisito del proyecto es autenticación local.
class SessionStorage {
  SessionStorage._();

  static const String _isLoggedInKey = 'is_logged_in';
  static const String _usernameKey = 'local_username';
  static const String _passwordKey = 'local_password';

  static Future<bool> hasActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> saveSessionStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  static Future<void> registerUser({
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_passwordKey, password);
  }

  static Future<bool> hasRegisteredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_usernameKey);
    final password = prefs.getString(_passwordKey);

    return username != null && username.isNotEmpty && password != null;
  }

  static Future<bool> validateCredentials({
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString(_usernameKey);
    final savedPassword = prefs.getString(_passwordKey);

    return username == savedUsername && password == savedPassword;
  }

  static Future<String?> getRegisteredUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
  }
}
