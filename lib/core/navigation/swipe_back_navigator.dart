import 'package:flutter/material.dart';
import 'swipe_back_config.dart';
import 'swipe_back_page_route.dart';

/// Extension methods for easy navigation with swipe-back support.
extension SwipeBackNavigation on NavigatorState {
  /// Push a new route with swipe-back gesture support.
  /// 
  /// Example:
  /// ```dart
  /// Navigator.of(context).pushSwipeBack(
  ///   builder: (context) => MyPage(),
  ///   config: SwipeBackConfig(popThreshold: 0.4),
  /// );
  /// ```
  Future<T?> pushSwipeBack<T extends Object?>({
    required WidgetBuilder builder,
    SwipeBackConfig config = const SwipeBackConfig(),
    RouteSettings? settings,
  }) {
    return push<T>(
      SwipeBackPageRoute<T>(
        builder: builder,
        config: config,
        settings: settings,
      ),
    );
  }

  /// Push a named route with swipe-back gesture support.
  /// 
  /// Note: This requires the route to be registered with [SwipeBackPageRoute]
  /// in your route generator.
  Future<T?> pushNamedSwipeBack<T extends Object?>(
    String routeName, {
    Object? arguments,
    SwipeBackConfig config = const SwipeBackConfig(),
  }) {
    return pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }
}

/// A convenience widget that wraps Navigator.push with SwipeBackPageRoute.
/// 
/// This is useful for declarative navigation or when you want to
/// configure swipe-back behavior at the widget level.
/// 
/// Example:
/// ```dart
/// SwipeBackNavigator(
///   config: SwipeBackConfig(popThreshold: 0.4),
///   child: MaterialApp(
///     // your app
///   ),
/// );
/// ```
class SwipeBackNavigator extends StatelessWidget {
  final Widget child;
  final SwipeBackConfig config;

  const SwipeBackNavigator({
    super.key,
    required this.child,
    this.config = const SwipeBackConfig(),
  });

  @override
  Widget build(BuildContext context) {
    return _SwipeBackConfigProvider(
      config: config,
      child: child,
    );
  }
}

/// Internal widget to provide SwipeBackConfig down the widget tree.
class _SwipeBackConfigProvider extends InheritedWidget {
  final SwipeBackConfig config;

  const _SwipeBackConfigProvider({
    required this.config,
    required super.child,
  });

  static SwipeBackConfig? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_SwipeBackConfigProvider>()
        ?.config;
  }

  @override
  bool updateShouldNotify(_SwipeBackConfigProvider oldWidget) {
    return config != oldWidget.config;
  }
}

/// Helper function to get the current SwipeBackConfig from context.
SwipeBackConfig getSwipeBackConfig(BuildContext context) {
  return _SwipeBackConfigProvider.of(context) ?? const SwipeBackConfig();
}
