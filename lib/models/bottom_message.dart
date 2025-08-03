import 'package:flutter/material.dart';

enum BottomSheetType { error, info }

class AppBottomSheet {
  static Future<void> show(
    BuildContext context, {
    required String message,
    String? title,
    BottomSheetType type = BottomSheetType.error,
    IconData? icon,
  }) {
    final theme = Theme.of(context);
    final bool isError = type == BottomSheetType.error;

    final color = isError ? theme.colorScheme.error : theme.colorScheme.primary;

    final onColor = isError
        ? theme.colorScheme.onError
        : theme.colorScheme.onPrimary;

    final usedIcon =
        icon ?? (isError ? Icons.error_outline : Icons.check_circle_outline);

    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Icon(usedIcon, size: 48, color: color),

              const SizedBox(height: 12),

              Text(
                message,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: onColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
