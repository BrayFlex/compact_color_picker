import 'package:compact_color_picker/compact_color_picker.dart'; // Imports the extension methods
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Color Utils Hex Conversion Tests', () {
    test('toHex converts solid colors correctly', () {
      expect(Colors.red.toHex(), 'FF0000');
      expect(Colors.green.toHex(), '4CAF50'); // Material green
      expect(Colors.blue.toHex(), '2196F3'); // Material blue
      expect(Colors.black.toHex(), '000000');
      expect(Colors.white.toHex(), 'FFFFFF');
      expect(const Color(0xFFABCDEF).toHex(), 'ABCDEF');
      expect(const Color(0xFF123456).toHex(), '123456');
    });

    test('toHexHash converts solid colors correctly', () {
      expect(Colors.red.toHexHash(), '#FF0000');
      expect(Colors.black.toHexHash(), '#000000');
      expect(const Color(0xFFABCDEF).toHexHash(), '#ABCDEF');
    });

    test('toHexAlpha converts colors with alpha correctly', () {
      expect(Colors.red.toHexAlpha(), 'FFFF0000'); // Fully opaque
      expect(Colors.black.toHexAlpha(), 'FF000000'); // Fully opaque
      expect(Colors.white.toHexAlpha(), 'FFFFFFFF'); // Fully opaque
      expect(Colors.transparent.toHexAlpha(), '00000000'); // Fully transparent
      expect(const Color(0x80FF0000).toHexAlpha(), '80FF0000'); // 50% opaque red
      expect(const Color(0x00FFFFFF).toHexAlpha(), '00FFFFFF'); // Fully transparent white
      expect(const Color(0x1A2B3C4D).toHexAlpha(), '1A2B3C4D');
    });

     test('toHexHashAlpha converts colors with alpha correctly', () {
      expect(Colors.red.toHexHashAlpha(), '#FFFF0000');
      expect(Colors.transparent.toHexHashAlpha(), '#00000000');
      expect(const Color(0x80FF0000).toHexHashAlpha(), '#80FF0000');
      expect(const Color(0x1A2B3C4D).toHexHashAlpha(), '#1A2B3C4D');
    });

     test('toHex handles lower hex values correctly (padding)', () {
       expect(const Color(0xFF010203).toHex(), '010203');
       expect(const Color(0xFFF0E0D0).toHex(), 'F0E0D0');
     });

     test('toHexAlpha handles lower hex values correctly (padding)', () {
       expect(const Color(0x0A010203).toHexAlpha(), '0A010203');
       expect(const Color(0xF0E0D0C0).toHexAlpha(), 'F0E0D0C0');
     });
  });
}
