import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/auth/presentation/bloc/auth_change/auth_change_bloc.dart';
import 'package:vivapro/auth/presentation/bloc/google_signin/google_sign_in_bloc.dart';
import 'package:vivapro/auth/presentation/bloc/signin/sign_in_bloc.dart';
import 'package:vivapro/auth/presentation/bloc/signup/sign_up_bloc.dart';
import 'package:vivapro/auth/presentation/pages/auth_checker.dart';
import 'package:vivapro/auth/repositories/firebase_auth_repository.dart';
import 'package:vivapro/auth/repositories/google_sign_in_repository.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_bloc.dart';
import 'package:vivapro/call_log/repositories/call_log_repository.dart';
import 'package:vivapro/contacts/repositories/contact_repository.dart';
import 'package:vivapro/core/bootstrap.dart';
import 'package:vivapro/core/theme/app_theme.dart';
import 'package:vivapro/messaging/presentation/bloc/chat/chat_bloc.dart';
import 'package:vivapro/messaging/presentation/bloc/message_bloc.dart';
import 'package:vivapro/messaging/repositories/chat_repository.dart';
import 'package:vivapro/messaging/repositories/message_repository.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create) => SignUpBloc(ref.read(firebaseAuthRepository))),
        BlocProvider(create: (create) => SignInBloc(ref.read(firebaseAuthRepository))),
        BlocProvider(create: (create) => AuthStateChangeBloc(ref.read(firebaseAuthRepository))),
        BlocProvider(create: (create) => GoogleSignInBloc(ref.read(googleSignInRepositoryProvider))),
        BlocProvider(create: (create) => CallLogBloc(ref.read(callLogRepository))),
        BlocProvider(create: (create) => ChatBloc(ref.read(chatRepositoryProvider), ref.read(contactsRepository))),
        BlocProvider(create: (create) => MessageBloc(ref.read(messageRepository))),
      ],
      child: DynamicColorBuilder(
        builder: (lightColorScheme, darkColorScheme) {
          return MaterialApp(
            title: 'Vivapro',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme.copyWith(
              colorScheme: lightColorScheme,
              brightness: Brightness.light,
            ),
            darkTheme: AppTheme.darkTheme.copyWith(
              colorScheme: darkColorScheme,
              brightness: Brightness.dark,
            ),
            home: const AuthChecker(),
          );
        }
      ),
    );
  }
}
