import 'package:flutter/material.dart';
import 'package:rash_decision/base/theme/palette.dart';

class AppGradient {
  static LinearGradient primary = LinearGradient(
    colors: [
      Palette.primaryColorLight,
      Palette.primaryColor,
      Palette.primaryColorDark,
    ],
    stops: [0.0, 0.5, 1.0],
    tileMode: TileMode.clamp,
  );
}
