import 'package:flutter/widgets.dart';

/// Small dimensions helper inspired by project conventions.
/// Use `Dimensions.of(context)` to get sizes relative to screen width.
class Dimensions {
  final BuildContext context;
  final double screenWidth;
  final double screenHeight;

  Dimensions._(this.context)
      : screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;

  static Dimensions of(BuildContext context) => Dimensions._(context);

  /// Example helpers
  double wp(double percent) => screenWidth * percent / 100;
  double hp(double percent) => screenHeight * percent / 100;
}
