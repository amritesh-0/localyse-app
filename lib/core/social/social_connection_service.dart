import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'social_auth_config.dart';

enum SocialProvider {
  instagram,
  youtube,
}

enum SocialConnectionStatus {
  idle,
  connecting,
  connected,
  failed,
}

class SocialConnectionResult {
  const SocialConnectionResult({
    required this.provider,
    required this.success,
    this.message,
    this.metadata = const {},
  });

  final SocialProvider provider;
  final bool success;
  final String? message;
  final Map<String, String> metadata;
}

class SocialAccountConnection {
  const SocialAccountConnection({
    required this.provider,
    required this.connected,
    required this.profile,
  });

  final SocialProvider provider;
  final bool connected;
  final Map<String, dynamic> profile;
}

class SocialConnectionService {
  SocialConnectionService({AppLinks? appLinks}) : _appLinks = appLinks ?? AppLinks();

  final AppLinks _appLinks;

  Stream<Uri> get uriStream => _appLinks.uriLinkStream;

  Uri? parseSupportedCallback(Uri uri) {
    final expectedBase = SocialAuthConfig.callbackBaseUri;
    if (uri.scheme != expectedBase.scheme || uri.host != expectedBase.host) {
      return null;
    }

    return uri;
  }

  SocialConnectionResult? parseResult(Uri uri) {
    final callbackUri = parseSupportedCallback(uri);
    if (callbackUri == null) {
      return null;
    }

    final providerValue = callbackUri.queryParameters['provider'];
    final statusValue = callbackUri.queryParameters['status'];
    if (providerValue == null || statusValue == null) {
      return null;
    }

    final provider = switch (providerValue.toLowerCase()) {
      'instagram' => SocialProvider.instagram,
      'youtube' => SocialProvider.youtube,
      _ => null,
    };

    if (provider == null) {
      return null;
    }

    return SocialConnectionResult(
      provider: provider,
      success: statusValue.toLowerCase() == 'success',
      message: callbackUri.queryParameters['message'],
      metadata: callbackUri.queryParameters.map(
        (key, value) => MapEntry(key, value),
      ),
    );
  }

  Future<Uri?> getInitialCallbackUri() async {
    final uri = await _appLinks.getInitialLink();
    if (uri == null) {
      return null;
    }

    return parseSupportedCallback(uri);
  }

  Future<void> startAuthFlow(
    SocialProvider provider, {
    required String uid,
    required String idToken,
  }) async {
    final providerName = switch (provider) {
      SocialProvider.instagram => 'instagram',
      SocialProvider.youtube => 'youtube',
    };

    final response = await http.post(
      SocialAuthConfig.providerSessionUri(providerName),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: '{"uid":"$uid"}',
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'Unable to start ${provider.name} authentication: ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final authorizationUrl = decoded['authorizationUrl']?.toString();

    if (authorizationUrl == null || authorizationUrl.isEmpty) {
      throw StateError('Missing authorization URL from social backend.');
    }

    final uri = Uri.parse(authorizationUrl);

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      throw StateError('Unable to open ${provider.name} authentication.');
    }
  }

  Future<Map<SocialProvider, SocialAccountConnection>> fetchConnections({
    required String idToken,
  }) async {
    final response = await http.get(
      SocialAuthConfig.connectionsUri,
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('Unable to fetch connection status: ${response.body}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final connections = <SocialProvider, SocialAccountConnection>{};

    final items = decoded['connections'];
    if (items is! List) {
      return connections;
    }

    for (final item in items) {
      if (item is! Map<String, dynamic>) {
        continue;
      }

      final provider = switch (item['provider']?.toString()) {
        'instagram' => SocialProvider.instagram,
        'youtube' => SocialProvider.youtube,
        _ => null,
      };

      if (provider == null) {
        continue;
      }

      connections[provider] = SocialAccountConnection(
        provider: provider,
        connected: true,
        profile: Map<String, dynamic>.from(item['profile'] as Map? ?? const {}),
      );
    }

    return connections;
  }
}
