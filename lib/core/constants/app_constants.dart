class AppConstants {
  AppConstants._();

  static const String appName = 'Animalpedia';
  static const String animalsSectionTitle = 'Mamíferos destacados';

  // APIs internas FastAPI.
  static const String desApiBaseUrl = String.fromEnvironment(
    'DES_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static const String imgApiBaseUrl = String.fromEnvironment(
    'IMG_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8001',
  );
}
