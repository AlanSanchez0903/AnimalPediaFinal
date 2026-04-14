class AppConstants {
  AppConstants._();

  static const String appName = 'Animalpedia';

  /// URL base de desAPI1. Cambiar con:
  /// flutter run --dart-define=DES_API_BASE_URL=http://<TU_IP>:8000
  static const String desApiBaseUrl = String.fromEnvironment(
    'DES_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  /// URL base de imgAPI2. Cambiar con:
  /// flutter run --dart-define=IMG_API_BASE_URL=http://<TU_IP>:8001
  static const String imgApiBaseUrl = String.fromEnvironment(
    'IMG_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8001',
  );
}
