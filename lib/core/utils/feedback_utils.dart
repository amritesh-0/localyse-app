import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum FeedbackType { success, error, info }

class AppFeedback {
  static void show(
    BuildContext context, {
    required String message,
    FeedbackType type = FeedbackType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final mediaQuery = MediaQuery.of(context);
    
    // Clear existing snackbars
    scaffoldMessenger.removeCurrentSnackBar();

    Color accentColor;
    IconData icon;
    
    switch (type) {
      case FeedbackType.success:
        accentColor = AppColors.success;
        icon = Icons.check_circle_outline_rounded;
        break;
      case FeedbackType.error:
        accentColor = AppColors.error;
        icon = Icons.error_outline_rounded;
        break;
      case FeedbackType.info:
        accentColor = AppColors.primary;
        icon = Icons.info_outline_rounded;
        break;
    }

    scaffoldMessenger.showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: accentColor, size: 22),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: mediaQuery.padding.bottom + 20,
          left: 20,
          right: 20,
        ),
      ),
    );
  }

  static void success(BuildContext context, String message) {
    show(context, message: message, type: FeedbackType.success);
  }

  static void error(BuildContext context, String message) {
    show(context, message: message, type: FeedbackType.error);
  }

  static void info(BuildContext context, String message) {
    show(context, message: message, type: FeedbackType.info);
  }
}
