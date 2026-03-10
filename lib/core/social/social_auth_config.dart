class SocialAuthConfig {
  static const String backendBaseUrl = String.fromEnvironment(
    'SOCIAL_BACKEND_BASE_URL',
    defaultValue: 'https://localyse-app.onrender.com',
  );

  static const String callbackScheme = String.fromEnvironment(
    'SOCIAL_CALLBACK_SCHEME',
    defaultValue: 'localyse',
  );

  static const String callbackHost = String.fromEnvironment(
    'SOCIAL_CALLBACK_HOST',
    defaultValue: 'social-connect',
  );

  static Uri get callbackBaseUri => Uri(
        scheme: callbackScheme,
        host: callbackHost,
      );

  static Uri providerSessionUri(String provider) =>
      Uri.parse('$backendBaseUrl/api/$provider/session');

  static Uri get connectionsUri =>
      Uri.parse('$backendBaseUrl/api/social/connections');
}
