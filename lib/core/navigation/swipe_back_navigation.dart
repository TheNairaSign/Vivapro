/// A reusable, configurable implementation of Telegram-style interactive
/// swipe-back navigation for Flutter.
/// 
/// ## Features
/// - Interactive edge-swipe gesture that reveals the previous page
/// - Configurable thresholds for pop completion
/// - Velocity-based gesture completion
/// - Smooth animations with no frame drops
/// - Platform-aware (can be enabled/disabled per platform)
/// - Zero external dependencies
/// 
/// ## Quick Start
/// 
/// ### Basic Usage
/// ```dart
/// // Push a page with swipe-back support
/// Navigator.of(context).pushSwipeBack(
///   builder: (context) => MyDetailPage(),
/// );
/// ```
/// 
/// ### Custom Configuration
/// ```dart
/// Navigator.of(context).pushSwipeBack(
///   builder: (context) => MyDetailPage(),
///   config: SwipeBackConfig(
///     popThreshold: 0.4,        // Require 40% swipe to commit
///     velocityThreshold: 1000,  // Higher velocity threshold
///     edgeWidth: 30,            // Wider edge detection
///   ),
/// );
/// ```
/// 
/// ### App-Wide Configuration
/// ```dart
/// MaterialApp(
///   builder: (context, child) {
///     return SwipeBackNavigator(
///       config: SwipeBackConfig(
///         popThreshold: 0.35,
///         enabled: Platform.isIOS, // Only on iOS
///       ),
///       child: child!,
///     );
///   },
///   // ...
/// );
/// ```
/// 
/// ### Custom Route Generator
/// ```dart
/// MaterialApp(
///   onGenerateRoute: (settings) {
///     return SwipeBackPageRoute(
///       builder: (context) => getPageForRoute(settings.name),
///       config: SwipeBackConfig(/* your config */),
///       settings: settings,
///     );
///   },
/// );
/// ```
/// 
/// ## Configuration Options
/// 
/// All configuration is done through the `SwipeBackConfig` class:
/// 
/// - `edgeWidth`: Width of the edge area where swipe can start (default: 20px)
/// - `popThreshold`: Minimum progress to commit pop (default: 0.3 = 30%)
/// - `velocityThreshold`: Minimum velocity to force pop (default: 800 px/s)
/// - `previousPageStartScale`: Scale of previous page at start (default: 0.95)
/// - `previousPageDimOpacity`: Dim overlay opacity on previous page (default: 0.15)
/// - `showShadow`: Whether to show shadow on current page (default: true)
/// - `animationDuration`: Duration for completion animation (default: 300ms)
/// - `enabled`: Whether the gesture is enabled (default: true)
/// 
/// ## Architecture
/// 
/// The implementation consists of three main components:
/// 
/// 1. **SwipeBackConfig**: Immutable configuration class
/// 2. **SwipeBackPageRoute**: Custom PageRoute that handles the transition
/// 3. **SwipeBackNavigator**: Helper extensions and widgets for easy integration
/// 
/// ## Integration into Other Apps
/// 
/// To use this in another Flutter app:
/// 
/// 1. Copy the `core/navigation/` folder to your project
/// 2. Import the navigator helper:
///    ```dart
///    import 'package:your_app/core/navigation/swipe_back_navigator.dart';
///    ```
/// 3. Use the extension methods or wrap your app with `SwipeBackNavigator`
/// 
/// No additional dependencies or setup required!
/// 
/// ## Performance Notes
/// 
/// - Uses a single `AnimationController` for smooth, percent-driven animations
/// - No unnecessary rebuilds during drag (only AnimatedBuilder rebuilds)
/// - Gesture detection is optimized to only activate within edge area
/// - All animations are GPU-accelerated (Transform and Opacity)
/// 
/// ## Platform Considerations
/// 
/// By default, the gesture is enabled on all platforms. To make it iOS-only:
/// 
/// ```dart
/// import 'dart:io';
/// 
/// SwipeBackConfig(
///   enabled: Platform.isIOS,
/// )
/// ```
library swipe_back_navigation;

export 'swipe_back_config.dart';
export 'swipe_back_page_route.dart';
export 'swipe_back_navigator.dart';
