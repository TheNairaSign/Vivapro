import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

extension CallTypeIcon on CallType {
  Widget get callIcon {
    IconData icon;
    Color color = Colors.grey;

    switch (this) {
      case CallType.incoming:
        icon = Icons.south_west;
        break;
      case CallType.outgoing:
        icon = Icons.north_east;
        break;
      case CallType.missed:
        icon = Icons.call_missed;
        color = Colors.red[400]!;
        break;
      case CallType.voiceMail:
        icon = Icons.voicemail;
        break;
      case CallType.rejected:
        icon = Icons.close;
        color = Colors.red[400]!;
        break;
      case CallType.blocked:
        icon = Icons.block;
        break;
      default:
        icon = Icons.help_outline;
    }

    return Icon(icon, size: 14, color: color);
  }

  String get value {
    switch (this) {
      case CallType.incoming:
        return 'Incoming';
      case CallType.outgoing:
        return 'Outgoing';
      case CallType.missed:
        return 'Missed';
      case CallType.voiceMail:
        return 'Voicemail';
      case CallType.rejected:
        return 'Rejected';
      case CallType.blocked:
        return 'Blocked';
      default:
        return 'Unknown';
    }
  }
}
