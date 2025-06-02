import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: padding ?? ResponsiveHelper.getResponsivePadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ??
                ResponsiveHelper.getResponsiveValue(
                  context: context,
                  mobile: double.infinity,
                  tablet: 800.0,
                  desktop: 1200.0,
                ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// lib/core/widgets/common/responsive_row.dart
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final bool reverseOnMobile;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 16.0,
    this.reverseOnMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        if (deviceType == DeviceType.mobile) {
          final columnChildren =
              reverseOnMobile ? children.reversed.toList() : children;
          return Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: columnChildren
                .map((child) => Padding(
                      padding: EdgeInsets.only(
                        bottom: columnChildren.last == child ? 0 : spacing,
                      ),
                      child: child,
                    ))
                .toList(),
          );
        }

        return Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: children
              .map((child) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: children.last == child ? 0 : spacing,
                      ),
                      child: child,
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}
