extension FirstNameExtension on String {
  String get capitalizeFirst {
    final [first, ..._] = trim().split(RegExp(r'\s+'));
    return first;
  }
}
