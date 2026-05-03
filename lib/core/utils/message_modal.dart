import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/utils/initiate_message.dart';

void showMessageOptionsModal({
  required BuildContext context,
  required WidgetRef ref,
  required String phoneNumber,
  required String contactId,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.message, color: Colors.blue),
              title: const Text('SMS'),
              onTap: () async {
                Navigator.pop(context);
                await MessageOptions.sendSMS(phoneNumber: phoneNumber);
              },
            ),
            ListTile(
              leading: const Icon(Ionicons.logo_whatsapp, color: Colors.green),
              title: const Text('WhatsApp'),
              onTap: () async {
                Navigator.pop(context);
                await MessageOptions.sendWhatsApp(phoneNumber: phoneNumber);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}
