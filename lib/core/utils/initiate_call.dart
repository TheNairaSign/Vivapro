import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class CallOptions {

  static Future<bool> callWithPhone(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      await launchUrl(uri);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool?> callNumberDirectly(String phoneNumber) async {
    final result = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    return result;
  }

  static Future<bool> callWithWhatsApp(String phoneNumber) async {
    final formattedNumber = phoneNumber.replaceAll(RegExp(r'\s+|\+'), '');

    final uri = Uri.parse('https://wa.me/$formattedNumber');

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> launchWhatsAppCall({
    required String phoneNumber,
    bool video = false,
  }) async {
    try {
      final cleaned = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

      final uri = Uri.parse(
        video
            ? 'whatsapp://call?phone=$cleaned&video=true'
            : 'whatsapp://call?phone=$cleaned',
      );

      final canLaunch = await canLaunchUrl(uri);

      if (!canLaunch) return false;

      await launchUrl(uri, mode: LaunchMode.externalApplication);

      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> launchFaceTime({
    required String phoneNumber,
    bool video = true,
  }) async {
    try {
      // Keeps digits and the leading '+' if present
      final cleaned = phoneNumber.replaceAll(RegExp(r'[^\+0-9]'), '');
      final scheme = video ? 'facetime' : 'facetime-audio';

      // Use Uri.scheme for safer construction
      final Uri uri = Uri(scheme: scheme, path: cleaned);

      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      // Consider logging 'e' for debugging
      return false;
    }
  }



  static Future<bool> isWhatsAppInstalled(String phoneNumber) async {
    final formattedNumber = phoneNumber.replaceAll(RegExp(r'\s+|\+'), '');

    final uri = Uri.parse('https://wa.me/$formattedNumber');
    return await canLaunchUrl(uri);
  }

}

