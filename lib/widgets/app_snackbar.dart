import 'package:flutter/material.dart';
import 'package:koffee_bistro/theme/app_theme.dart';

class AppSnackbar {
  static void show(BuildContext context, String message, Duration duration) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        content: Text(
          message,
          style: const TextStyle(
            color: AppTheme.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }
}