## 1.0.1

*   **Docs** Updated the documentation with images and improved missing descriptions. 🦜

## 1.0.0

*   **BREAKING:** Made `initialColor` optional in `ColorPicker`, defaulting to `Color(0xFFF3C50B)`.
*   **Feature:** Added `onColorChanged` callback to `ColorPicker` providing the selected `Color`.
*   **Feature:** Implemented interactive preview bubble for Hue, Saturation/Lightness, and Opacity sliders.
*   **Feature:** Added `Color` extension methods for Hex conversion (`toHex`, `toHexHash`, `toHexAlpha`, `toHexHashAlpha`).
*   **Feature:** Added optional `showHexCode` parameter to display the Hex code in the picker.
*   **Fix:** Optimized Hue slider gradient calculation.
*   **Fix:** Correctly implemented `shouldRepaint` in `OpacityPainter`.
*   **Fix:** Addressed various analyzer warnings (deprecated members, dead code, null checks).
*   **Style:** Added rounded corners to Hue (top) and Opacity (bottom-left) sliders.
*   **Example:** Created a dedicated `example/` project demonstrating usage and features.
*   **Docs:** Updated `README.md` with features, usage examples, and contribution guidelines.

## 0.0.1

*   Initial experimental version.
