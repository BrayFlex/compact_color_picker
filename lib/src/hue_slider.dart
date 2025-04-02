import 'package:flutter/material.dart';

typedef HuePickerCallback = void Function(double hue);

class HueSlider extends StatefulWidget {
  const HueSlider({Key? key, required this.selectedHue, required this.onHueSelected}) : super(key: key);
  final double selectedHue;
  final HuePickerCallback onHueSelected;

  @override
  State<HueSlider> createState() => _HueSliderState();
}

class _HueSliderState extends State<HueSlider> {
  OverlayEntry? _previewBubbleOverlay;
  Offset _currentDragOffset = Offset.zero;
  double _currentHue = 0.0;

  // --- Drag Handlers ---

  void _onDragStart(DragStartDetails details) {
    _updateColorAndPosition(details.globalPosition);
    _showPreviewBubble();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _updateColorAndPosition(details.globalPosition);
    _updatePreviewBubble();
  }

  void _onDragEnd(DragEndDetails details) {
    _removePreviewBubble();
  }

  void _onDragCancel() {
    _removePreviewBubble();
  }

  // --- Calculations ---

  void _updateColorAndPosition(Offset globalPosition) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(globalPosition);
    final sliderPercent = _calculateSliderPercent(localPosition);
    final hue = _hueFromSliderPercent(sliderPercent);

    setState(() {
      _currentDragOffset = globalPosition; // Store global position for overlay
      _currentHue = hue; // Store current hue for bubble color
    });
    widget.onHueSelected(hue);
  }


  double _calculateSliderPercent(Offset localPosition) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    return (1.0 - (localPosition.dx / box.size.width)).clamp(0.0, 1.0);
    // Removed duplicate return statement
  }

  double _hueFromSliderPercent(double sliderPercent) {
    return sliderPercent * 360;
  }

  // --- Preview Bubble Overlay ---

  void _showPreviewBubble() {
    _removePreviewBubble(); // Ensure any previous overlay is removed

    _previewBubbleOverlay = OverlayEntry(
      builder: (context) => _buildPreviewBubbleWidget(),
    );
    // Explicit null check for OverlayState
    final OverlayState overlayState = Overlay.of(context);
      overlayState.insert(_previewBubbleOverlay!);
  }

  void _updatePreviewBubble() {
    _previewBubbleOverlay?.markNeedsBuild();
  }

  void _removePreviewBubble() {
    _previewBubbleOverlay?.remove();
    _previewBubbleOverlay = null;
  }

  Widget _buildPreviewBubbleWidget() {
    const double bubbleSize = 48.0;
    const double bubblePadding = 12.0; // Space above the finger

    // Calculate position: Center the bubble horizontally above the drag point
    final Offset position = Offset(
      _currentDragOffset.dx - bubbleSize / 2,
      _currentDragOffset.dy - bubbleSize - bubblePadding,
    );

    final Color bubbleColor = HSVColor.fromAHSV(1.0, _currentHue, 1.0, 1.0).toColor();

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: IgnorePointer( // Prevent the bubble from intercepting touch events
        child: Material( // Provides elevation and shadow
          elevation: 5.0,
          shape: const CircleBorder(),
          child: Container(
            width: bubbleSize,
            height: bubbleSize,
            decoration: BoxDecoration(
              color: bubbleColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.0),
            ),
          ),
        ),
      ),
    );
  }

  // --- Lifecycle ---

  @override
  void dispose() {
    _removePreviewBubble(); // Clean up overlay if widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onPanStart: _onDragStart,
        onPanUpdate: _onDragUpdate,
        onPanEnd: _onDragEnd, // Add end handler
        onPanCancel: _onDragCancel, // Add cancel handler
        child: Stack(
          clipBehavior: Clip.none, // Allow bubble to draw outside bounds if needed
          children: [
            CustomPaint(
              painter: HuePainter(),
              size: Size.infinite,
            ),
            _buildHueSelector(constraints.maxWidth)
          ],
        ),
      );
    });
  }

  Widget _buildHueSelector(double width) {
    final huePercent = widget.selectedHue / 360;

    return Align(
      alignment: Alignment((huePercent * -2) + 1.0, 0.0),
      child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.white, width: 2)),
            width: 9,
          ),
        );
  }
}

// Define the standard hue stops for the gradient.
// These represent Red, Yellow, Green, Cyan, Blue, Magenta, and back to Red.
final List<Color> _hueColors = [
  const HSVColor.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),   // Red
  const HSVColor.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),  // Yellow
  const HSVColor.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(), // Green
  const HSVColor.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(), // Cyan
  const HSVColor.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(), // Blue
  const HSVColor.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(), // Magenta
  const HSVColor.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(), // Red (again)
];

class HuePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient gradient = LinearGradient(
      begin: Alignment.centerRight, // Corresponds to Hue 0 (Red)
      end: Alignment.centerLeft,    // Corresponds to Hue 360 (Red)
      colors: _hueColors,
    );
    final Paint paint = Paint()..shader = gradient.createShader(rect);
    const Radius cornerRadius = Radius.circular(5.0); // Define corner radius

    // Create a rounded rectangle RRect
    final RRect roundedRect = RRect.fromRectAndCorners(
      rect,
      topLeft: cornerRadius,
      topRight: cornerRadius,
      // Bottom corners remain sharp
    );

    // Draw the rounded rectangle
    canvas.drawRRect(roundedRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
