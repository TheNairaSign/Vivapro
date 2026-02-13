import 'package:vivapro/core/services/navigator_service.dart';
import 'package:vivapro/core/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vivapro/core/theme/app_theme.dart';
import 'package:vivapro/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:vivapro/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:vivapro/features/contacts/data/add_favorites_provider.dart';
import 'package:vivapro/pages/navigation/navigation_page.dart';
import 'package:vivapro/features/contacts/repositories/contact_repository.dart';
import 'package:vivapro/features/messaging/presentation/bloc/chat/chat_bloc.dart';
import 'package:vivapro/features/messaging/presentation/bloc/message_bloc.dart';
import 'package:vivapro/features/messaging/repositories/chat_repository.dart';
import 'package:vivapro/features/messaging/repositories/message_repository.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_manager.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_bloc.dart';
import 'package:vivapro/core/services/foreground_schedule_monitor.dart';

import 'package:vivapro/core/services/notification_handler.dart';

import 'package:vivapro/core/services/lifecycle_manager.dart';
import 'package:vivapro/features/backup/bloc/backup_bloc.dart';
import 'package:vivapro/features/backup/data/backup_worker.dart';
import 'package:vivapro/features/events/dom/calendar_event_manager.dart';
import 'package:vivapro/features/events/presentation/bloc/calendar_event_bloc.dart';
import 'package:vivapro/pages/onboarding/start_page.dart';


class Loop extends ConsumerStatefulWidget {
  const Loop({super.key});

  @override
  ConsumerState<Loop> createState() => _LoopState();
}

class _LoopState extends ConsumerState<Loop> {

  @override
  void initState() {
    super.initState();
    // applyModernStatusBarStyle(context);
    
    // Listen to notifications and schedules
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationHandler(ref).listenToNotifications();
      ref.read(foregroundScheduleMonitorProvider).start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddFavoritesProvider(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (create) => ActivityBloc(ref.read(activityRepositoryProvider))),
          BlocProvider(
            create: (create) => ChatBloc(
              ref.read(chatRepositoryProvider),
              ref.read(contactsRepository),
            ),
          ),
          BlocProvider(create: (create) => MessageBloc(ref.read(messageRepository))),
          BlocProvider(create: (create) => ScheduleCallBloc(manager: ref.read(scheduleCallManagerProvider))),
          BlocProvider(create: (create) => CalendarEventBloc(manager: ref.read(calendarEventManagerProvider))),
          BlocProvider(create: (create) => BackupBloc(backupWorker: ref.read(backupWorkerProvider))),
        ],

        child: LifecycleManager(
          child: Builder(
            builder: (context) {
              final hasCompletedOnboarding = ref.watch(onboardingProvider);
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
                  systemNavigationBarIconBrightness: Brightness.dark,
                ),
                child: MaterialApp(
                  navigatorKey: navigatorKey,
                  title: 'Loop',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  home: hasCompletedOnboarding == null
                      ? Scaffold(
                          body: Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Theme.of(context).colorScheme.primary,
                              size: 50,
                            ),
                          ),
                        )
                      : (hasCompletedOnboarding ? const NavigationPage() : const StartPage()),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
