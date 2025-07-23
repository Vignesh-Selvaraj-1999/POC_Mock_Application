import 'package:flutter/material.dart';

class TextStyles {
  // Medium Heading Styles
  static TextStyle mediumText({required Color color, required double fontSize, double? letterSpacing}) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w500,
        letterSpacing: letterSpacing ?? 0.5);
  }

  // Bold Heading Styles
  static TextStyle boldText({required Color color, required double fontSize, double? letterSpacing}) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w700,
    );
  }

  // Extra Bold Heading
  static TextStyle extraBoldText({required Color color, required double fontSize, double? letterSpacing}) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w800,
        letterSpacing: letterSpacing ?? 0.5);
  }

  // Semi-Bold Heading
  static TextStyle semiBoldText({required Color color, required double fontSize, double? letterSpacing}) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w600,
        letterSpacing: letterSpacing ?? 0.5);
  }

  // Regular Text Styles
  static TextStyle regularText({required Color color, required double fontSize, double? letterSpacing}) {
    return TextStyle(
        fontSize: fontSize ?? 12,
        color: color,
        fontWeight: FontWeight.normal,
        letterSpacing: letterSpacing ?? 0.5);
  }

  // Lite Text Styles
  static TextStyle lightText({required Color color, required double fontSize, double? letterSpacing}) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w300,
        letterSpacing: letterSpacing ?? 0.5);
  }

  //Extra Lite Text Styles
  static TextStyle extraLightText({required Color color, required double fontSize, double? letterSpacing}) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w100,
        letterSpacing: letterSpacing ?? 0.5);
  }
}
