import 'package:flutter/painting.dart';

/// Extension methods for the standard Flutter [Color] class.
extension CompactColorPickerColorUtils on Color {
  /// Converts the color to a Hex string in the format RRGGBB.
  ///
  /// Example: `Colors.red.toHex()` returns `'FF0000'`.
  String toHex() {
    // Construct hex string from R, G, B components using .r, .g, .b
    final String rStr = (r * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String gStr = (g * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String bStr = (b * 255).toInt().toRadixString(16).padLeft(2, '0');
    return '$rStr$gStr$bStr'.toUpperCase();
  }

  /// Converts the color to a Hex string in the format #RRGGBB.
  ///
  /// Example: `Colors.red.toHexHash()` returns `'#FF0000'`.
  String toHexHash() {
    return '#${toHex()}';
  }

  /// Converts the color to a Hex string including alpha, in the format AARRGGBB.
  ///
  /// Example: `Colors.red.withOpacity(0.5).toHexAlpha()` returns `'80FF0000'`.
  String toHexAlpha() {
    // Construct hex string from A, R, G, B components using .a, .r, .g, .b
    final String aStr = (a * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String rStr = (r * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String gStr = (g * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String bStr = (b * 255).toInt().toRadixString(16).padLeft(2, '0');
    return '$aStr$rStr$gStr$bStr'.toUpperCase();
  }

  /// Converts the color to a Hex string including alpha, in the format #AARRGGBB.
  ///
  /// Example: `Colors.red.withOpacity(0.5).toHexHashAlpha()` returns `'#80FF0000'`.
  String toHexHashAlpha() {
    return '#${toHexAlpha()}';
  }

  // Note: Conversions to/from HSV and HSL are already handled by Flutter's
  // HSVColor.fromColor(), HSLColor.fromColor(), hsvColor.toColor(), hslColor.toColor().
  // We don't need to replicate that here, but we can document how users can do it.
}
