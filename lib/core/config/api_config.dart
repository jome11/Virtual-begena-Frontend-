class ApiConfig {
  // Base URL for the backend API.
  // Can be overridden during build/run with --dart-define=API_BASE_URL=...
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://backend-44p3.onrender.com/api',
  );
}
