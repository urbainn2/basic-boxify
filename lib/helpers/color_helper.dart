import 'package:flutter/material.dart';

class ColorHelper {
  /// Ensures that the provided color is not too dark or too light.
  /// Returns the adjusted color if it is outside the specified range.
  /// Parameters minLightness and maxLightness should be in the range 0.0 to 1.0.
  static Color ensureWithinRange(
    Color color, {
    double minLightness = 0.2,
    double maxLightness = 0.8,
  }) {
    final hslColor = HSLColor.fromColor(color);
    return ensureWithinRangeHsl(hslColor,
            minLightness: minLightness, maxLightness: maxLightness)
        .toColor();
  }

  /// Returns a "dimmed" version of the provided color.
  /// The dimFactor (between 0.0 and 1.0) indicates how much to reduce the
  /// color's lightness.
  static Color dimColor(Color color, {double dimFactor = 0.1}) {
    final hslColor = HSLColor.fromColor(color);
    return dimColorHsl(hslColor, dimFactor: dimFactor).toColor();
  }

  /// Ensures that the provided color is not too dark or too light.
  /// Returns the adjusted color if it is outside the specified range.
  /// Parameters minLightness and maxLightness should be in the range 0.0 to 1.0.
  /// This method uses the HSL color directly, which is more efficient than converting.
  static HSLColor ensureWithinRangeHsl(
    HSLColor hslColor, {
    double minLightness = 0.2,
    double maxLightness = 0.8,
  }) {
    double lightness = hslColor.lightness;
    if (lightness < minLightness) {
      // Too dark
      return hslColor.withLightness(minLightness);
    } else if (lightness > maxLightness) {
      // Too light
      return hslColor.withLightness(maxLightness);
    }
    // Within range, return unchanged
    return hslColor;
  }

  /// Returns a "dimmed" version of the provided color.
  /// The dimFactor (between 0.0 and 1.0) indicates how much to reduce the
  /// color's lightness.
  static HSLColor dimColorHsl(HSLColor hslColor, {double dimFactor = 0.1}) {
    final newLightness = (hslColor.lightness - dimFactor).clamp(0.0, 1.0);
    return hslColor.withLightness(newLightness);
  }
}
