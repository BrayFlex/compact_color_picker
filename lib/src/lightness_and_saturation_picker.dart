import 'package:flutter/material.dart';

typedef LightnessAndSaturationPickerCallback = void Function(HSVColor color);

class LightnessAndSaturationPicker extends StatefulWidget {
  const LightnessAndSaturationPicker({Key? key, required this.hsvColor, required this.onColorSelected}) : super(key: key);

  final HSVColor hsvColor;
  final LightnessAndSaturationPickerCallback onColorSelected;

  @override
  State<LightnessAndSaturationPicker> createState() => _LightnessAndSaturationPickerState();
}

class _LightnessAndSaturationPickerState extends State<LightnessAndSaturationPicker> {
  OverlayEntry? _previewBubbleOverlay;
  Offset _currentDragOffset = Offset.zero;
  HSVColor _currentHsvColor = const HSVColor.fromAHSV(1.0, 0.0, 0.0, 0.0); // Initial dummy color

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
    final percentOffset = _calculatePercentOffset(localPosition);
    final hsvColor = _hsvColorFromPercentOffset(percentOffset);

    setState(() {
      _currentDragOffset = globalPosition; // Store global position for overlay
      _currentHsvColor = hsvColor; // Store current color for bubble
    });
    widget.onColorSelected(hsvColor);
  }

  Offset _calculatePercentOffset(Offset localPosition) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    return Offset(
      (localPosition.dx / box.size.width).clamp(0.0, 1.0),
      (1.0 - (localPosition.dy / box.size.height).clamp(0.0, 1.0)),
    );
    // Removed duplicate return statement
  }

  HSVColor _hsvColorFromPercentOffset(Offset percentOffset) {
    // Use the hue from the *currently selected* color in the parent picker,
    // but saturation and value from the drag position. Alpha remains 1.0 here.
    return HSVColor.fromAHSV(
        widget.hsvColor.alpha, // Preserve alpha from parent
        widget.hsvColor.hue,   // Use hue from parent
        percentOffset.dx,      // Saturation from horizontal position
        percentOffset.dy       // Value from vertical position
    );
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

    // Use the currently calculated HSV color for the bubble
    final Color bubbleColor = _currentHsvColor.toColor();

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
            clipBehavior: Clip.none, // Allow bubble to draw outside bounds
            children: [
              CustomPaint(painter: LightnessAndSaturationPainter(hue: widget.hsvColor.hue), size: Size.infinite),
              _buildShadeSelector(Size(constraints.maxWidth, constraints.maxHeight))
            ]
          )
      );
    });
  }

  Widget _buildShadeSelector(Size size) {
    final double saturationPercent = widget.hsvColor.saturation;
    final double darknessPercent = 1.0 - widget.hsvColor.value;

    return Positioned(
        left: 0 * (1.0 - saturationPercent) + size.width * saturationPercent,
        top: 0 * (1.0 - darknessPercent) + size.height * darknessPercent,
        child: FractionalTranslation(
          translation: const Offset(-0.5, -0.5),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
          ),
        )
    );
  }
}

class LightnessAndSaturationPainter extends CustomPainter {
  LightnessAndSaturationPainter({required this.hue});

  final double hue;

  @override
  void paint(Canvas canvas, Size size) {
    // Lightness
    final lightGradientShader = const LinearGradient(
        colors: [Colors.white, Colors.black],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter
    ).createShader(Offset.zero & size);
    final lightPaint = Paint()..shader = lightGradientShader;
    canvas.drawRect(Offset.zero & size, lightPaint);

    // Saturation
    final noSaturationColor = HSVColor.fromAHSV(1.0, hue, 0.0, 1.0);
    final fullSaturationColor = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0);
    final saturationGradientShader = LinearGradient(
      colors: [
        noSaturationColor.toColor(),
        fullSaturationColor.toColor(),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(Offset.zero & size);
    final saturationPaint = Paint()
      ..shader = saturationGradientShader
      ..blendMode = BlendMode.modulate;
    canvas.drawRect(Offset.zero & size, saturationPaint);

  }

  @override
  bool shouldRepaint(LightnessAndSaturationPainter oldDelegate) {
    return hue != oldDelegate.hue;
  }
}
