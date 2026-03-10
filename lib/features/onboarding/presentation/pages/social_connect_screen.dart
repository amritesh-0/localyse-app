import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/auth/app_user_role.dart';
import '../../../../core/navigation/auth_flow_router.dart';
import '../../../../core/social/social_connection_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/feedback_utils.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/widgets/header_clipper.dart';

class SocialConnectScreen extends StatefulWidget {
  const SocialConnectScreen({super.key});

  @override
  State<SocialConnectScreen> createState() => _SocialConnectScreenState();
}

class _SocialConnectScreenState extends State<SocialConnectScreen>
    with WidgetsBindingObserver {
  final AuthRepository _authRepository = AuthRepositoryImpl();
  final SocialConnectionService _socialConnectionService =
      SocialConnectionService();

  StreamSubscription<Uri>? _linkSubscription;

  SocialConnectionStatus _instagramStatus = SocialConnectionStatus.idle;
  SocialConnectionStatus _youtubeStatus = SocialConnectionStatus.idle;
  String? _instagramSubtitle;
  String? _youtubeSubtitle;
  bool _isSaving = false;

  bool get _isInstagramConnected =>
      _instagramStatus == SocialConnectionStatus.connected;

  bool get _isYouTubeConnected =>
      _youtubeStatus == SocialConnectionStatus.connected;

  bool get _isAnyConnected => _isInstagramConnected || _isYouTubeConnected;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCurrentConnectionState();
    _listenForCallbackLinks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      return;
    }

    await _refreshStatusAfterReturn();
  }

  Future<void> _loadCurrentConnectionState() async {
    await _syncConnectionsFromBackend(showErrors: false);

    final user = _authRepository.currentUser;
    if (user == null) {
      return;
    }

    final userData = await _authRepository.getUserData(user.uid);
    if (!mounted || userData == null) {
      return;
    }

    final socialConnections = userData['socialConnections'];
    final instagramData = socialConnections is Map
        ? socialConnections['instagram']
        : null;
    final youtubeData = socialConnections is Map
        ? socialConnections['youtube']
        : null;

    setState(() {
      _instagramStatus = _readConnectedFlag(
                instagramData,
                legacyValue: userData['instagramConnected'],
              )
          ? SocialConnectionStatus.connected
          : SocialConnectionStatus.idle;
      _youtubeStatus = _readConnectedFlag(
                youtubeData,
                legacyValue: userData['youtubeConnected'],
              )
          ? SocialConnectionStatus.connected
          : SocialConnectionStatus.idle;
      _instagramSubtitle = _readProviderSubtitle(
        instagramData,
        fallbackLabel: 'Instagram connected',
      );
      _youtubeSubtitle = _readProviderSubtitle(
        youtubeData,
        fallbackLabel: 'YouTube connected',
      );
    });
  }

  Future<void> _refreshStatusAfterReturn() async {
    final hadPendingInstagram =
        _instagramStatus == SocialConnectionStatus.connecting;
    final hadPendingYouTube = _youtubeStatus == SocialConnectionStatus.connecting;

    await _syncConnectionsFromBackend(showErrors: false);
    if (_instagramStatus != SocialConnectionStatus.connected ||
        _youtubeStatus != SocialConnectionStatus.connected) {
      await _loadCurrentConnectionState();
    }

    if (!mounted) {
      return;
    }

    final instagramStillPending =
        hadPendingInstagram && _instagramStatus != SocialConnectionStatus.connected;
    final youtubeStillPending =
        hadPendingYouTube && _youtubeStatus != SocialConnectionStatus.connected;

    if (!instagramStillPending && !youtubeStillPending) {
      return;
    }

    setState(() {
      if (instagramStillPending) {
        _instagramStatus = SocialConnectionStatus.idle;
      }
      if (youtubeStillPending) {
        _youtubeStatus = SocialConnectionStatus.idle;
      }
    });

    AppFeedback.info(
      context,
      'Social connection was not completed. You can try again.',
    );
  }

  bool _readConnectedFlag(dynamic providerData, {dynamic legacyValue}) {
    if (providerData is Map && providerData['connected'] == true) {
      return true;
    }

    return legacyValue == true;
  }

  String? _readProviderSubtitle(dynamic providerData, {required String fallbackLabel}) {
    if (providerData is! Map) {
      return null;
    }

    final username = providerData['username']?.toString();
    final channelTitle = providerData['channelTitle']?.toString();
    if (username != null && username.isNotEmpty) {
      return '@$username';
    }
    if (channelTitle != null && channelTitle.isNotEmpty) {
      return channelTitle;
    }
    if (providerData['connected'] == true) {
      return fallbackLabel;
    }

    return null;
  }

  Future<void> _listenForCallbackLinks() async {
    final initialUri = await _socialConnectionService.getInitialCallbackUri();
    if (initialUri != null) {
      await _handleCallbackUri(initialUri);
    }

    _linkSubscription = _socialConnectionService.uriStream.listen((uri) async {
      await _handleCallbackUri(uri);
    });
  }

  Future<void> _handleCallbackUri(Uri uri) async {
    final result = _socialConnectionService.parseResult(uri);
    if (result == null || !mounted) {
      return;
    }

    final user = _authRepository.currentUser;
    if (user == null) {
      AppFeedback.error(context, 'Your session expired. Please sign in again.');
      return;
    }

    if (result.success) {
      await _syncConnectionsFromBackend(showErrors: true);

      if (!mounted) {
        return;
      }

      AppFeedback.success(
        context,
        '${result.provider == SocialProvider.instagram ? 'Instagram' : 'YouTube'} connected.',
      );
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      switch (result.provider) {
        case SocialProvider.instagram:
          _instagramStatus = SocialConnectionStatus.failed;
          break;
        case SocialProvider.youtube:
          _youtubeStatus = SocialConnectionStatus.failed;
          break;
      }
    });

    AppFeedback.error(
      context,
      result.message ?? 'Unable to complete social connection.',
    );
  }

  Future<void> _connectProvider(SocialProvider provider) async {
    final user = _authRepository.currentUser;
    if (user == null) {
      AppFeedback.error(context, 'Please sign in again before connecting.');
      return;
    }

    final idToken = await _authRepository.getCurrentUserIdToken();
    if (idToken == null || idToken.isEmpty) {
      if (mounted) {
        AppFeedback.error(
          context,
          'Unable to establish your app session. Please sign in again.',
        );
      }
      return;
    }

    setState(() {
      switch (provider) {
        case SocialProvider.instagram:
          _instagramStatus = SocialConnectionStatus.connecting;
          break;
        case SocialProvider.youtube:
          _youtubeStatus = SocialConnectionStatus.connecting;
          break;
      }
    });

    try {
      await _socialConnectionService.startAuthFlow(
        provider,
        uid: user.uid,
        idToken: idToken,
      );
      if (!mounted) {
        return;
      }

      AppFeedback.info(
        context,
        'Complete the ${provider == SocialProvider.instagram ? 'Instagram' : 'YouTube'} login in your browser.',
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        switch (provider) {
          case SocialProvider.instagram:
            _instagramStatus = SocialConnectionStatus.failed;
            break;
          case SocialProvider.youtube:
            _youtubeStatus = SocialConnectionStatus.failed;
            break;
        }
      });

      AppFeedback.error(context, e.toString());
    }
  }

  Future<void> _handleFinish() async {
    setState(() => _isSaving = true);
    try {
      final user = _authRepository.currentUser;
      if (user != null) {
        await _authRepository.updateUserData(user.uid, {
          'role': AppUserRole.influencer.value,
          'socialConnectionsCompleted': _isAnyConnected,
          'instagramConnected': _isInstagramConnected,
          'youtubeConnected': _isYouTubeConnected,
        });
        await _authRepository.completeOnboarding(user.uid);
      }
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => buildDashboardForRole(AppUserRole.influencer),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        AppFeedback.error(context, 'Unable to finish onboarding: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<String?> _getCurrentIdToken() async {
    final idToken = await _authRepository.getCurrentUserIdToken();
    if (idToken == null || idToken.isEmpty) {
      return null;
    }
    return idToken;
  }

  Future<void> _syncConnectionsFromBackend({required bool showErrors}) async {
    final user = _authRepository.currentUser;
    final idToken = await _getCurrentIdToken();
    if (user == null || idToken == null) {
      return;
    }

    try {
      final connections = await _socialConnectionService.fetchConnections(
        idToken: idToken,
      );

      final instagramConnection = connections[SocialProvider.instagram];
      final youtubeConnection = connections[SocialProvider.youtube];

      await _authRepository.updateUserData(user.uid, {
        'instagramConnected': instagramConnection?.connected ?? false,
        'youtubeConnected': youtubeConnection?.connected ?? false,
        'socialConnections': {
          'instagram': {
            'connected': instagramConnection?.connected ?? false,
            ...?instagramConnection?.profile,
          },
          'youtube': {
            'connected': youtubeConnection?.connected ?? false,
            ...?youtubeConnection?.profile,
          },
        },
      });

      if (!mounted) {
        return;
      }

      setState(() {
        _instagramStatus = instagramConnection?.connected == true
            ? SocialConnectionStatus.connected
            : SocialConnectionStatus.idle;
        _youtubeStatus = youtubeConnection?.connected == true
            ? SocialConnectionStatus.connected
            : SocialConnectionStatus.idle;
        _instagramSubtitle = _profileSubtitle(
          instagramConnection?.profile,
          fallbackLabel: 'Instagram connected',
        );
        _youtubeSubtitle = _profileSubtitle(
          youtubeConnection?.profile,
          fallbackLabel: 'YouTube connected',
        );
      });
    } catch (error) {
      if (showErrors && mounted) {
        AppFeedback.error(
          context,
          'Unable to refresh social connection status.',
        );
      }
    }
  }

  String? _profileSubtitle(
    Map<String, dynamic>? profile, {
    required String fallbackLabel,
  }) {
    if (profile == null) {
      return null;
    }

    final username = profile['username']?.toString();
    final channelTitle = profile['channelTitle']?.toString();
    final displayName = profile['displayName']?.toString();

    if (username != null && username.isNotEmpty) {
      return '@$username';
    }
    if (channelTitle != null && channelTitle.isNotEmpty) {
      return channelTitle;
    }
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    return fallbackLabel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipPath(
                      clipper: HeaderClipper(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.23,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.primary, Color(0xFF8B5CF6)],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 12, top: 8),
                              child: Text(
                                'Boost Your Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Connect the platforms you actively use so your creator profile stays credible and brand-ready.',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified_user_outlined, size: 14, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  'META & GOOGLE VERIFIED API',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _socialConnectCard(
                        title: 'Connect Instagram',
                        subtitle: _instagramSubtitle ??
                            'Showcase your visual content and audience credibility.',
                        icon: Icons.camera_alt_rounded,
                        onTap: () => _connectProvider(SocialProvider.instagram),
                        isInstagram: true,
                        status: _instagramStatus,
                      ),
                      const SizedBox(height: 20),
                      _socialConnectCard(
                        title: 'Connect YouTube',
                        subtitle: _youtubeSubtitle ??
                            'Highlight your video reach and channel presence.',
                        icon: Icons.play_circle_fill_rounded,
                        color: const Color(0xFFFF0000),
                        onTap: () => _connectProvider(SocialProvider.youtube),
                        status: _youtubeStatus,
                      ),
                      const SizedBox(height: 60),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (_isSaving || !_isAnyConnected)
                              ? null
                              : _handleFinish,
                          child: _isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('FINISH'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: (_isSaving || !_isAnyConnected)
                              ? null
                              : _handleFinish,
                          child: const Text(
                            'Continue collab and connect later',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isSaving)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _socialConnectCard({
    required String title,
    required String subtitle,
    required IconData icon,
    Color color = AppColors.primary,
    required VoidCallback onTap,
    bool isInstagram = false,
    required SocialConnectionStatus status,
  }) {
    final isConnected = status == SocialConnectionStatus.connected;
    final isConnecting = status == SocialConnectionStatus.connecting;
    final isFailed = status == SocialConnectionStatus.failed;

    return GestureDetector(
      onTap: isConnected || isConnecting ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isConnected
                ? AppColors.primary.withAlpha(50)
                : isFailed
                    ? AppColors.error.withAlpha(90)
                    : Colors.transparent, // Clean design: no border by default
            width: isConnected || isFailed ? 2 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isConnected ? 4 : 8),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: isInstagram
                    ? const LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color(0xFFF58529),
                          Color(0xFFFEDA77),
                          Color(0xFFDD2A7B),
                          Color(0xFF8134AF),
                          Color(0xFF515BD4),
                        ],
                      )
                    : null,
                color: isInstagram ? null : (isConnected ? color : color.withAlpha(25)),
                shape: BoxShape.circle,
              ),
              child: isConnecting
                  ? const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      icon,
                      color: (isInstagram || isConnected) ? Colors.white : color,
                      size: 30,
                    ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            _statusIcon(status),
          ],
        ),
      ),
    );
  }

  Widget _statusIcon(SocialConnectionStatus status) {
    switch (status) {
      case SocialConnectionStatus.idle:
        return const Icon(Icons.add_circle_outline, color: AppColors.textHint);
      case SocialConnectionStatus.connecting:
        return const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case SocialConnectionStatus.connected:
        return const Icon(Icons.check_circle, color: AppColors.success);
      case SocialConnectionStatus.failed:
        return const Icon(Icons.error_outline, color: AppColors.error);
    }
  }
}
