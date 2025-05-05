import 'package:flutter/material.dart';

enum ButtonType {
  primary,
  secondary,
  destructive,
  outline,
  ghost,
  link,
  gradient
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonType type;
  final Icon? icon;
  final bool isLoading;

  const CustomButton({
    required this.label,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(width: 8),
        ],
        Text(label),
      ],
    );

    if (isLoading) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox.square(
            dimension: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white, // Uses primaryForeground color
            ),
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }

    switch (type) {
      case ButtonType.secondary:
        return ShadButton.secondary(child: child, onPressed: onPressed);
      case ButtonType.destructive:
        return ShadButton.destructive(child: child, onPressed: onPressed);
      case ButtonType.outline:
        return ShadButton.outline(child: child, onPressed: onPressed);
      case ButtonType.ghost:
        return ShadButton.ghost(child: child, onPressed: onPressed);
      case ButtonType.link:
        return ShadButton.link(child: child, onPressed: onPressed);
      case ButtonType.gradient:
        return ShadButton(
          onPressed: onPressed,
          gradient: const LinearGradient(colors: [Colors.cyan, Colors.indigo]),
          shadows: [
            BoxShadow(
              color: Colors.blue.withOpacity(.4),
              spreadRadius: 4,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          child: child,
        );
      default:
        return ShadButton(child: child, onPressed: onPressed);
    }
  }
}
