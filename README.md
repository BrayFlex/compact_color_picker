# 🦜 Compact Color Picker

[![pub package](https://img.shields.io/pub/v/compact_color_picker.svg)](https://pub.dev/packages/compact_color_picker)

A simple & clean color picker widget with opacity for Flutter. Designed to be powerful yet compact (mobile-first), suitable for all platforms! Providing a compact user-friendly interface for selecting colors via Hue, Saturation, Lightness, and Opacity controls.

**Features:**

*   Compact design will never overflow, ideal for mobile or desktop layouts. 
*   Hue, Saturation, Lightness, and Opacity sliders.
*   Interactive preview bubble ensures users can see the color when tapping during selection.
*   Optional Opacity Selector.
*   Optional built-in Hex code display.
*   Provides selected color via a standard `Color` object callback.
*   Includes utility extensions for easy conversion to Hex strings (`#RRGGBB`, `#AARRGGBB`).
*   Customizable initial color.
*   Simple styling that fits in any application.

<img src="https://raw.githubusercontent.com/brayflex/compact_color_picker/main/assets/compact_color_picker.gif" alt="Compact Color Picker in Action">

## 🧑‍🎨️ Getting Started

1.  **Add Dependency:**
    Add this to your package's `pubspec.yaml` file:

    ```yaml
    dependencies:
      compact_color_picker: ^1.0.2 
    ```

2.  **Install:**
    Run `flutter pub get` in your terminal.

3.  **Import:**
    Import the package in your Dart code:

    ```dart
    import 'package:compact_color_picker/compact_color_picker.dart';
    ```

## 🎨 Usage

Use the `ColorPicker` widget in your Flutter application. Provide an optional `initialColor` and an `onColorChanged` callback to receive updates.

```dart
import 'package:compact_color_picker/compact_color_picker.dart';
import 'package:flutter/material.dart';

class MyColorSelector extends StatefulWidget {
  const MyColorSelector({super.key});

  @override
  State<MyColorSelector> createState() => _MyColorSelectorState();
}

class _MyColorSelectorState extends State<MyColorSelector> {
  Color _currentColor = Colors.blue; // Or use the default: Color(0xFFF3C50B)

  void _handleColorChanged(Color color) {
    setState(() {
      _currentColor = color;
      // You can now use the color object or its hex representation
      print('Selected Color: $color');
      print('Selected Hex: ${_currentColor.toHexHash()}');
      print('Selected Hex with Alpha: ${_currentColor.toHexHashAlpha()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Select Color:',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 300, // Adjust size as needed
          height: 375, // Maintain ~4:5 aspect ratio for square palette
          child: ColorPicker(
            initialColor: _currentColor,
            onColorChanged: _handleColorChanged,
            showHexCode: true, // Optionally display the hex code
            showOpacity: false, // Optionally hide the opacity slider
          ),
        ),
        const SizedBox(height: 16),
        Text('Current Hex: ${_currentColor.toHexHashAlpha()}'),
        Container(
          width: 50,
          height: 50,
          color: _currentColor,
        ),
      ],
    );
  }
}
```
<img src="https://raw.githubusercontent.com/brayflex/compact_color_picker/main/assets/compact_color_picker.png" alt="Compact Color Picker Values">

## 🌈 Accessing Color Values

The `onColorChanged` callback provides the selected color as a standard Flutter `Color` object. You can easily access various formats:

*   **RGB (0-255):** Directly access `color.red`, `color.green`, `color.blue`.
*   **Alpha (0-255):** Directly access `color.alpha`.
*   **HEX Strings:** Use the included extension methods:
    *   `color.toHex()`: Returns `RRGGBB` string.
    *   `color.toHexHash()`: Returns `#RRGGBB` string.
    *   `color.toHexAlpha()`: Returns `AARRGGBB` string.
    *   `color.toHexHashAlpha()`: Returns `#AARRGGBB` string.
*   **HSV:** Convert using `HSVColor.fromColor(color)` and access `.hue`, `.saturation`, `.value`.
*   **HSL:** Convert using `HSLColor.fromColor(color)` and access `.hue`, `.saturation`, `.lightness`.

Example:

```dart
void _handleColorChanged(Color color) {
  // RGB
  int r = color.red;
  int g = color.green;
  int b = color.blue;
  print('RGB: ($r, $g, $b)');

  // HEX
  print('Hex: ${color.toHexHash()}');

  // HSV
  HSVColor hsv = HSVColor.fromColor(color);
  print('HSV: (${hsv.hue.toStringAsFixed(1)}, ${hsv.saturation.toStringAsFixed(2)}, ${hsv.value.toStringAsFixed(2)})');
}
```

## 💖 Credit

Thanks to SuperDeclarative for his tutorial on painting accurate color spectrums!

## 🌱 Contributing

Contributions are welcome! Please feel free to submit issues, pull requests, or suggestions to improve the package.

1.  Fork the repository.
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

## 👔 License

Distributed under the MIT License. See `LICENSE` for more information.
