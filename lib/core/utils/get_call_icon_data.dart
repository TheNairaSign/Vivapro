import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

IconData getCallIconData(CallType? type) {
  switch (type) {
    case CallType.incoming:
      return Icons.south_west;
    case CallType.outgoing:
      return Icons.north_east;
    case CallType.missed:
      return Icons.call_missed;
    case CallType.voiceMail:
      return Icons.voicemail;
    case CallType.rejected:
      return Icons.close;
    case CallType.blocked:
      return Icons.block;
    default:
      return Icons.call;
  }
}
