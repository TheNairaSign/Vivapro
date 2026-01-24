import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'swipe_back_config.dart';

/// A custom page route that supports interactive swipe-back gestures.
/// 
/// This route reveals the previous page underneath during the swipe gesture,
/// supporting both left and right edge swipes (Android predictive back style).
class SwipeBackPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  final SwipeBackConfig config;

  SwipeBackPageRoute({
    required this.builder,
    this.config = const SwipeBackConfig(),
    super.settings,
  }) {
    developer.log('SwipeBackPageRoute created with config: enabled=${config.enabled}, threshold=${config.popThreshold}, edgeWidth=${config.edgeWidth}');
  }

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => config.animationDuration;

  @override
  bool get opaque {
    developer.log('SwipeBackPageRoute.opaque called, returning false');
    return false;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    developer.log('SwipeBackPageRoute.buildPage called');
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    developer.log('SwipeBackPageRoute.buildTransitions called');
    return _SwipeBackTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      config: config,
      onPopInvoked: () {
        developer.log('SwipeBackPageRoute: Pop invoked!');
        navigator?.pop();
      },
      child: child,
    );
  }
}

/// The transition widget that handles the swipe gesture and animations.
class _SwipeBackTransition extends StatefulWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final SwipeBackConfig config;
  final VoidCallback onPopInvoked;
  final Widget child;

  const _SwipeBackTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.config,
    required this.onPopInvoked,
    required this.child,
  });

  @override
  State<_SwipeBackTransition> createState() => _SwipeBackTransitionState();
}

class _SwipeBackTransitionState extends State<_SwipeBackTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragProgress = 0.0;
  bool _isDragging = false;
  double _screenWidth = 0.0;
  bool _isRightEdge = false; // Track which edge the swipe started from

  @override
  void initState() {
    super.initState();
    developer.log('_SwipeBackTransition.initState: Creating animation controller');
    _controller = AnimationController(
      vsync: this,
      duration: widget.config.animationDuration,
    );
  }

  @override
  void dispose() {
    developer.log('_SwipeBackTransition.dispose: Cleaning up');
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    if (!widget.config.enabled) {
      developer.log('SwipeBack: Drag start ignored - gesture disabled');
      return;
    }
    
    final startX = details.localPosition.dx;
    final isLeftEdge = startX <= widget.config.edgeWidth;
    final isRightEdge = startX >= (_screenWidth - widget.config.edgeWidth);
    
    developer.log('SwipeBack: Drag start at x=$startX, screenWidth=$_screenWidth, leftEdge=$isLeftEdge, rightEdge=$isRightEdge, edgeWidth=${widget.config.edgeWidth}');
    
    // Start drag if within either edge width
    if (isLeftEdge || isRightEdge) {
      developer.log('SwipeBack: ✅ Starting drag from ${isRightEdge ? "RIGHT" : "LEFT"} edge');
      setState(() {
        _isDragging = true;
        _isRightEdge = isRightEdge;
      });
    } else {
      developer.log('SwipeBack: ❌ Drag start outside edge zones');
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging || !widget.config.enabled) return;

    setState(() {
      if (_isRightEdge) {
        // Right edge: swipe left to go back
        // Progress increases as we move left (decreasing X)
        final distanceFromRight = _screenWidth - details.localPosition.dx;
        _dragProgress = (distanceFromRight / _screenWidth).clamp(0.0, 1.0);
      } else {
        // Left edge: swipe right to go back
        // Progress increases as we move right (increasing X)
        _dragProgress = (details.localPosition.dx / _screenWidth).clamp(0.0, 1.0);
      }
      _controller.value = _dragProgress;
      
      if (_dragProgress > 0.1) { // Only log significant progress
        developer.log('SwipeBack: Drag update - progress=${_dragProgress.toStringAsFixed(2)}');
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isDragging || !widget.config.enabled) return;

    final velocity = details.primaryVelocity ?? 0.0;
    
    // For right edge, negative velocity means swiping left (back)
    // For left edge, positive velocity means swiping right (back)
    final effectiveVelocity = _isRightEdge ? -velocity : velocity;
    
    final shouldPop = _dragProgress >= widget.config.popThreshold ||
        effectiveVelocity > widget.config.velocityThreshold;

    developer.log('SwipeBack: Drag end - progress=${_dragProgress.toStringAsFixed(2)}, velocity=${effectiveVelocity.toStringAsFixed(0)}, threshold=${widget.config.popThreshold}, shouldPop=$shouldPop');

    if (shouldPop) {
      developer.log('SwipeBack: ✅ Committing pop (progress >= ${widget.config.popThreshold} OR velocity >= ${widget.config.velocityThreshold})');
      _controller.forward().then((_) {
        widget.onPopInvoked();
      });
    } else {
      developer.log('SwipeBack: ❌ Cancelling - animating back to origin');
      _controller.reverse();
    }

    setState(() {
      _isDragging = false;
    });
  }

  void _handleDragCancel() {
    if (!_isDragging) return;

    developer.log('SwipeBack: Drag cancelled by system');
    _controller.reverse();
    setState(() {
      _isDragging = false;
      _dragProgress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    developer.log('_SwipeBackTransition.build: screenWidth=$_screenWidth, enabled=${widget.config.enabled}, edgeWidth=${widget.config.edgeWidth}');

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        
        // Calculate translation based on which edge was swiped
        final translationX = _isRightEdge 
            ? -progress * _screenWidth  // Right edge: move left
            : progress * _screenWidth;   // Left edge: move right
        
        return Stack(
          fit: StackFit.expand,
          children: [
            // Previous page effects (scale and dim)
            Positioned.fill(
              child: Transform.scale(
                scale: widget.config.previousPageStartScale +
                    (1.0 - widget.config.previousPageStartScale) * progress,
                child: Container(
                  color: Colors.black.withValues(alpha:
                    widget.config.previousPageDimOpacity * (1.0 - progress),
                  ),
                ),
              ),
            ),
            
            // Current page with translation and shadow
            Transform.translate(
              offset: Offset(translationX, 0),
              child: Container(
                decoration: widget.config.showShadow
                    ? BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3 * progress),
                            blurRadius: 10,
                            offset: Offset(_isRightEdge ? 5 : -5, 0),
                          ),
                        ],
                      )
                    : BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                child: child,
              ),
            ),
            
            // Left edge gesture detector
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: widget.config.edgeWidth,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragStart: _handleDragStart,
                onHorizontalDragUpdate: _handleDragUpdate,
                onHorizontalDragEnd: _handleDragEnd,
                onHorizontalDragCancel: _handleDragCancel,
                child: Container(
                  color: Colors.transparent,
                  // Debug: Uncomment to see the edge zone
                  // color: Colors.red.withOpacity(0.1),
                ),
              ),
            ),
            
            // Right edge gesture detector
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: widget.config.edgeWidth,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragStart: _handleDragStart,
                onHorizontalDragUpdate: _handleDragUpdate,
                onHorizontalDragEnd: _handleDragEnd,
                onHorizontalDragCancel: _handleDragCancel,
                child: Container(
                  color: Colors.transparent,
                  // Debug: Uncomment to see the edge zone
                  // color: Colors.blue.withOpacity(0.1),
                ),
              ),
            ),
          ],
        );
      },
      child: widget.child,
    );
  }
}
