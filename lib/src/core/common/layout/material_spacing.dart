import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// {@template material_spacer}
/// A spacer refers to the space between two panes in a layout.
///
/// Spacers measure 24dp wide.
/// {@endtemplate}
class const MaterialSpacer({
  super.key,

  /// Creates a spacer that is 24dp wide.
  final double spacing = 24,
}) extends StatelessWidget {
  /// {@macro material_spacer}
  this;

  @override
  Widget build(BuildContext context) => SizedBox(width: spacing);
}

/// {@template horizontal_spacing}
/// Spacing that is applied to element to both the left and right.
/// {@endtemplate}
class const HorizontalSpacing._(double value) extends EdgeInsets {
  this : super.symmetric(horizontal: value);

  /// Horizontal spacing for WindowSize.compact
  const new compact() : this._(16);

  /// Horizontal spacing for WindowSize.medium+.
  const new mediumUp() : this._(24);

  /// Spacing that is used to center
  /// the element and keep at width of [maxWidth]
  ///
  /// [windowWidth] is the width of a window.
  factory centered(double windowWidth, [double maxWidth = 768]) =>
      HorizontalSpacing._(math.max((windowWidth - maxWidth) / 2, 16));
}
