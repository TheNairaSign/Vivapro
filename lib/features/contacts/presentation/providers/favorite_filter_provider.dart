import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteFilterNotifier extends Notifier<String> {
  @override
  String build() {
    return 'All';
  }

  void setFilter(String filter) {
    state = filter;
  }
}

final favoriteFilterProvider = NotifierProvider<FavoriteFilterNotifier, String>(FavoriteFilterNotifier.new);
