import 'package:flutter/material.dart';

class LessonNavButtons extends StatelessWidget {
  final String previousLabel;
  final String nextLabel;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final Color previousEnabledColor;
  final Color previousDisabledColor;
  final Color previousEnabledTextColor;
  final Color previousDisabledTextColor;
  final Color nextEnabledColor;
  final Color nextDisabledColor;
  final Color nextTextColor;
  final double spacing;
  final double buttonHeight;
  final double borderRadius;
  final TextStyle textStyle;

  const LessonNavButtons({
    super.key,
    this.previousLabel = 'Previous',
    this.nextLabel = 'Next',
    required this.onPrevious,
    required this.onNext,
    this.previousEnabledColor = Colors.orange,
    this.previousDisabledColor = const Color(0xFFE0E0E0),
    this.previousEnabledTextColor = Colors.white,
    this.previousDisabledTextColor = const Color(0xFF757575),
    this.nextEnabledColor = const Color(0xFF1F8A9E),
    this.nextDisabledColor = const Color(0xFFE0E0E0),
    this.nextTextColor = Colors.white,
    this.spacing = 18,
    this.buttonHeight = 62,
    this.borderRadius = 30,
    this.textStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w800,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _LessonNavButton(
            label: previousLabel,
            backgroundColor:
                onPrevious == null ? previousDisabledColor : previousEnabledColor,
            foregroundColor:
                onPrevious == null
                    ? previousDisabledTextColor
                    : previousEnabledTextColor,
            onTap: onPrevious,
            buttonHeight: buttonHeight,
            borderRadius: borderRadius,
            textStyle: textStyle,
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: _LessonNavButton(
            label: nextLabel,
            backgroundColor:
                onNext == null ? nextDisabledColor : nextEnabledColor,
            foregroundColor: nextTextColor,
            onTap: onNext,
            buttonHeight: buttonHeight,
            borderRadius: borderRadius,
            textStyle: textStyle,
          ),
        ),
      ],
    );
  }
}

class _LessonNavButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onTap;
  final double buttonHeight;
  final double borderRadius;
  final TextStyle textStyle;

  const _LessonNavButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
    required this.buttonHeight,
    required this.borderRadius,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: onTap == null ? 0 : 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          label,
          style: textStyle,
        ),
      ),
    );
  }
}
