import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:flutter_portfolio/core/widgets/common/responsive_text.dart';

enum ButtonVariant {
  primary,
  secondary,
  outlined,
  text,
  ghost,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class ResponsiveButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? minWidth;
  final double? maxWidth;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Widget? icon;
  final bool iconAfter;
  final double? iconSpacing;

  // Animation options
  final bool enableHoverAnimation;
  final bool enableScaleAnimation;
  final bool enableRippleEffect;
  final Duration animationDuration;
  final Curve animationCurve;
  final double hoverScale;
  final double pressedScale;
  final Color? hoverColor;
  final double hoverElevation;
  final bool enableLoadingState;
  final bool isLoading;

  const ResponsiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.minWidth,
    this.maxWidth,
    this.padding,
    this.borderRadius,
    this.icon,
    this.iconAfter = false,
    this.iconSpacing,

    // Animation defaults
    this.enableHoverAnimation = true,
    this.enableScaleAnimation = true,
    this.enableRippleEffect = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.hoverScale = 1.02,
    this.pressedScale = 0.98,
    this.hoverColor,
    this.hoverElevation = 4.0,
    this.enableLoadingState = false,
    this.isLoading = false,
  });

  @override
  State<ResponsiveButton> createState() => _ResponsiveButtonState();
}

class _ResponsiveButtonState extends State<ResponsiveButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _hoverAnimation;
  late Animation<double> _elevationAnimation;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _hoverController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.hoverScale,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: widget.animationCurve,
    ));

    _hoverAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: widget.animationCurve,
    ));

    _elevationAnimation = Tween<double>(
      begin: _getBaseElevation(),
      end: widget.hoverElevation,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: widget.animationCurve,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  double _getBaseElevation() {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return 2.0;
      case ButtonVariant.secondary:
        return 1.0;
      case ButtonVariant.outlined:
      case ButtonVariant.text:
      case ButtonVariant.ghost:
        return 0.0;
    }
  }

  EdgeInsets _getResponsivePadding(BuildContext context) {
    if (widget.padding != null) return widget.padding!;

    final basePadding = switch (widget.size) {
      ButtonSize.small => context.responsiveValue<EdgeInsets>(
          mobile: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          tablet: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          desktop: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ButtonSize.medium => context.responsiveValue<EdgeInsets>(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          tablet: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ButtonSize.large => context.responsiveValue<EdgeInsets>(
          mobile: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          desktop: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        ),
    };

    // Adjust padding if icon is present
    if (widget.icon != null) {
      final iconSpacing = widget.iconSpacing ?? _getIconSpacing(context);
      if (widget.iconAfter) {
        return basePadding.copyWith(right: basePadding.right - iconSpacing / 2);
      } else {
        return basePadding.copyWith(left: basePadding.left - iconSpacing / 2);
      }
    }

    return basePadding;
  }

  double _getResponsiveMinWidth(BuildContext context) {
    if (widget.minWidth != null) return widget.minWidth!;

    return switch (widget.size) {
      ButtonSize.small => context.responsiveValue<double>(
          mobile: 80.0,
          tablet: 90.0,
          desktop: 100.0,
        ),
      ButtonSize.medium => context.responsiveValue<double>(
          mobile: 120.0,
          tablet: 140.0,
          desktop: 160.0,
        ),
      ButtonSize.large => context.responsiveValue<double>(
          mobile: 140.0,
          tablet: 160.0,
          desktop: 180.0,
        ),
    };
  }

  double _getIconSpacing(BuildContext context) {
    return switch (widget.size) {
      ButtonSize.small => context.responsiveValue<double>(
          mobile: 6.0,
          tablet: 7.0,
          desktop: 8.0,
        ),
      ButtonSize.medium => context.responsiveValue<double>(
          mobile: 8.0,
          tablet: 9.0,
          desktop: 10.0,
        ),
      ButtonSize.large => context.responsiveValue<double>(
          mobile: 10.0,
          tablet: 11.0,
          desktop: 12.0,
        ),
    };
  }

  double _getIconSize(BuildContext context) {
    return switch (widget.size) {
      ButtonSize.small => context.responsiveValue<double>(
          mobile: 16.0,
          tablet: 17.0,
          desktop: 18.0,
        ),
      ButtonSize.medium => context.responsiveValue<double>(
          mobile: 18.0,
          tablet: 19.0,
          desktop: 20.0,
        ),
      ButtonSize.large => context.responsiveValue<double>(
          mobile: 20.0,
          tablet: 21.0,
          desktop: 22.0,
        ),
    };
  }

  (double, double, double) _getFontSizes() {
    return switch (widget.size) {
      ButtonSize.small => (12.0, 13.0, 14.0),
      ButtonSize.medium => (14.0, 15.0, 16.0),
      ButtonSize.large => (16.0, 17.0, 18.0),
    };
  }

  void _handleHover(bool isHovered) {
    if (!widget.enableHoverAnimation) return;

    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _hoverController.forward();
      if (widget.enableScaleAnimation) {
        _scaleController.forward();
      }
    } else {
      _hoverController.reverse();
      if (widget.enableScaleAnimation) {
        _scaleController.reverse();
      }
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enableScaleAnimation) return;

    setState(() {
      _isPressed = true;
    });

    _scaleController.animateTo(widget.pressedScale);
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enableScaleAnimation) return;

    setState(() {
      _isPressed = false;
    });

    if (_isHovered) {
      _scaleController.animateTo(widget.hoverScale);
    } else {
      _scaleController.reverse();
    }
  }

  void _handleTapCancel() {
    if (!widget.enableScaleAnimation) return;

    setState(() {
      _isPressed = false;
    });

    if (_isHovered) {
      _scaleController.animateTo(widget.hoverScale);
    } else {
      _scaleController.reverse();
    }
  }

  ButtonStyle _getButtonStyle(BuildContext context, ThemeData theme) {
    final responsivePadding = _getResponsivePadding(context);
    final responsiveMinWidth = _getResponsiveMinWidth(context);
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(8);

    return switch (widget.variant) {
      ButtonVariant.primary => ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor ?? theme.colorScheme.primary,
          foregroundColor: widget.textColor ?? theme.colorScheme.onPrimary,
          padding: responsivePadding,
          minimumSize: Size(responsiveMinWidth, 0),
          maximumSize: widget.maxWidth != null
              ? Size(widget.maxWidth!, double.infinity)
              : null,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          elevation: _getBaseElevation(),
        ),
      ButtonVariant.secondary => ElevatedButton.styleFrom(
          backgroundColor:
              widget.backgroundColor ?? theme.colorScheme.secondary,
          foregroundColor: widget.textColor ?? theme.colorScheme.onSecondary,
          padding: responsivePadding,
          minimumSize: Size(responsiveMinWidth, 0),
          maximumSize: widget.maxWidth != null
              ? Size(widget.maxWidth!, double.infinity)
              : null,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          elevation: _getBaseElevation(),
        ),
      ButtonVariant.outlined => OutlinedButton.styleFrom(
          foregroundColor: widget.textColor ?? theme.colorScheme.primary,
          padding: responsivePadding,
          minimumSize: Size(responsiveMinWidth, 0),
          maximumSize: widget.maxWidth != null
              ? Size(widget.maxWidth!, double.infinity)
              : null,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          side: BorderSide(
            color: widget.borderColor ??
                widget.backgroundColor ??
                theme.colorScheme.primary,
          ),
        ),
      ButtonVariant.text => TextButton.styleFrom(
          foregroundColor: widget.textColor ?? theme.colorScheme.primary,
          padding: responsivePadding,
          minimumSize: Size(responsiveMinWidth, 0),
          maximumSize: widget.maxWidth != null
              ? Size(widget.maxWidth!, double.infinity)
              : null,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
      ButtonVariant.ghost => TextButton.styleFrom(
          foregroundColor: widget.textColor ?? theme.colorScheme.onSurface,
          backgroundColor: Colors.transparent,
          padding: responsivePadding,
          minimumSize: Size(responsiveMinWidth, 0),
          maximumSize: widget.maxWidth != null
              ? Size(widget.maxWidth!, double.infinity)
              : null,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
    };
  }

  Widget _buildButtonContent(BuildContext context) {
    final (mobileFontSize, tabletFontSize, desktopFontSize) = _getFontSizes();
    final iconSize = _getIconSize(context);
    final iconSpacing = widget.iconSpacing ?? _getIconSpacing(context);

    if (widget.isLoading && widget.enableLoadingState) {
      return SizedBox(
        height: iconSize,
        width: iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.textColor ?? Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }

    final textWeight = switch (widget.size) {
      ButtonSize.small => TextWeight.medium,
      ButtonSize.medium => TextWeight.semiBold,
      ButtonSize.large => TextWeight.semiBold,
    };

    final textWidget = ResponsiveText(
      widget.text,
      variant: TextVariant.label,
      weight: textWeight,
      color: widget.textColor,
      mobileFontSize: mobileFontSize,
      tabletFontSize: tabletFontSize,
      desktopFontSize: desktopFontSize,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      enableHapticFeedback: false,
    );

    if (widget.icon == null) {
      return textWidget;
    }

    final iconWidget = SizedBox(
      width: iconSize,
      height: iconSize,
      child: IconTheme(
        data: IconThemeData(
          size: iconSize,
          color: widget.textColor ?? Theme.of(context).colorScheme.onPrimary,
        ),
        child: widget.icon!,
      ),
    );

    return widget.iconAfter
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: textWidget),
              SizedBox(width: iconSpacing),
              iconWidget,
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget,
              SizedBox(width: iconSpacing),
              Flexible(child: textWidget),
            ],
          );
  }

  Widget _buildButton(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = _getButtonStyle(context, theme);
    final content = _buildButtonContent(context);

    final button = switch (widget.variant) {
      ButtonVariant.primary || ButtonVariant.secondary => ElevatedButton(
          onPressed: (widget.isLoading && widget.enableLoadingState)
              ? null
              : widget.onPressed,
          style: buttonStyle,
          child: content,
        ),
      ButtonVariant.outlined => OutlinedButton(
          onPressed: (widget.isLoading && widget.enableLoadingState)
              ? null
              : widget.onPressed,
          style: buttonStyle,
          child: content,
        ),
      ButtonVariant.text || ButtonVariant.ghost => TextButton(
          onPressed: (widget.isLoading && widget.enableLoadingState)
              ? null
              : widget.onPressed,
          style: buttonStyle,
          child: content,
        ),
    };

    return button;
  }

  @override
  Widget build(BuildContext context) {
    Widget button = _buildButton(context);

    // Wrap with animations if enabled
    if (widget.enableScaleAnimation || widget.enableHoverAnimation) {
      button = AnimatedBuilder(
        animation: Listenable.merge(
            [_scaleAnimation, _hoverAnimation, _elevationAnimation]),
        builder: (context, child) {
          Widget animatedButton = child!;

          // Apply scale animation
          if (widget.enableScaleAnimation) {
            animatedButton = Transform.scale(
              scale: _scaleAnimation.value,
              child: animatedButton,
            );
          }

          // Apply hover color overlay
          if (widget.enableHoverAnimation && widget.hoverColor != null) {
            animatedButton = Container(
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
                color:
                    widget.hoverColor!.withOpacity(_hoverAnimation.value * 0.1),
              ),
              child: animatedButton,
            );
          }

          return animatedButton;
        },
        child: button,
      );

      // Add gesture detection for animations
      button = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: MouseRegion(
          onEnter: (_) => _handleHover(true),
          onExit: (_) => _handleHover(false),
          cursor: widget.onPressed != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: button,
        ),
      );
    }

    return button;
  }
}
