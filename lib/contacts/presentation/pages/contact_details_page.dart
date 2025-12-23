import 'package:cached_network_image/cached_network_image.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_bloc.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_state.dart';
import 'package:vivapro/contacts/repositories/favorite_repository.dart';
import 'package:vivapro/core/app_constants.dart';
import 'package:vivapro/core/theme/global_colors.dart';
import 'package:vivapro/core/utils/get_time_ago.dart';

class ContactDetailsPage extends ConsumerStatefulWidget {
  final Contact contact;
  const ContactDetailsPage(this.contact, {super.key});

  @override
  ConsumerState<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends ConsumerState<ContactDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Contact',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Edit functionality
            },
            child: const Text(
              'Edit',
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20),
          _buildProfileSection(isDark),
          const SizedBox(height: 30),
          _buildActionButtons(isDark),
          const SizedBox(height: 30),
          _buildRelationshipHealth(isDark),
          const SizedBox(height: 30),
          _buildSettingsAndReminders(isDark),
          const SizedBox(height: 30),
          _buildRecentHistory(isDark),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildProfileSection(bool isDark) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.lightBlue,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: widget.contact.photo != null
                    ? MemoryImage(widget.contact.photo!)
                    : const CachedNetworkImageProvider(
                        AppConstants.placeHolderProfileImage,
                      ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          widget.contact.displayName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'CLOSE FRIEND',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (widget.contact.phones.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.phone_android,
                      size: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Mobile',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Call action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Call ${widget.contact.displayName.split(' ').first}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryButton(
                icon: Ionicons.chatbubble_outline,
                label: 'Message',
                isDark: isDark,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSecondaryButton(
                icon: Ionicons.videocam_outline,
                label: 'Video',
                isDark: isDark,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: GlobalColors.containerColor(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: GlobalColors.boxShadow(context),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.lightBlue,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelationshipHealth(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Relationship Health',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: GlobalColors.containerColor(context),
            borderRadius: BorderRadius.circular(20),
            boxShadow: GlobalColors.boxShadow(context),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: _buildHealthCard(
                  icon: Ionicons.call_outline,
                  label: 'LAST CALL',
                  value: '2 days ago',
                  subtitle: 'Sunday, 4:20 PM',
                  iconColor: Colors.blue,
                  isDark: isDark,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: _buildHealthCard(
                  icon: Ionicons.calendar_outline,
                  label: 'AVG FREQ',
                  value: 'Weekly',
                  subtitle: 'Usually weekends',
                  iconColor: Colors.green,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthCard({
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
    required Color iconColor,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: iconColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsAndReminders(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings & Reminders',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: GlobalColors.containerColor(context),
            borderRadius: BorderRadius.circular(20),
            boxShadow: GlobalColors.boxShadow(context),
          ),
          child: Column(
            children: [
              _buildSettingTile(
                icon: Ionicons.notifications,
                iconColor: Colors.orange,
                title: 'Remind me to call',
                subtitle: 'Next: Sun 2:00 PM',
                isDark: isDark,
                hasSwitch: true,
                switchValue: true,
              ),
              Divider(
                height: 1,
                indent: 60,
                color: isDark ? Colors.grey[800] : Colors.grey[200],
              ),
              _buildSettingTile(
                icon: Ionicons.location,
                iconColor: Colors.blue,
                title: 'Live Location',
                subtitle: 'Off',
                isDark: isDark,
                hasSwitch: true,
                switchValue: false,
              ),
              Divider(
                height: 1,
                indent: 60,
                color: isDark ? Colors.grey[800] : Colors.grey[200],
              ),
              _buildSettingTile(
                icon: Ionicons.medical,
                iconColor: Colors.red,
                title: 'Emergency Bypass',
                subtitle: null,
                isDark: isDark,
                hasArrow: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required bool isDark,
    bool hasSwitch = false,
    bool switchValue = false,
    bool hasArrow = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (hasSwitch)
            Switch(
              value: switchValue,
              onChanged: (value) {},
              activeColor: Colors.lightBlue,
            ),
          if (hasArrow)
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
        ],
      ),
    );
  }

  Widget _buildRecentHistory(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<CallLogBloc, CallLogState>(
          builder: (context, state) {
            if (state is CallLogSuccess) {
              // Filter call logs for this contact
              final contactLogs = state.callLogEntries.where((log) {
                final contactPhones = widget.contact.phones.map((p) => p.number).toList();
                return contactPhones.any((phone) => 
                  log.number?.contains(phone.replaceAll(RegExp(r'[^\d]'), '')) ?? false
                );
              }).take(2).toList();

              if (contactLogs.isEmpty) {
                return _buildEmptyHistory(isDark);
              }

              return Container(
                decoration: BoxDecoration(
                  color: GlobalColors.containerColor(context),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: GlobalColors.boxShadow(context),
                ),
                child: Column(
                  children: contactLogs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final log = entry.value;
                    return Column(
                      children: [
                        _buildHistoryItem(log, isDark),
                        if (index < contactLogs.length - 1)
                          Divider(
                            height: 1,
                            indent: 60,
                            color: isDark ? Colors.grey[800] : Colors.grey[200],
                          ),
                      ],
                    );
                  }).toList(),
                ),
              );
            }
            return _buildEmptyHistory(isDark);
          },
        ),
      ],
    );
  }

  Widget _buildEmptyHistory(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: GlobalColors.containerColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: GlobalColors.boxShadow(context),
      ),
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(
              Ionicons.call_outline,
              size: 40,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No recent calls',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(dynamic log, bool isDark) {
    final isOutgoing = log.callType == CallType.outgoing;
    final isMissed = log.callType == CallType.missed;
    final date = DateTime.fromMillisecondsSinceEpoch(log.timestamp ?? 0);
    final timeAgo = formatTimeAgo(date);
    final duration = log.duration != null ? _formatDuration(log.duration!) : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isMissed
                  ? Colors.red.withValues(alpha: 0.15)
                  : Colors.green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isOutgoing ? Ionicons.arrow_up : Ionicons.arrow_down,
              color: isMissed ? Colors.red : Colors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOutgoing ? 'Outgoing Call' : isMissed ? 'Missed Call' : 'Incoming Call',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$timeAgo${duration.isNotEmpty ? ' • $duration' : ''}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    }
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }
}
