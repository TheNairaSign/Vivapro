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

Future<bool> isWhatsAppInstalled(String phoneNumber) async {
  final formattedNumber = phoneNumber.replaceAll(RegExp(r'\s+|\+'), '');

  final uri = Uri.parse('https://wa.me/$formattedNumber');
  return await canLaunchUrl(uri);
}

