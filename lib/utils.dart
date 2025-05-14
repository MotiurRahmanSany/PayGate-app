import 'package:flutter/material.dart';

/// Shows a dynamic snackbar with various customization options
enum SnackBarType { info, success, error, warning }

void showDynamicSnackBar({
  required BuildContext context,
  required String message,
  String? title,
  SnackBarType type = SnackBarType.info,
  Duration duration = const Duration(seconds: 3),
  SnackBarAction? action,
  double? width,
  EdgeInsetsGeometry? margin,
  bool floating = true,
  VoidCallback? onVisible,
}) {
  final theme = Theme.of(context);

  Color backgroundColor;
  Color textColor = Colors.white;
  IconData icon;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green.shade800;
      icon = Icons.check_circle;
      break;
    case SnackBarType.error:
      backgroundColor = Colors.red.shade800;
      icon = Icons.error;
      break;
    case SnackBarType.warning:
      backgroundColor = Colors.orange.shade800;
      icon = Icons.warning;
      break;
    case SnackBarType.info:
      backgroundColor = theme.primaryColor;
      icon = Icons.info;
      break;
  }

  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(icon, color: textColor),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Text(message, style: TextStyle(color: textColor)),
            ],
          ),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    behavior: floating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
    duration: duration,
    margin: margin,
    width: width,
    action: action,
    onVisible: onVisible,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
