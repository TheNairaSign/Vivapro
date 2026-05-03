import 'package:flutter_contacts/models/contact/contact.dart';
import 'package:url_launcher/url_launcher.dart';
import 'whatsapp_launcher.dart';

class MessageOptions {
  /// Launches the default SMS app
  static Future<bool> sendSMS({
    required String phoneNumber,
    String? message,
  }) async {
    try {
      final cleaned = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      
      // On iOS, query parameters in sms scheme are handled differently sometimes,
      // but 'body' is the standard.
      final uri = Uri(
        scheme: 'sms',
        path: cleaned,
        query: message != null ? 'body=${Uri.encodeComponent(message)}' : null,
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Launches WhatsApp chat
  static Future<bool> sendWhatsApp({
    required String phoneNumber,
    String? message,
  }) async {
    return await WhatsAppLauncher.launch(
      phoneNumber: phoneNumber,
      action: WhatsAppAction.chat,
      message: message,
    );
  }

  /// Helper to send SMS using a Contact object
  static Future<bool> initiateSMS(Contact contact, {String? message}) async {
    if (contact.phones.isEmpty) return false;
    return await sendSMS(
      phoneNumber: contact.phones.first.number,
      message: message,
    );
  }

  /// Helper to send WhatsApp using a Contact object
  static Future<bool> initiateWhatsApp(Contact contact, {String? message}) async {
    if (contact.phones.isEmpty) return false;
    return await sendWhatsApp(
      phoneNumber: contact.phones.first.number,
      message: message,
    );
  }
}