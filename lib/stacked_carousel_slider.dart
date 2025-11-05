library;

import 'package:flutter/widgets.dart';
import 'package:stacked_carousel_slider/stacked_cards.dart';

class StackedCarouselSlider extends StatelessWidget {
  ///List of widgets that you want to stack.
  final List<Widget> items;

  /// Height of the widget.
  final double height;

  /// Width of the widget.
  final double width;

  /// The number of layers (or "stack levels") used to stack widgets on top of each other.
  ///
  /// This value determines how many widgets can visually overlap within the stack.
  /// If the specified [stackLevels] exceeds `items.length - 2`, it will automatically
  /// default to `3`.
  ///
  /// Example:
  /// ```dart
  /// stackLevels = 2; // Two levels of stacked widgets
  /// `
  final int stackLevels;

  /// The spacing factor used to calculate the distance between stacked widgets.
  ///
  /// A higher value decreases the spacing between each widget in the stack.
  final double spaceIntervalsFactor;

  /// Whether the stacked widgets should automatically rotate when interacted with.
  /// 
  /// Defaults to [false]
  final bool autoRotate;

  /// The axis along which the stacked widgets can be scrolled.
  ///
  /// Typically [Axis.horizontal] or [Axis.vertical].
  ///
  /// Defaults to [Axis.horizontal]
  final Axis scrollDirection;

  /// Called when the visible (or active) card in the stack changes.
  final void Function(int)? onCardChange;

  /// Called during a drag gesture, providing the current [progress] and [direction].
  final void Function(double progress, double direction)? onDragUpdate;

  /// Called when a drag gesture ends.
  final VoidCallback? onDragEnd;

  const StackedCarouselSlider({
    super.key,
    required this.items,
    required this.height,
    required this.width,
    required this.stackLevels,
    required this.spaceIntervalsFactor,
    this.autoRotate = false,
    this.scrollDirection = Axis.horizontal,
    this.onCardChange,
    this.onDragUpdate,
    this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => StackedCards(
        items: items,
        itemHeight: height,
        itemWidth: width,
        autoRotate: autoRotate,
        scrollDirection: scrollDirection,
        totalHeight: constraints.maxHeight,
        totalWidth: constraints.maxWidth,
        spaceIntervalFactor: spaceIntervalsFactor,
        stackLevels: stackLevels >= items.length - 2 ? 3 : stackLevels,
        onCardChange: onCardChange,
        onDragUpdate: onDragUpdate,
        onDragEnd: onDragEnd,
      ),
    );
  }
}
