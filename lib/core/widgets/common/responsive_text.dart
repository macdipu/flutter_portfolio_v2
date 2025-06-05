import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';

enum TextVariant {
  display, // Hero text, largest
  headline, // Section headings
  title, // Card titles, subsections
  body, // Regular paragraph text
  label, // Button labels, form labels
  caption, // Small descriptive text
}

enum TextWeight {
  light,
  regular,
  medium,
  semiBold,
  bold,
}

class ResponsiveText extends StatefulWidget {
  final String text;
  final TextVariant variant;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;

  // Responsive font sizes - if provided, override variant defaults
  final double? mobileFontSize;
  final double? tabletFontSize;
  final double? smallLaptopFontSize;
  final double? desktopFontSize;
  final double? largeDesktoFontSize;

  // Text behavior
  final bool enableInteractiveSelection;
  final bool enableCopyOnLongPress;
  final bool enableHapticFeedback;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function(String)? onSelectionChanged;

  // Styling options
  final TextWeight? weight;
  final Color? color;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height; // Line height multiplier
  final TextDecoration? decoration;
  final List<Shadow>? shadows;

  // Animation options
  final bool enableFadeIn;
  final bool enableTypeWriter;
  final Duration animationDuration;
  final Curve animationCurve;

  // Accessibility
  final String? semanticsLabel;
  final bool excludeFromSemantics;

  const ResponsiveText(
    this.text, {
    super.key,
    this.variant = TextVariant.body,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.mobileFontSize,
    this.tabletFontSize,
    this.smallLaptopFontSize,
    this.desktopFontSize,
    this.largeDesktoFontSize,
    this.enableInteractiveSelection = false,
    this.enableCopyOnLongPress = false,
    this.enableHapticFeedback = true,
    this.onTap,
    this.onLongPress,
    this.onSelectionChanged,
    this.weight,
    this.color,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.decoration,
    this.shadows,
    this.enableFadeIn = false,
    this.enableTypeWriter = false,
    this.animationDuration = const Duration(milliseconds: 800),
    this.animationCurve = Curves.easeOut,
    this.semanticsLabel,
    this.excludeFromSemantics = false,
  });

  // Named constructors for common use cases
  const ResponsiveText.display(
    String text, {
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    Color? color,
    TextWeight? weight,
    bool enableFadeIn = false,
    VoidCallback? onTap,
    String? semanticsLabel,
  }) : this(
          text,
          key: key,
          variant: TextVariant.display,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          color: color,
          weight: weight,
          enableFadeIn: enableFadeIn,
          onTap: onTap,
          semanticsLabel: semanticsLabel,
        );

  const ResponsiveText.headline(
    String text, {
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    Color? color,
    TextWeight? weight,
    bool enableFadeIn = false,
    VoidCallback? onTap,
    String? semanticsLabel,
  }) : this(
          text,
          key: key,
          variant: TextVariant.headline,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          color: color,
          weight: weight,
          enableFadeIn: enableFadeIn,
          onTap: onTap,
          semanticsLabel: semanticsLabel,
        );

  const ResponsiveText.title(
    String text, {
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    Color? color,
    TextWeight? weight,
    VoidCallback? onTap,
    String? semanticsLabel,
  }) : this(
          text,
          key: key,
          variant: TextVariant.title,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          color: color,
          weight: weight,
          onTap: onTap,
          semanticsLabel: semanticsLabel,
        );

  const ResponsiveText.body(
    String text, {
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    Color? color,
    bool enableInteractiveSelection = false,
    VoidCallback? onTap,
    String? semanticsLabel,
  }) : this(
          text,
          key: key,
          variant: TextVariant.body,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          color: color,
          enableInteractiveSelection: enableInteractiveSelection,
          onTap: onTap,
          semanticsLabel: semanticsLabel,
        );

  const ResponsiveText.label(
    String text, {
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    Color? color,
    TextWeight? weight,
    VoidCallback? onTap,
    String? semanticsLabel,
  }) : this(
          text,
          key: key,
          variant: TextVariant.label,
          style: style,
          textAlign: textAlign,
          color: color,
          weight: weight,
          onTap: onTap,
          semanticsLabel: semanticsLabel,
        );

  const ResponsiveText.caption(
    String text, {
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    Color? color,
    VoidCallback? onTap,
    String? semanticsLabel,
  }) : this(
          text,
          key: key,
          variant: TextVariant.caption,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          color: color,
          onTap: onTap,
          semanticsLabel: semanticsLabel,
        );

  @override
  State<ResponsiveText> createState() => _ResponsiveTextState();
}

