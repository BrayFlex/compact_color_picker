import 'package:compact_color_picker/compact_color_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compact Color Picker Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ExamplePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  // Initialize with a default color
  Color _selectedColor = Colors.blueGrey;
  // Store the HSVColor as well, as the picker currently works with it internally
  HSVColor _selectedHsvColor = HSVColor.fromColor(Colors.blueGrey); // Keep for display if needed

  // Callback handler for the ColorPicker
  void _handleColorChanged(Color color) {
    setState(() {
      _selectedColor = color;
      _selectedHsvColor = HSVColor.fromColor(color); // Update HSV for display
    });
  }

  // Removed local hex conversion functions, will use utils from the package

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compact Color Picker Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Select a Color:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Constrain the picker's size for demonstration
            SizedBox(
              width: 300, // Example width
              height: 375, // Example height (maintaining ~4:5 ratio)
              child: ColorPicker(
                initialColor: _selectedColor,
                showHexCode: false,
                showOpacity: true,
                onColorChanged: _handleColorChanged, // Use the new callback
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Selected Color:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    border: Border.all(color: Colors.grey),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     // Use the utility extension methods for Hex conversion
                     Text('HEX: ${_selectedColor.toHexHash()}'),
                      Text('HEX (Alpha): ${_selectedColor.toHexHashAlpha()}'),
                      // Use .r, .g, .b, .a instead of deprecated getters
                      Text('RGB: (${_selectedColor.r}, ${_selectedColor.g}, ${_selectedColor.b})'),
                      Text('Alpha: ${_selectedColor.a}'),
                      // Display HSV temporarily for debugging
                      Text('HSV: (${_selectedHsvColor.hue.toStringAsFixed(1)}, ${_selectedHsvColor.saturation.toStringAsFixed(2)}, ${_selectedHsvColor.value.toStringAsFixed(2)})'),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
