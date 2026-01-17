import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:vivapro/core/bootstrap.dart';
import 'package:vivapro/core/theme/app_theme.dart';
import 'package:vivapro/features/auth/presentation/bloc/auth_change/auth_change_bloc.dart';
import 'package:vivapro/features/auth/presentation/bloc/google_signin/google_sign_in_bloc.dart';
import 'package:vivapro/features/auth/presentation/bloc/signin/sign_in_bloc.dart';
import 'package:vivapro/features/auth/presentation/bloc/signup/sign_up_bloc.dart';
import 'package:vivapro/features/auth/presentation/pages/auth_checker.dart';
import 'package:vivapro/features/auth/repositories/firebase_auth_repository.dart';
import 'package:vivapro/features/auth/repositories/google_sign_in_repository.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_bloc.dart';
import 'package:vivapro/features/call_log/repositories/call_log_repository.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorites/frequency_container.dart';
import 'package:vivapro/features/contacts/repositories/contact_repository.dart';
import 'package:vivapro/features/messaging/presentation/bloc/chat/chat_bloc.dart';
import 'package:vivapro/features/messaging/presentation/bloc/message_bloc.dart';
import 'package:vivapro/features/messaging/repositories/chat_repository.dart';
import 'package:vivapro/features/messaging/repositories/message_repository.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_bloc.dart';
import 'package:vivapro/features/schedule_call/repositories/schedule_call_repository.dart';

class Vivapro extends ConsumerStatefulWidget {
  const Vivapro({super.key});

  @override
  ConsumerState<Vivapro> createState() => _VivaproState();
}

class _VivaproState extends ConsumerState<Vivapro> {
  @override
  void initState() {
    super.initState();
    applyModernStatusBarStyle(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddFavoritesProvider(),
      child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (create) => SignUpBloc(ref.read(firebaseAuthRepository))),
        BlocProvider(create: (create) => SignInBloc(ref.read(firebaseAuthRepository))),
        BlocProvider(create: (create) => AuthStateChangeBloc(ref.read(firebaseAuthRepository))),
        BlocProvider(create: (create) => GoogleSignInBloc(ref.read(googleSignInRepositoryProvider))),
        BlocProvider(create: (create) => CallLogBloc(
            ref.read(callLogRepository),
            ref.read(contactsRepository),
          ),
        ),
        BlocProvider(
          create: (create) => ChatBloc(
            ref.read(chatRepositoryProvider),
            ref.read(contactsRepository),
          ),
        ),
        BlocProvider(create: (create) => MessageBloc(ref.read(messageRepository))),
        BlocProvider(create: (create) => ScheduleCallBloc(repository: ref.read(scheduleCallRepositoryProvider))),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: MaterialApp(
          title: 'Vivapro',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const AuthChecker(),
        ),
      ),
      ),
    );
  }
}
