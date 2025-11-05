
A Flutter package for carousel slider that stacks and animates items with customizable spacing, scale, and alignment.

## Features

* Infinite scroll
* Supports Vertical & Horizontal scrolling
* Auto play

## Supported platforms

* Android
* IOS

## Installation

Add `stacked_carousel_slider: ^1.0.0` to your `pubspec.yaml` dependencies. And import it:

```dart
import 'package:stacked_carousel_slider/stacked_cards.dart';
```

## Usage

Simply create a `StackedCarouselSlider` widget, and pass the required params:

```dart
StackedCarouselSlider(
    items: [
            Colors.blue,
            Colors.red,
            Colors.yellow,
            Colors.green,
            Colors.purple,
          ].map((color) => Container(color: color)).toList(),
          height: 300,
          width: 200,
          autoRotate: true,
          stackLevels: 3,
          spaceIntervalsFactor: 2,
        ),
```

## Screenshots

Horizontal Auto Rotate

![Horizontal Auto Rotate](screenshots/horizontal_auto_rotate.gif)

Horizontal Scroll

![Horizontal Scroll](screenshots/horizontal_scroll.gif)

Vertical Auto Rotate

![Vertical Auto Rotate](screenshots/vertical_auto_rotate.gif)

Vertical Scroll

![Vertical Scroll](screenshots/vertical_scroll.gif)
