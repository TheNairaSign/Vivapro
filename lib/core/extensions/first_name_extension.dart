extension FirstNameExtension on String {
  String get firstName {
    final [first, ..._] = trim().split(RegExp(r'\s+'));
    return first;
  }
}