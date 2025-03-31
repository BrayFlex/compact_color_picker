import 'package:flutter/material.dart';

typedef OpacitySliderCallback = void Function(double opacity);

class OpacitySlider extends StatefulWidget {
  const OpacitySlider({Key? key, required this.selectedHue, required this.onOpacitySelected}) : super(key: key);
  final HSVColor selectedHue;
  final OpacitySliderCallback onOpacitySelected;

  @override
  State<OpacitySlider> createState() => _OpacitySliderState();
}

class _OpacitySliderState extends State<OpacitySlider> {
  OverlayEntry? _previewBubbleOverlay;
  Offset _currentDragOffset = Offset.zero;
  double _currentAlpha = 1.0; // Alpha ranges from 0.0 to 1.0

  // --- Drag Handlers ---

  void _onDragStart(DragStartDetails details) {
    _updateAlphaAndPosition(details.globalPosition);
    _showPreviewBubble();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _updateAlphaAndPosition(details.globalPosition);
    _updatePreviewBubble();
  }

  void _onDragEnd(DragEndDetails details) {
    _removePreviewBubble();
  }

  void _onDragCancel() {
    _removePreviewBubble();
  }

  // --- Calculations ---

  void _updateAlphaAndPosition(Offset globalPosition) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(globalPosition);
    final alpha = _calculateAlphaPercent(localPosition);

    setState(() {
      _currentDragOffset = globalPosition; // Store global position for overlay
      _currentAlpha = alpha; // Store current alpha for bubble color
    });
    widget.onOpacitySelected(alpha);
  }

  double _calculateAlphaPercent(Offset localPosition) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    // Alpha goes from 1.0 (left) to 0.0 (right)
    return (1.0 - (localPosition.dx / box.size.width)).clamp(0.0, 1.0);
  }

  // --- Preview Bubble Overlay ---

  void _showPreviewBubble() {
    _removePreviewBubble(); // Ensure any previous overlay is removed

    _previewBubbleOverlay = OverlayEntry(
      builder: (context) => _buildPreviewBubbleWidget(),
    );
    // Get OverlayState and insert (assuming it's not null in typical usage)
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

    // Use the parent's selected hue/saturation/value, but the current alpha
    final Color bubbleColor = widget.selectedHue.withAlpha(_currentAlpha).toColor();

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: IgnorePointer( // Prevent the bubble from intercepting touch events
        child: Material( // Provides elevation and shadow
          elevation: 5.0,
          shape: const CircleBorder(),
          // Use a checkerboard background for the bubble itself to show transparency
          child: ClipOval( // Clip the painter to a circle
            child: CustomPaint(
              painter: OpacityPainter.checkerboardPainter(), // Use a static checkerboard
              child: Container(
                width: bubbleSize,
              height: bubbleSize,
              decoration: BoxDecoration(
                color: bubbleColor, // Apply the semi-transparent color
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.0),
              ),
            ),
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
          clipBehavior: Clip.none, // Allow bubble to draw outside bounds
          children: [
            CustomPaint(
              painter: OpacityPainter(selectedHue: widget.selectedHue),
              size: Size.infinite,
            ),
            _buildOpacitySelector(constraints.maxWidth)
          ],
        ),
      );
    });
  }

  Widget _buildOpacitySelector(double width) {
    final opacityPercent = widget.selectedHue.alpha;

    return Align(
      alignment: Alignment((opacityPercent * -2) + 1.0, 0.0),
      child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.white, width: 2)),
            width: 9,
          ),
    );
  }
}

class OpacityPainter extends CustomPainter {
  const OpacityPainter({required this.selectedHue});

  final HSVColor selectedHue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Define the rounded rectangle shape matching the OpacitySlider's background
    const Radius cornerRadius = Radius.circular(5.0);
    final RRect roundedRect = RRect.fromRectAndCorners(
      Offset.zero & size,
      bottomLeft: cornerRadius, // Match the OpacitySlider's rounding
    );

    paint.color = Colors.white;
    canvas.drawRect(Offset.zero & size, paint);

    double dx = 0.0;
    double dy = 0.0;
    final checkerPath = Path();
    for (var j = 0; j < size.height / 10; j++) {
      for (var i = 0; i < size.width / 10; i++) {
        if (i % 2 == 0 && j % 2 != 0 || i % 2 != 0 && j % 2 == 0) {
          final rectX = dx;
          final rectY = dy;
          if (j == 3 && i == 0) { // crop the bottom left checkerboard 
            final innerRect = RRect.fromLTRBAndCorners(rectX, rectY, rectX + 10, rectY - 10, bottomLeft: const Radius.circular(5));
            checkerPath.addRRect(innerRect);
          } else {
            final innerRect = Rect.fromLTWH(rectX, rectY, 10, 10);
            checkerPath.addRect(innerRect);
          }
        }
        dx += 10;
      }
      dy += 10;
      dx = 0;
    }
    paint
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    canvas.drawPath(checkerPath, paint);

    // Apply the actual opacity gradient based on the selected color
    paint
      ..blendMode = BlendMode.srcOver
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
        selectedHue.withAlpha(1.0).toColor(), // Use the base color with full alpha
        selectedHue.withAlpha(0.0).toColor(), // Use the base color with zero alpha
      ]).createShader(Offset.zero & size);

    canvas.drawRRect(roundedRect, paint);
  }

  @override
  bool shouldRepaint(covariant OpacityPainter oldDelegate) {
    // Repaint if the base color (hue, saturation, value) changes,
    // as this affects the gradient start/end colors.
    return selectedHue.hue != oldDelegate.selectedHue.hue ||
           selectedHue.saturation != oldDelegate.selectedHue.saturation ||
           selectedHue.value != oldDelegate.selectedHue.value;
  }

  // Static method to get a simple checkerboard painter for the bubble background
  static CustomPainter checkerboardPainter() {
    return _CheckerboardPainter();
  }
}

// Simple checkerboard painter for the bubble background
class _CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    // Now draw the checkerboard within the clipped area
    final paint = Paint();
    final double squareSize = size.width / 4; // Example: 4x4 checkerboard

    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if ((i + j) % 2 == 0) {
          paint.color = Colors.white;
        } else {
          paint.color = Colors.grey[300]!;
        }
        canvas.drawRect(
          Rect.fromLTWH(i * squareSize, j * squareSize, squareSize, squareSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
