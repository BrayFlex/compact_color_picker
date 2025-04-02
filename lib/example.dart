import 'package:compact_color_picker/compact_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});
  final String _title = 'Compact Color Picker Demo';

    // Callback handler for the ColorPicker
  void _handleColorChanged(Color color) {
    if(kDebugMode) print(color.toString()); // Print the selected color
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: ColorPicker(
          initialColor: Colors.blueGrey,
          showHexCode: false,
          showOpacity: true,
          onColorChanged: _handleColorChanged, // Use the new callback
          ),
      ),
    );
  }

}
