import 'package:compact_color_picker/compact_color_picker.dart';
import 'package:flutter/material.dart';

import 'hue_slider.dart';
import 'lightness_and_saturation_picker.dart';
import 'opacity_slider.dart';

// For a square color pallet display use an aspect ratio of 4:5, ie: w320 x h400

/// A callback type for color changes. Provides the selected color.
typedef ColorChangedCallback = void Function(Color color);

// Define the default color if none is provided.
const Color _defaultInitialColor = Color(0xFFF3C50B);

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    Key? key,
    this.initialColor = _defaultInitialColor, // Make optional and provide default
    this.onColorChanged,
    this.showHexCode = false,
    this.showOpacity = true, // Add showOpacity field
  }) : super(key: key);

  final Color initialColor;
  final ColorChangedCallback? onColorChanged;
  final bool showHexCode;
  final bool showOpacity; // Declare showOpacity field

  @override
  State<ColorPicker> createState() => _ColorPicker();
}

class _ColorPicker extends State<ColorPicker> {
  late HSVColor _hsvColor;
  late bool _showHexCode;
  late bool _showOpacity; // Add state variable for showOpacity

  @override
  void initState() {
    super.initState();
    _hsvColor = HSVColor.fromColor(widget.initialColor);
    _showHexCode = widget.showHexCode;
    _showOpacity = widget.showOpacity; // Initialize state variable
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildHueSlider(),
      Expanded(child: _buildLightnessAndSaturationPicker()),
      // Conditionally build the bottom row based on showOpacity
      if (_showOpacity)
        Row(children: [
          Expanded(child: _buildOpacitySlider()),
          _buildColorDisplay(),
        ])
      else
        // If opacity is hidden, show only the color display, expanded
        Row(children: [
          Expanded(child: _buildColorDisplay()),
        ]),
    ]);
  }

  Widget _buildLightnessAndSaturationPicker() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: LightnessAndSaturationPicker(
        hsvColor: _hsvColor,
        onColorSelected: (HSVColor color) {
          setState(() {
            _hsvColor = color;
          });
          // Call the public callback with the updated Color
          widget.onColorChanged?.call(_hsvColor.toColor());
        },
      ),
    );
  }

  Widget _buildHueSlider() {
    return SizedBox(
        height: 40,
        child: HueSlider(
            selectedHue: _hsvColor.hue,
            onHueSelected: (double hue) {
              setState(() {
                _hsvColor = _hsvColor.withHue(hue);
              });
              // Call the public callback with the updated Color
              widget.onColorChanged?.call(_hsvColor.toColor());
            }));
  }

  Widget _buildOpacitySlider() {
    return SizedBox(
        height: 40,
        child: OpacitySlider(
            selectedHue: _hsvColor,
            onOpacitySelected: (double alpha) {
              setState(() {
                _hsvColor = _hsvColor.withAlpha(alpha);
              });
              // Call the public callback with the updated Color
              widget.onColorChanged?.call(_hsvColor.toColor());
            }));
  }


  Widget _buildColorDisplay() {
    // Adjust width and border radius based on whether opacity slider is shown
    final double displayWidth = _showOpacity ? 150 : double.infinity;
    final BorderRadius borderRadius = _showOpacity
        ? const BorderRadius.only(bottomRight: Radius.circular(5))
        : const BorderRadius.only(
            bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5));

    return Container(
        height: 40,
        width: displayWidth,
        decoration: BoxDecoration(
          color: _hsvColor.toColor(),
          borderRadius: borderRadius, // Use dynamic border radius
        ),
        child: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Container(
                decoration: BoxDecoration(
                    color: _showHexCode && _hsvColor.alpha < 0.4 ? Colors.white54 : Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(4))
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    child: DefaultTextStyle(
                      style: const TextStyle(inherit: true),
                      child: _showHexCode ? Text('#${_hsvColor.toColor().toHexAlpha().toString()}',
                          style: TextStyle(fontSize: 14, color: _hsvColor.toColor().computeLuminance() > 0.35 || _hsvColor.alpha < 0.4 ? Colors.black : Colors.white)
                      ) : Container(),
                    )
                ),
              )
          ),
        ),
    );
  }
}
