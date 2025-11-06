
A Flutter package for carousel slider that stacks and animates items with customizable spacing, scale, and alignment.

## Features

* Infinite scroll
* Supports Vertical & Horizontal scrolling
* Auto play

## Supported platforms

* Android
* IOS

## Installation

Add `stacked_carousel_slider:^0.0.4` to your `pubspec.yaml` dependencies. And import it:

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

## Params

It has many required properties, including:

- `items` – The items that you want to stack.
- `height` – The height of each widget.
- `width` – The width of each widget.
- `stacklevels` – The number of layers (or "stack levels") used to stack widgets on top of each other.
- `spaceIntervalsFactor` – The spacing factor used to calculate the distance between stacked widgets.

It has some optional properties, including:

- `autoRotate` – Whether the stacked widgets should automatically rotate. 
- `scrollDirection` – The axis along which the stacked widgets can be scrolled.
- `onCardChange` – Called when the visible (or active) card in the stack changes.
- `onDragUpdate` – Called during a drag gesture, providing the current `progress` and `direction`.
- `onDragEnd` – Called when a drag gesture ends.

## Screenshots

Horizontal Auto Rotate

<p>
    <img src="https://github.com/youssefehab11/stacked_carousel_slider/blob/master/screenshots/horizontal_auto_rotate.gif?raw=true"/>
</p>

Horizontal Scroll

<p>
    <img src="https://github.com/youssefehab11/stacked_carousel_slider/blob/master/screenshots/horizontal_scroll.gif?raw=true"/>
</p>

Vertical Auto Rotate

<p>
    <img src="https://github.com/youssefehab11/stacked_carousel_slider/blob/master/screenshots/vertical_auto_rotate.gif?raw=true"/>
</p>

Vertical Scroll

<p>
    <img src="https://github.com/youssefehab11/stacked_carousel_slider/blob/master/screenshots/vertical_scroll.gif?raw=true"/>
</p>
