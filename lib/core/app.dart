import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/auth/presentation/bloc/auth_change/auth_change_bloc.dart';
import 'package:vivapro/auth/presentation/pages/auth_page.dart';
import 'package:vivapro/auth/repositories/auth_repository.dart';
import 'package:vivapro/core/theme/app_theme.dart';

class Vivapro extends ConsumerWidget {
  const Vivapro({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Vivapro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (create) => AuthStateChangeBloc(ref.read(firebaseAuthRepository)))
        ],
        child: const AuthPage(),
      ),
    );
  }
}
