import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/app.dart';
import 'package:vivapro/core/bootstrap.dart';

void main(List<String> args) async {
  await bootstrap();
  runApp(ProviderScope(child: const Vivapro()));
}
