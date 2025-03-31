import 'package:compact_color_picker/compact_color_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});
  final String _title = 'Compact Color Picker Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: const ColorPicker(initialColor: Colors.blueGrey),
      ),
    );
  }

}
