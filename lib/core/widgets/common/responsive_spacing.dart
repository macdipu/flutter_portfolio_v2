import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';

class ResponsiveSpacing extends StatelessWidget {
  final double scale;
  final Axis axis;

  const ResponsiveSpacing({
    super.key,
    this.scale = 1.0,
    this.axis = Axis.vertical,
  });

  const ResponsiveSpacing.horizontal({
    super.key,
    this.scale = 1.0,
  }) : axis = Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacingScale(scale);

    return SizedBox(
      width: axis == Axis.horizontal ? spacing : 0,
      height: axis == Axis.vertical ? spacing : 0,
    );
  }
}
