import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stacked_carousel_slider/animated_stacked_carousel.dart';

class StackedCards extends StatefulWidget {
  final List<Widget> items;
  final double itemHeight;
  final double itemWidth;
  final double totalHeight;
  final double totalWidth;
  final double spaceIntervalFactor;
  final int stackLevels;
  final bool autoRotate;
  final Axis scrollDirection;
  final void Function(int)? onCardChange;
  final void Function(double progress, double direction)? onDragUpdate;
  final VoidCallback? onDragEnd;

  const StackedCards({
    super.key,
    required this.items,
    required this.itemHeight,
    required this.itemWidth,
    required this.totalHeight,
    required this.totalWidth,
    required this.spaceIntervalFactor,
    required this.stackLevels,
    required this.autoRotate,
    required this.scrollDirection,
    this.onCardChange,
    this.onDragUpdate,
    this.onDragEnd,
  });

  @override
  State<StackedCards> createState() => _StackedCardsState();
}

class _StackedCardsState extends State<StackedCards>
    with SingleTickerProviderStateMixin {
  final _panThreshold = 100; //The smooth of dragging amount
  int _selectedIndex = 0;
  double _offset = 0;
  double _spaceIntervals = 0;

  final List<List<Widget>> _stackedItems = [];

  bool _isAnimating = false;

  AnimationController? _autoRotateController;
  Animation<double>? _autoRotateAnimation;
  Timer? _autoRotateTimer;

  bool get _isVertical => widget.scrollDirection == Axis.vertical;
  int get _stackedLevels => widget.stackLevels;

  @override
  void initState() {
    super.initState();
    _initWidgets();
    _calculateSpaceIntervals();
    if (widget.autoRotate) {
      _setupAutoRotate();
    }
  }

  @override
  void didUpdateWidget(StackedCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _initWidgets();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _autoRotateController?.dispose();
    _autoRotateTimer?.cancel();
  }

  void _calculateSpaceIntervals() {
    if (_isVertical) {
      _spaceIntervals =
          (widget.totalHeight - widget.itemHeight) /
          (widget.spaceIntervalFactor * (_stackedLevels - 1));
    } else {
      _spaceIntervals =
          (widget.totalWidth - widget.itemWidth) /
          (widget.spaceIntervalFactor * (_stackedLevels - 1));
    }
  }

  void _setupAutoRotate() {
    _setupController();
    _setupAnimation();
    _setupAutoRotateListeners();
    _setupTimer();
  }

  void _setupController() {
    _autoRotateController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
  }

  void _setupAnimation() {
    _autoRotateAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _autoRotateController!, curve: Curves.easeInOut),
    );
  }

  void _setupTimer() {
    _autoRotateTimer?.cancel();
    _autoRotateTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      _startAutoRotate();
    });
  }

  void _setupAutoRotateListeners() {
    _autoRotateController?.addListener(() {
      setState(() {
        _offset = -_panThreshold * (_autoRotateController?.value ?? 0);
      });
      if (_autoRotateAnimation?.isCompleted == true) {
        _autoRotateComplete();
      }
    });
  }

  void _startAutoRotate() {
    _isAnimating = true;
    _autoRotateController?.forward(from: 0);
  }

  void _stopAutoRotate() {
    _autoRotateTimer?.cancel();
    _autoRotateTimer = null;
  }

  void _autoRotateComplete() {
    setState(() {
      _offset = 0;
      _selectedIndex = (_selectedIndex + 1) % widget.items.length;
      _initWidgets();
      _isAnimating = false;
    });
  }

  void _initWidgets() {
    _stackedItems.clear();
    _stackedItems.add([widget.items[_selectedIndex]]);
    for (int currentLevel = 1; currentLevel <= _stackedLevels; currentLevel++) {
      List<Widget> levelItems = [];
      Widget nextItem = _getItem(widget.items, _selectedIndex, currentLevel);
      Widget previousItem = _getItem(
        widget.items,
        _selectedIndex,
        -currentLevel,
      );
      levelItems.add(nextItem);
      levelItems.add(previousItem);
      _stackedItems.add(levelItems);
    }
  }

  Widget _getItem(List<Widget> items, int selectedIndex, int steps) {
    int itemIndex = (selectedIndex + steps) % items.length;
    return items[itemIndex];
  }

  Positioned _buildPreviousItems(int index, double spaceIntervals) {
    return Positioned(
      top: _isVertical
          ? (widget.totalHeight - widget.itemHeight) / 2 +
                ((index) * spaceIntervals)
          : null,
      left: !_isVertical
          ? (widget.totalWidth - widget.itemWidth) / 2 +
                ((index) * spaceIntervals)
          : null,
      child: Transform.scale(
        scale: 1 - (index * 0.1),
        child: Container(
          height: widget.itemHeight,
          width: widget.itemWidth,
          color: Colors.transparent,
          child: _stackedItems[index][0],
        ),
      ),
    );
  }

  Positioned _buildNextItems(int index, double spaceIntervals) {
    return Positioned(
      bottom: _isVertical
          ? (widget.totalHeight - widget.itemHeight) / 2 +
                ((index) * spaceIntervals)
          : null,
      right: !_isVertical
          ? (widget.totalWidth - widget.itemWidth) / 2 +
                ((index) * spaceIntervals)
          : null,
      child: Transform.scale(
        scale: 1 - (index * 0.1),
        child: Container(
          height: widget.itemHeight,
          width: widget.itemWidth,
          color: Colors.transparent,
          child: _stackedItems[index][1],
        ),
      ),
    );
  }

  Positioned _buildSelectedItem() {
    return Positioned(
      bottom: _isVertical ? (widget.totalHeight - widget.itemHeight) / 2 : null,
      right: !_isVertical ? (widget.totalWidth - widget.itemWidth) / 2 : null,
      child: Transform.scale(
        scale: 1,
        child: GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: (details) => _onPanEnd(),
          onPanCancel: () => _onPanEnd(),
          child: Container(
            height: widget.itemHeight,
            width: widget.itemWidth,
            color: Colors.transparent,
            child: _stackedItems[0][0],
          ),
        ),
      ),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    double delta = _isVertical ? details.delta.dy : details.delta.dx;
    setState(() {
      _offset += delta;
      if (_offset.abs() > _panThreshold) {
        _offset = _panThreshold * _offset.sign;
      }
    });

    double progress = (_offset.abs() / _panThreshold);
    widget.onDragUpdate?.call(progress, _offset);
  }

  void _onPanEnd() {
    setState(() {
      _isAnimating = false;
      bool shouldChangeCard = _offset.abs() > (_panThreshold / 2);

      if (shouldChangeCard) {
        if (_offset > 0) {
          _selectedIndex = (_selectedIndex - 1) % widget.items.length;
          if (_selectedIndex < 0) {
            _selectedIndex += widget.items.length;
          }
        } else {
          _selectedIndex = (_selectedIndex + 1) % widget.items.length;
        }
        _initWidgets();
        widget.onCardChange?.call(_selectedIndex);
      }
      _offset = 0;
      if (widget.autoRotate) {
        _setupTimer();
      }
    });
    widget.onDragEnd?.call();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isAnimating = true;
      _stopAutoRotate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: _isVertical ? 0 : null,
          bottom: _isVertical ? 0 : null,
          left: !_isVertical ? 0 : null,
          right: !_isVertical ? 0 : null,
          width: _isVertical ? widget.itemWidth : null,
          height: !_isVertical ? widget.itemHeight : null,
          child: Opacity(
            opacity: _isAnimating ? 0 : 1,
            child: Stack(
              children: [
                for (
                  int index = _stackedItems.length - 2;
                  index > 0;
                  index--
                ) ...[
                  _buildNextItems(index, _spaceIntervals),
                  _buildPreviousItems(index, _spaceIntervals),
                  _buildSelectedItem(),
                ],
              ],
            ),
          ),
        ),
        if (_isAnimating)
          AnimatedStackedCarousel(
            offset: _offset,
            panThreshold: _panThreshold,
            containerHeight: widget.totalHeight,
            containerWidth: widget.totalWidth,
            spaceIntervals: _spaceIntervals,
            widgetWithLevels: _stackedItems,
            width: widget.itemWidth,
            height: widget.itemHeight,
            isVertical: _isVertical,
            numberOfLevels: _stackedLevels,
          ),
      ],
    );
  }
}
