import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

enum WhatsAppAction {
  chat,
  voiceCall,
  videoCall,
}

class WhatsAppLauncher {
  /// Public entry point
  static Future<bool> launch({
    required String phoneNumber,
    WhatsAppAction action = WhatsAppAction.chat,
    String? message,
  }) async {
    try {
      final cleaned = _sanitizeNumber(phoneNumber);

      if (cleaned.isEmpty) {
        debugPrint('WhatsAppLauncher: invalid phone number');
        return false;
      }

      // 🔹 Try native WhatsApp scheme first
      final uri = _buildWhatsAppUri(
        phone: cleaned,
        action: action,
        message: message,
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }

      // 🔹 Fallback to wa.me (chat only reliable fallback)
      if (action == WhatsAppAction.chat) {
        final fallback = Uri.parse(
          'https://wa.me/$cleaned${_messageQuery(message)}',
        );

        if (await canLaunchUrl(fallback)) {
          await launchUrl(
            fallback,
            mode: LaunchMode.externalApplication,
          );
          return true;
        }
      }

      // 🔹 Final fallback → store
      await _openStore();
      return false;
    } catch (e) {
      debugPrint('WhatsAppLauncher error: $e');
      return false;
    }
  }

  // =============================
  // 🔧 Helpers
  // =============================

  static String _sanitizeNumber(String input) {
    // remove everything except digits
    return input.replaceAll(RegExp(r'[^\d]'), '');
  }

  static Uri _buildWhatsAppUri({
    required String phone,
    required WhatsAppAction action,
    String? message,
  }) {
    switch (action) {
      case WhatsAppAction.chat:
        return Uri.parse(
          'whatsapp://send?phone=$phone${_messageQuery(message)}',
        );

      case WhatsAppAction.voiceCall:
        return Uri.parse(
          'whatsapp://call?phone=$phone',
        );

      case WhatsAppAction.videoCall:
        // ⚠️ unofficial but works on many devices
        return Uri.parse(
          'whatsapp://call?phone=$phone&video=true',
        );
    }
  }

  static String _messageQuery(String? message) {
    if (message == null || message.isEmpty) return '';
    return '&text=${Uri.encodeComponent(message)}';
  }

  static Future<void> _openStore() async {
    final uri = Platform.isAndroid
        ? Uri.parse(
            'https://play.google.com/store/apps/details?id=com.whatsapp',
          )
        : Uri.parse('https://apps.apple.com/app/whatsapp-messenger/id310633997');

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
