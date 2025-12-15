import 'package:flutter/material.dart';
import 'package:flutter_portfolio/features/portfolio/data/models/profile_model.dart';

class SiteConfigScope extends InheritedWidget {
  final SiteConfigModel config;

  const SiteConfigScope({
    super.key,
    required this.config,
    required super.child,
  });

  static SiteConfigModel of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<SiteConfigScope>();
    assert(scope != null, 'SiteConfigScope not found in context');
    return scope!.config;
  }

  static SiteConfigModel? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SiteConfigScope>()
        ?.config;
  }

  @override
  bool updateShouldNotify(covariant SiteConfigScope oldWidget) {
    return oldWidget.config != config;
  }
}

