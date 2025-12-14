import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vivapro/call_log/data/call_log_model.dart';
import 'package:vivapro/core/extensions/call_type_extention.dart';

class CallLogItem extends StatelessWidget {
  const CallLogItem({
    super.key,
    required this.entry,
  });

  final CallLogModel entry;

  @override
  Widget build(BuildContext context) {
    final bool isMissed = entry.callType == CallType.missed;
    final nameOrNumber = (entry.name != null && entry.name!.isNotEmpty) 
        ? entry.name! 
        : (entry.formattedNumber ?? entry.number ?? 'Unknown');
    
    final timeString = DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0));

    return InkWell(
      onTap: () {
        // TODO: Implement call action
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey[200],
              backgroundImage: null,
              child: ((entry.name == null || entry.name!.isEmpty) && entry.formattedNumber == null)
                  ? const Icon(Icons.person, color: Colors.grey)
                  : Text(
                      nameOrNumber.isNotEmpty 
                          ? nameOrNumber.characters.first.toUpperCase() 
                          : '?',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                       entry.callType!.callIcon,
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${entry.callType?.value} • $timeString',
                          style: TextStyle(
                            fontSize: 13,
                            color: isMissed ? Colors.red[400] : Colors.grey[600],
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

            // Call Button
            IconButton(
              onPressed: () {
                // TODO: Implement call
              }, 
              icon: Icon(Icons.call_outlined, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}