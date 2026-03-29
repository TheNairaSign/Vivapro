import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivapro/core/services/interaction_tracker.dart';
import 'package:vivapro/features/call_reminder/presentation/providers/call_reminder_provider.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorite_avatar.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_manager.dart';
import 'package:vivapro/features/schedule_call/presentation/widgets/reschedule_modal.dart';

class CallReminderBanner extends ConsumerStatefulWidget {
  const CallReminderBanner({super.key});

  @override
  ConsumerState<CallReminderBanner> createState() => _CallReminderBannerState();
}

class _CallReminderBannerState extends ConsumerState<CallReminderBanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(callReminderBannerProvider);
    final call = state.activeCall;

    if (call == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MainCard(
                    call: call,
                    onCallNow: () async {
                      final phoneNumber = call.contact.phones.isNotEmpty ? call.contact.phones.first.number : null;
                      if (phoneNumber != null && call.contact.id != null) {
                        final interactionTracker = ref.read(interactionTrackerProvider);
                        await interactionTracker.recordInteraction(call.contact.id!);
                        await ref.read(scheduleCallManagerProvider).deleteSchedule(call.id);
                        final uri = Uri(scheme: 'tel', path: phoneNumber);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                        ref.read(callReminderBannerProvider.notifier).dismiss();
                      }
                    },
                    onLater: () async {
                      final result = await showModalBottomSheet<bool>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => RescheduleModal(scheduleCall: call),
                      );
                      if (result == true) {
                        ref.read(callReminderBannerProvider.notifier).dismiss();
                      }
                    },
                    onDismiss: () => ref.read(callReminderBannerProvider.notifier).dismiss(),
                  ),
                  _FooterSection(shownAt: state.shownAt ?? DateTime.now()),
                ],
              ),
              
              // Minimal bottom progress line
              // Positioned(
              //   bottom: 0,
              //   left: 0,
              //   right: 0,
              //   child: TweenAnimationBuilder<double>(
              //     duration: const Duration(minutes: 2),
              //     tween: Tween(begin: 1.0, end: 0.0),
              //     builder: (context, value, child) {
              //       return Container(
              //         height: 3,
              //         alignment: Alignment.centerLeft,
              //         child: FractionallySizedBox(
              //           widthFactor: value,
              //           child: Container(
              //             decoration: BoxDecoration(
              //               color: Colors.white.withValues(alpha: 0.6),
              //               borderRadius: const BorderRadius.only(
              //                 topRight: Radius.circular(2),
              //                 bottomRight: Radius.circular(2),
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainCard extends StatelessWidget {
  final ScheduleCall call;
  final VoidCallback onCallNow;
  final VoidCallback onLater;
  final VoidCallback onDismiss;

  const _MainCard({
    required this.call,
    required this.onCallNow,
    required this.onLater,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _HeaderRow(onDismiss: onDismiss, call: call),
          const SizedBox(height: 15),
          _ProfileSection(call: call),
          const SizedBox(height: 20),
          _ActionButtons(onCallNow: onCallNow, onLater: onLater),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final VoidCallback onDismiss;
  final ScheduleCall call;

  const _HeaderRow({required this.onDismiss, required this.call});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text("Call Reminder", style: textStyle),
          ],
        ),
        InkWell(
          onTap: onDismiss,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 14, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  DateFormat('h:mm a').format(
                    DateTime(
                      call.date.year,
                      call.date.month,
                      call.date.day,
                      call.time.hour,
                      call.time.minute,
                    ),
                  ),
                  style: textStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final dynamic call;

  const _ProfileSection({required this.call});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        FavoriteAvatar(contact: call.contact, radius: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                call.contact.displayName,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                call.note.isNotEmpty ? call.note : "Reminder",
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onCallNow;
  final VoidCallback onLater;

  const _ActionButtons({required this.onCallNow, required this.onLater});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.phone_rounded,
            label: "Call Now",
            onPressed: onCallNow,
            isPrimary: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.calendar_today_outlined,
            label: "Reschedule",
            onPressed: onLater,
            isPrimary: false,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
      ),
      icon: Icon(icon, size: 18),
      label: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _FooterSection extends StatefulWidget {
  final DateTime shownAt;
  const _FooterSection({required this.shownAt});

  @override
  State<_FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<_FooterSection> {
  late Timer _timer;
  late Duration _remaining;
  final Duration _totalDuration = const Duration(minutes: 2);

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _updateRemaining();
        });
      }
    });
  }

  void _updateRemaining() {
    final elapsed = DateTime.now().difference(widget.shownAt);
    _remaining = _totalDuration - elapsed;
    if (_remaining.isNegative) {
      _remaining = Duration.zero;
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer_outlined, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            "Banner will disappear in ${_formatDuration(_remaining)}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
