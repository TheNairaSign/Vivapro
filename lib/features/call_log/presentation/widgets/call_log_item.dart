import 'package:call_log/call_log.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vivapro/features/call_log/data/call_log_model.dart';
import 'package:vivapro/core/extensions/call_type_extention.dart';

class CallLogItem extends StatelessWidget {
  const CallLogItem({super.key, required this.entry});

  final CallLogModel entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final nameOrNumber = (entry.name != null && entry.name!.isNotEmpty)
        ? entry.name!
        : (entry.formattedNumber ?? entry.number ?? 'Unknown');

    final timeString = DateFormat(
      'h:mm a',
    ).format(DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0));
    final avatarChar = nameOrNumber.isNotEmpty
        ? nameOrNumber.characters.first.toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2C2C3E)
                        : const Color(0xFFF0F0F3),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    avatarChar,
                    style: TextStyle(
                      color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nameOrNumber,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildCallIcon(entry.callType),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${entry.callType?.value} • $timeString',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _getCallColor(entry.callType, isDark),
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Call Button (Optional, maybe just tap the card)
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2C2C3E)
                        : const Color(0xFFFFF9FA),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      // TODO: Implement call
                    },
                    icon: const Icon(EvaIcons.phoneCallOutline),
                    color: theme.colorScheme.primary,
                    iconSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCallIcon(CallType? type) {
    IconData icon;
    Color color = Colors.grey;

    switch (type) {
      case CallType.incoming:
        icon = EvaIcons.arrowDownwardOutline;
        color = Colors.blue;
        break;
      case CallType.outgoing:
        icon = EvaIcons.arrowUpwardOutline;
        color = Colors.green;
        break;
      case CallType.missed:
        icon = EvaIcons.phoneMissedOutline;
        color = Colors.redAccent;
        break;
      case CallType.rejected:
        icon = EvaIcons.closeCircleOutline;
        color = Colors.red;
        break;
      default:
        icon = EvaIcons.phoneOutline;
    }
    return Icon(icon, size: 14, color: color);
  }

  Color _getCallColor(CallType? type, bool isDark) {
    if (type == CallType.missed || type == CallType.rejected) {
      return Colors.redAccent;
    }
    return isDark ? Colors.grey[400]! : Colors.grey[600]!;
  }
}
