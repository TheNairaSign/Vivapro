import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/utils/initiate_call.dart';
import 'package:vivapro/core/utils/whatsapp_launcher.dart';

void showVideoOptionsModal({
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
              leading: const Icon(Ionicons.logo_whatsapp, color: Colors.green),
              title: const Text('WhatsApp Video'),
              onTap: () async {
                Navigator.pop(context);
                await WhatsAppLauncher.launch(
                  phoneNumber: phoneNumber,
                  action: WhatsAppAction.videoCall,
                );
              },
            ),
            if (Platform.isIOS)
              ListTile(
                leading: const Icon(Icons.video_camera_front, color: Colors.indigo),
                title: const Text('FaceTime Video'),
                onTap: () async {
                  Navigator.pop(context);
                  await CallOptions.launchFaceTime(
                    phoneNumber: phoneNumber,
                    video: true,
                  );
                },
              ),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}