class _ResponsiveTextState extends State<ResponsiveText>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _typeWriterController;
  late Animation<double> _fadeAnimation;
  late Animation<int> _typeWriterAnimation;

  String _displayText = '';

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _typeWriterController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: widget.animationCurve,
    );

    _typeWriterAnimation = IntTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(
      parent: _typeWriterController,
      curve: widget.animationCurve,
    ))
      ..addListener(() {
        setState(() {
          _displayText = widget.text.substring(0, _typeWriterAnimation.value);
        });
      });

    // Start animations if enabled
    if (widget.enableFadeIn) {
      _fadeController.forward();
    }

    if (widget.enableTypeWriter) {
      _typeWriterController.forward();
    } else {
      _displayText = widget.text;
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _typeWriterController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ResponsiveText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text) {
      if (widget.enableTypeWriter) {
        _typeWriterController.reset();
        _typeWriterAnimation = IntTween(
          begin: 0,
          end: widget.text.length,
        ).animate(CurvedAnimation(
          parent: _typeWriterController,
          curve: widget.animationCurve,
        ))
          ..addListener(() {
            setState(() {
              _displayText =
                  widget.text.substring(0, _typeWriterAnimation.value);
            });
          });
        _typeWriterController.forward();
      } else {
        setState(() {
          _displayText = widget.text;
        });
      }
    }
  }

  (double, double, double, double, double) _getVariantFontSizes() {
    return switch (widget.variant) {
      TextVariant.display => (32.0, 40.0, 48.0, 56.0, 64.0),
      TextVariant.headline => (24.0, 28.0, 32.0, 36.0, 40.0),
      TextVariant.title => (18.0, 20.0, 22.0, 24.0, 26.0),
      TextVariant.body => (14.0, 16.0, 16.0, 18.0, 20.0),
      TextVariant.label => (12.0, 14.0, 14.0, 16.0, 16.0),
      TextVariant.caption => (10.0, 12.0, 12.0, 14.0, 14.0),
    };
  }

  FontWeight _getTextWeight() {
    final variantWeight = switch (widget.variant) {
      TextVariant.display => TextWeight.bold,
      TextVariant.headline => TextWeight.semiBold,
      TextVariant.title => TextWeight.medium,
      TextVariant.body => TextWeight.regular,
      TextVariant.label => TextWeight.medium,
      TextVariant.caption => TextWeight.regular,
    };

    final weight = widget.weight ?? variantWeight;

    return switch (weight) {
      TextWeight.light => FontWeight.w300,
      TextWeight.regular => FontWeight.w400,
      TextWeight.medium => FontWeight.w500,
      TextWeight.semiBold => FontWeight.w600,
      TextWeight.bold => FontWeight.w700,
    };
  }

  double _getResponsiveFontSize(BuildContext context) {
    final (mobile, tablet, smallLaptop, desktop, largeDesktop) =
        _getVariantFontSizes();

    return context.responsive<double>(
      mobile: widget.mobileFontSize ?? mobile,
      tablet: widget.tabletFontSize ?? tablet,
      smallLaptop: widget.smallLaptopFontSize ?? smallLaptop,
      desktop: widget.desktopFontSize ?? desktop,
      largeDesktop: widget.largeDesktoFontSize ?? largeDesktop,
    );
  }

  TextStyle _buildTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final responsiveFontSize = _getResponsiveFontSize(context);
    final fontWeight = _getTextWeight();

    // Base style from theme based on variant
    final baseStyle = switch (widget.variant) {
      TextVariant.display => theme.textTheme.displayLarge,
      TextVariant.headline => theme.textTheme.headlineMedium,
      TextVariant.title => theme.textTheme.titleLarge,
      TextVariant.body => theme.textTheme.bodyLarge,
      TextVariant.label => theme.textTheme.labelLarge,
      TextVariant.caption => theme.textTheme.bodySmall,
    };

    return baseStyle
            ?.copyWith(
              fontSize: responsiveFontSize,
              fontWeight: fontWeight,
              color: widget.color,
              letterSpacing: widget.letterSpacing,
              wordSpacing: widget.wordSpacing,
              height: widget.height,
              decoration: widget.decoration,
              shadows: widget.shadows,
            )
            .merge(widget.style) ??
        TextStyle(
          fontSize: responsiveFontSize,
          fontWeight: fontWeight,
          color: widget.color,
          letterSpacing: widget.letterSpacing,
          wordSpacing: widget.wordSpacing,
          height: widget.height,
          decoration: widget.decoration,
          shadows: widget.shadows,
        ).merge(widget.style);
  }

  void _handleLongPress() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    if (widget.enableCopyOnLongPress) {
      Clipboard.setData(ClipboardData(text: widget.text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Text copied to clipboard'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    widget.onLongPress?.call();
  }

  void _handleTap() {
    if (widget.enableHapticFeedback && widget.onTap != null) {
      HapticFeedback.lightImpact();
    }
    widget.onTap?.call();
  }

  Widget _buildText(BuildContext context) {
    final textStyle = _buildTextStyle(context);
    final displayText = widget.enableTypeWriter ? _displayText : widget.text;

    if (widget.enableInteractiveSelection) {
      return SelectableText(
        displayText,
        style: textStyle,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        onSelectionChanged: (selection, cause) {
          final selectedText = displayText.substring(
            selection.start,
            selection.end,
          );
          widget.onSelectionChanged?.call(selectedText);
        },
        onTap: _handleTap,
      );
    }

    Widget textWidget = Text(
      displayText,
      style: textStyle,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
      softWrap: widget.softWrap,
      semanticsLabel: widget.semanticsLabel,
    );

    if (widget.onTap != null ||
        widget.onLongPress != null ||
        widget.enableCopyOnLongPress) {
      textWidget = GestureDetector(
        onTap: widget.onTap != null ? _handleTap : null,
        onLongPress:
            (widget.onLongPress != null || widget.enableCopyOnLongPress)
                ? _handleLongPress
                : null,
        child: textWidget,
      );
    }

    if (widget.excludeFromSemantics) {
      textWidget = ExcludeSemantics(child: textWidget);
    }

    return textWidget;
  }

  @override
  Widget build(BuildContext context) {
    Widget textWidget = _buildText(context);

    // Apply fade in animation
    if (widget.enableFadeIn) {
      textWidget = FadeTransition(
        opacity: _fadeAnimation,
        child: textWidget,
      );
    }

    return textWidget;
  }
}
