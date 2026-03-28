import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> callWithPhone(String phoneNumber) async {
  final uri = Uri(scheme: 'tel', path: phoneNumber);

  try {
    await launchUrl(uri);
    return true;
  } catch (_) {
    return false;
  }
}

// Future<bool?> callNumberDirectly(String phoneNumber) async {
//   final result = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
//   return result;
// }

Future<bool> callWithWhatsApp(String phoneNumber) async {
  final formattedNumber = phoneNumber.replaceAll(RegExp(r'\s+|\+'), '');

  final uri = Uri.parse('https://wa.me/$formattedNumber');

  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> launchWhatsAppCall({
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

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    return true;
  } catch (_) {
    return false;
  }
}


Future<bool> isWhatsAppInstalled(String phoneNumber) async {
  final formattedNumber = phoneNumber.replaceAll(RegExp(r'\s+|\+'), '');

  final uri = Uri.parse('https://wa.me/$formattedNumber');
  return await canLaunchUrl(uri);
}

