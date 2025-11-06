import 'package:flutter/material.dart';

class AnimatedStackedCarousel extends StatelessWidget {
  final double offset;
  final int panThreshold;
  final double containerHeight;
  final double containerWidth;
  final double spaceIntervals;
  final double width;
  final double height;
  final int numberOfLevels;
  final List<List<Widget>> widgetWithLevels;
  final bool isVertical;

  const AnimatedStackedCarousel({
    super.key,
    required this.offset,
    required this.panThreshold,
    required this.containerHeight,
    required this.containerWidth,
    required this.spaceIntervals,
    required this.widgetWithLevels,
    required this.width,
    required this.height,
    required this.numberOfLevels,
    required this.isVertical,
  });

  double _calculateTopCardPosition() {
    double result;
    if (isVertical) {
      result = (containerHeight - height) / 2;
    } else {
      result = (containerWidth - width) / 2;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        double progress = offset.abs() / panThreshold;
        bool isForward = offset > 0;

        //Build behind cards
        List<Widget> stack = [
          for (int index = widgetWithLevels.length - 1; index > 0; index--)
            ..._getAnimatingCardStack(
              containerHeight,
              index,
              spaceIntervals,
              isForward,
              progress,
            ),
        ];

        //Build selected card
        Widget topElement = Builder(
          builder: (context) {
            double curvedProgress = Curves.linear.transform(progress);
            double currentTop = _calculateTopCardPosition();
            double targetTop =
                _calculateTopCardPosition() +
                (isForward ? spaceIntervals : -spaceIntervals);
            double top = currentTop + (targetTop - currentTop) * curvedProgress;

            double currentScale = 1;
            double targetScaleForward = 0.9;
            double scale =
                currentScale +
                (targetScaleForward - currentScale) * curvedProgress;

            return Positioned(
              top: isVertical ? top : null,
              left: !isVertical ? top : null,
              child: Opacity(
                opacity: 1,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    height: height,
                    width: width,
                    color: Colors.transparent,
                    child: widgetWithLevels[0][0],
                  ),
                ),
              ),
            );
          },
        );
        if (progress >= 0.5) {
          Widget topStack = stack.last;
          stack.removeLast();
          stack.add(topElement);
          stack.add(topStack);
        } else {
          stack.add(topElement);
        }
        return Positioned(
          top: isVertical ? 0 : null,
          bottom: isVertical ? 0 : null,
          left: !isVertical ? 0 : null,
          right: !isVertical ? 0 : null,
          width: isVertical ? width : null,
          height: !isVertical ? height : null,
          child: Stack(children: stack),
        );
      },
    );
  }

  List<Widget> _getAnimatingCardStack(
    double maxHeight,
    int index,
    double spaceIntervals,
    bool isForward,
    double progress,
  ) {
    double scale = 1 - (index * 0.1);

    double curvedProgress = Curves.linear.transform(progress);

    //Scale for bottom cards
    double targetScaleForward = 1 - (index * 0.1) + (isForward ? -0.1 : 0.1);
    double scaleForward = scale + (targetScaleForward - scale) * curvedProgress;

    //Scale for top cards
    double targetScaleReverse = 1 - (index * 0.1) + (isForward ? 0.1 : -0.1);
    double scaleReverse = scale + (targetScaleReverse - scale) * curvedProgress;

    double position = _calculateTopCardPosition() + ((index) * spaceIntervals);

    //Position for bottom cards
    double targetPositionForward =
        _calculateTopCardPosition() +
        ((index) * spaceIntervals) +
        (isForward ? spaceIntervals : -spaceIntervals);
    double positionForward =
        position + (targetPositionForward - position) * curvedProgress;

    //Position for top cards
    double targetPositionReverse =
        _calculateTopCardPosition() +
        ((index) * spaceIntervals) +
        (isForward ? -spaceIntervals : spaceIntervals);
    double positionReverse =
        position + (targetPositionReverse - position) * curvedProgress;

    double currentOpacity = index >= numberOfLevels ? 0 : 1;

    //Opacity for bottom cards
    double targetOpacityForward = index + (isForward ? 1 : -1) >= numberOfLevels
        ? 0
        : 1;
    double opacityForward =
        currentOpacity + (targetOpacityForward - currentOpacity) * progress;

    //Opacity for top cards
    double targetOpacityReverse = index + (isForward ? -1 : 1) >= numberOfLevels
        ? 0
        : 1;
    double opacityReverse =
        currentOpacity + (targetOpacityReverse - currentOpacity) * progress;

    Widget forwardWidget = Positioned(
      top: isVertical ? positionForward : null,
      left: !isVertical ? positionForward : null,
      child: Opacity(
        opacity: opacityForward,
        child: Transform.scale(
          scale: scaleForward,
          child: Container(
            height: height,
            width: width,
            color: Colors.transparent,
            child: widgetWithLevels[index][0],
          ),
        ),
      ),
    );

    Widget reverseWidget = Positioned(
      bottom: isVertical ? positionReverse : null,
      right: !isVertical ? positionReverse : null,
      child: Opacity(
        opacity: opacityReverse,
        child: Transform.scale(
          scale: scaleReverse,
          child: Container(
            height: height,
            width: width,
            color: Colors.transparent,
            child: widgetWithLevels[index][1],
          ),
        ),
      ),
    );
    if (isForward) {
      return [forwardWidget, reverseWidget];
    } else {
      return [reverseWidget, forwardWidget];
    }
  }
}
