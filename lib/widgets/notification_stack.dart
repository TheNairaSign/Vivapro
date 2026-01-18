import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef OnWidgetSizeChange = void Function(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    super.key,
    required this.onChange,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant MeasureSizeRenderObject renderObject) {
    renderObject.onChange = onChange;
  }
}

class NotificationStack extends StatefulWidget {
  final List<Widget> children;
  final double collapsedOffset;
  final double expandedSpacing;
  final Duration duration;
  final Curve curve;

  const NotificationStack({
    super.key,
    required this.children,
    this.collapsedOffset = 12.0,
    this.expandedSpacing = 12.0,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.fastOutSlowIn,
  });

  @override
  State<NotificationStack> createState() => _NotificationStackState();
}

class _NotificationStackState extends State<NotificationStack> {
  bool _isExpanded = false;
  final Map<int, double> _heights = {};

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  double _getTopOffset(int index) {
    if (!_isExpanded) {
      // Collapsed: items stack behind the first one with a slight downward offset
      // Actually, iOS stack shows the bottom cards peeking OUT from the bottom.
      // So index 0 is at top, index 1 is slightly below it, etc.
      return index * widget.collapsedOffset;
    } else {
      // Expanded: items are listed one after another
      double offset = 0;
      for (int i = 0; i < index; i++) {
        offset += (_heights[i] ?? 0) + widget.expandedSpacing;
      }
      return offset;
    }
  }

  double _getScale(int index) {
    if (!_isExpanded) {
      // Slightly scale down cards that are "behind"
      return 1.0 - (index * 0.05).clamp(0.0, 0.2);
    }
    return 1.0;
  }

  double _getOpacity(int index) {
    if (!_isExpanded && index >= 3) {
      return 0.0;
    }
    return 1.0;
  }

  double _getElevation(int index) {
    if (!_isExpanded) {
      // Top card has highest elevation
      return (3 - index).clamp(0, 4).toDouble();
    }
    // Expanded cards have subtle elevation
    return 2.0;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) return const SizedBox.shrink();

    // Calculate the total height for the container
    double totalHeight = 0;
    if (_isExpanded) {
      for (int i = 0; i < widget.children.length; i++) {
        totalHeight += (_heights[i] ?? 80.0);
        if (i < widget.children.length - 1) {
          totalHeight += widget.expandedSpacing;
        }
      }
    } else {
      // In collapsed mode, the height is the height of the first card 
      // plus the offsets of the subsequent visible cards
      final topCardHeight = _heights[0] ?? 80.0; // Fallback to a reasonable default
      totalHeight = topCardHeight + (2 * widget.collapsedOffset);
    }

    return GestureDetector(
      onTap: _toggleExpanded,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: widget.duration,
        curve: widget.curve,
        height: totalHeight,
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: Stack(
          clipBehavior: Clip.none,
          children: List.generate(widget.children.length, (index) {
            int visualIndex = widget.children.length - 1 - index;
            
            return AnimatedPositioned(
              key: ValueKey('card_$visualIndex'),
              duration: widget.duration,
              curve: widget.curve,
              top: _getTopOffset(visualIndex),
              left: 0,
              right: 0,
              child: AnimatedScale(
                duration: widget.duration,
                curve: widget.curve,
                scale: _getScale(visualIndex),
                alignment: Alignment.topCenter,
                child: AnimatedOpacity(
                  duration: widget.duration,
                  opacity: _getOpacity(visualIndex),
                  child: MeasureSize(
                    onChange: (size) {
                      if (_heights[visualIndex] != size.height) {
                        setState(() {
                          _heights[visualIndex] = size.height;
                        });
                      }
                    },
                    child: AnimatedPhysicalModel(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      elevation: _getElevation(visualIndex),
                      duration: widget.duration,
                      curve: widget.curve,
                      shadowColor: Colors.black.withValues(alpha: 0.1),
                      shape: BoxShape.rectangle,
                      child: widget.children[visualIndex],
                    ),
                  ),
                ),
              ),
            );
          }).reversed.toList(),
        ),
      ),
    );
  }
}
