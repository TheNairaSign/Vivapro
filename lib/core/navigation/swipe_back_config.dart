/// Configuration for the swipe-back gesture behavior.
class SwipeBackConfig {
  /// The width of the edge area where the swipe gesture can be initiated.
  /// Default: 50.0 pixels from the left/right edge.
  final double edgeWidth;

  /// The minimum progress (0.0 to 1.0) required to commit the pop.
  /// Default: 0.3 (30% of screen width).
  final double popThreshold;

  /// The minimum velocity (pixels per second) to trigger a pop regardless of distance.
  /// Default: 800.0 pixels/second.
  final double velocityThreshold;

  /// The scale factor for the previous page at the start of the gesture.
  /// Default: 0.95 (5% smaller).
  final double previousPageStartScale;

  /// The opacity of the dim overlay on the previous page at the start.
  /// Default: 0.15 (15% dark).
  final double previousPageDimOpacity;

  /// Whether to show a shadow on the left edge of the current page.
  /// Default: true.
  final bool showShadow;

  /// The duration for the completion/cancellation animation.
  /// Default: 300 milliseconds.
  final Duration animationDuration;

  /// Whether the gesture is enabled.
  /// Default: true.
  final bool enabled;

  const SwipeBackConfig({
    this.edgeWidth = 50.0,
    this.popThreshold = 0.3,
    this.velocityThreshold = 800.0,
    this.previousPageStartScale = 0.95,
    this.previousPageDimOpacity = 0.15,
    this.showShadow = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.enabled = true,
  });

  /// Creates a copy with optional overrides.
  SwipeBackConfig copyWith({
    double? edgeWidth,
    double? popThreshold,
    double? velocityThreshold,
    double? previousPageStartScale,
    double? previousPageDimOpacity,
    bool? showShadow,
    Duration? animationDuration,
    bool? enabled,
  }) {
    return SwipeBackConfig(
      edgeWidth: edgeWidth ?? this.edgeWidth,
      popThreshold: popThreshold ?? this.popThreshold,
      velocityThreshold: velocityThreshold ?? this.velocityThreshold,
      previousPageStartScale: previousPageStartScale ?? this.previousPageStartScale,
      previousPageDimOpacity: previousPageDimOpacity ?? this.previousPageDimOpacity,
      showShadow: showShadow ?? this.showShadow,
      animationDuration: animationDuration ?? this.animationDuration,
      enabled: enabled ?? this.enabled,
    );
  }
}
