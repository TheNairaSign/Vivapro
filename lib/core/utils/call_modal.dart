import 'dart:io';
import 'package:vivapro/core/services/pending_call_service.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vivapro/core/utils/initiate_call.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/services/interaction_tracker.dart';
import 'package:vivapro/core/utils/whatsapp_launcher.dart';

void showCallOptionsModal({
  required BuildContext context, 
  required WidgetRef ref, 
  required String phoneNumber,
  required String contactId,
}) {
  final interactionTracker = ref.read(interactionTrackerProvider);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
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
              leading: const Icon(Icons.phone, color: Colors.blue),
              title: const Text('Phone'),
              onTap: () async {
                Navigator.pop(context);
                final activityId = await interactionTracker.recordInteraction(contactId);
                await PendingCallService().setPendingCall(contactId, activityId: activityId);
                await CallOptions.callWithPhone(phoneNumber);
              },
            ),

            ListTile(
              leading: Icon(Ionicons.logo_whatsapp, color: Colors.green),
              title: const Text('WhatsApp'),
              onTap: () async {
                Navigator.pop(context);
                final exists = await CallOptions.isWhatsAppInstalled(phoneNumber);
                if (exists) {
                  final whatsapp = await WhatsAppLauncher.launch(phoneNumber: phoneNumber, action: WhatsAppAction.voiceCall);
                  if (whatsapp) {
                    final activityId = await interactionTracker.recordInteraction(contactId);
                    await PendingCallService().setPendingCall(contactId, activityId: activityId);
                  }
                }
              },
            ),

            if (Platform.isIOS)
              ListTile(
                leading: const Icon(Icons.video_camera_front, color: Colors.indigo),
                title: const Text('FaceTime'),
                onTap: () async {
                  Navigator.pop(context);
                  final success = await CallOptions.launchFaceTime(phoneNumber: phoneNumber);
                  if (success) {
                    final activityId = await interactionTracker.recordInteraction(contactId);
                    await PendingCallService().setPendingCall(contactId, activityId: activityId);
                  }
                },
              ),

            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}
