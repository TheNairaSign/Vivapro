# Swipe-Back Navigation for Flutter

A reusable, production-ready implementation of Android-style predictive back navigation with bidirectional edge swipes.

## ✨ Features

- 🎯 **Bidirectional Edge Swipe**: Swipe from **left OR right** edge to peek at previous page
- 👁️ **Predictive Back Preview**: See the previous page before committing the navigation
- ⚡ **Velocity-Based Completion**: Fast swipes complete even with short distance
- 🎨 **Customizable Animations**: Configure thresholds, scales, shadows, and more
- 📱 **Android Predictive Back Style**: Native Android 13+ gesture feel
- 🚀 **Zero Dependencies**: Pure Flutter implementation
- 🎭 **Smooth Performance**: No frame drops, GPU-accelerated animations
- 🔧 **Easy Integration**: Drop-in replacement for standard navigation

## 🚀 Quick Start

### Basic Usage

```dart
import 'package:vivapro/core/navigation/swipe_back_navigation.dart';

// Push a page with swipe-back support
Navigator.of(context).pushSwipeBack(
  builder: (context) => DetailPage(),
);
```

### Custom Configuration

```dart
Navigator.of(context).pushSwipeBack(
  builder: (context) => DetailPage(),
  config: SwipeBackConfig(
    popThreshold: 0.4,        // Require 40% swipe to commit
    velocityThreshold: 1000,  // Higher velocity needed
    edgeWidth: 30,            // Wider edge detection area
    showShadow: true,         // Show shadow on current page
  ),
);
```

### App-Wide Configuration

```dart
import 'dart:io';

MaterialApp(
  builder: (context, child) {
    return SwipeBackNavigator(
      config: SwipeBackConfig(
        popThreshold: 0.35,
        enabled: Platform.isIOS, // iOS only
      ),
      child: child!,
    );
  },
  home: HomePage(),
);
```

## 📋 Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `edgeWidth` | `double` | `20.0` | Width of edge area where swipe starts (px) |
| `popThreshold` | `double` | `0.3` | Minimum progress to commit pop (0.0-1.0) |
| `velocityThreshold` | `double` | `800.0` | Minimum velocity to force pop (px/s) |
| `previousPageStartScale` | `double` | `0.95` | Scale of previous page at start |
| `previousPageDimOpacity` | `double` | `0.15` | Dim overlay on previous page |
| `showShadow` | `bool` | `true` | Show shadow on current page edge |
| `animationDuration` | `Duration` | `300ms` | Completion animation duration |
| `enabled` | `bool` | `true` | Enable/disable the gesture |

## 🎯 Use Cases

### 1. Standard Page Navigation

```dart
ElevatedButton(
  onPressed: () {
    Navigator.of(context).pushSwipeBack(
      builder: (context) => ProfilePage(),
    );
  },
  child: Text('View Profile'),
);
```

### 2. Named Routes

```dart
// In your route generator
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/profile':
      return SwipeBackPageRoute(
        builder: (context) => ProfilePage(),
        settings: settings,
      );
    default:
      return MaterialPageRoute(
        builder: (context) => NotFoundPage(),
      );
  }
}

// Navigate
Navigator.pushNamed(context, '/profile');
```

### 3. Platform-Specific Behavior

```dart
import 'dart:io';

final config = SwipeBackConfig(
  enabled: Platform.isIOS || Platform.isMacOS,
  popThreshold: Platform.isIOS ? 0.3 : 0.4,
);

Navigator.of(context).pushSwipeBack(
  builder: (context) => DetailPage(),
  config: config,
);
```

### 4. Conditional Swipe-Back

```dart
// Disable swipe-back for forms or critical pages
Navigator.of(context).pushSwipeBack(
  builder: (context) => CheckoutPage(),
  config: SwipeBackConfig(
    enabled: false, // No accidental back navigation
  ),
);
```

## 🏗️ Architecture

```
core/navigation/
├── swipe_back_config.dart       # Configuration class
├── swipe_back_page_route.dart   # Custom PageRoute implementation
├── swipe_back_navigator.dart    # Helper extensions and widgets
└── swipe_back_navigation.dart   # Library exports and docs
```

### Component Responsibilities

1. **SwipeBackConfig**: Immutable configuration with sensible defaults
2. **SwipeBackPageRoute**: Custom route with gesture handling and animations
3. **SwipeBackNavigator**: Convenience extensions and inherited widget for config

## 🔄 Migration from Standard Navigation

### Before
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => DetailPage()),
);
```

### After
```dart
Navigator.of(context).pushSwipeBack(
  builder: (context) => DetailPage(),
);
```

## 🎨 Visual Behavior

During the swipe gesture:

1. **Current Page**: 
   - Swipe from **left edge** → Page moves right, revealing previous page
   - Swipe from **right edge** → Page moves left, revealing previous page
2. **Previous Page**: 
   - Scales from 95% to 100%
   - Dim overlay fades from 15% to 0%
3. **Shadow**: Soft shadow appears on the edge of current page (direction depends on swipe side)
4. **Completion**: 
   - If progress ≥ 30% OR velocity > 800px/s → Pop completes
   - Otherwise → Smoothly animates back to original position

**Android Predictive Back Style**: Just like Android 13+, you can swipe from either edge to peek at the previous screen before deciding to commit the navigation.

## 🚀 Integration into Other Apps

1. **Copy the navigation folder**:
   ```
   cp -r lib/core/navigation/ your_app/lib/core/navigation/
   ```

2. **Import in your app**:
   ```dart
   import 'package:your_app/core/navigation/swipe_back_navigation.dart';
   ```

3. **Start using**:
   ```dart
   Navigator.of(context).pushSwipeBack(
     builder: (context) => YourPage(),
   );
   ```

No additional setup or dependencies required!

## ⚡ Performance

- **Percent-driven animations**: Gesture directly controls animation progress
- **Minimal rebuilds**: Only `AnimatedBuilder` rebuilds during drag
- **GPU acceleration**: Uses `Transform` and `Opacity` for smooth 60fps
- **Edge detection**: Gesture only activates within configured edge width
- **No blocking**: UI remains fully interactive during gesture

## 🎯 Best Practices

1. **Use for detail pages**: Great for drill-down navigation
2. **Disable for forms**: Prevent accidental data loss
3. **Platform-specific**: Consider enabling only on iOS for familiar UX
4. **Consistent config**: Use app-wide config for uniform behavior
5. **Test on devices**: Gesture feel varies between simulator and real devices

## 📝 License

This implementation is part of the Vivapro project and can be freely used in other Flutter applications.

## 🤝 Contributing

Improvements and bug fixes are welcome! This is a standalone feature designed for easy reuse.
