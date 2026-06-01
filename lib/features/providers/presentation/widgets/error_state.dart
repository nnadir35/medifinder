import 'package:flutter/material.dart';
import 'package:medifinder/core/theme/app_theme_extension.dart';
import 'package:medifinder/l10n/app_localizations.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(ext.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: colors.error),
            SizedBox(height: ext.spacingMd),
            Text(
              l10n.errorStateTitle,
              style: text.titleMedium?.copyWith(color: colors.error),
            ),
            SizedBox(height: ext.spacingSm),
            Text(
              message,
              style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ext.spacingLg),
            OutlinedButton(
              onPressed: onRetry,
              child: Text(l10n.retryButton),
            ),
          ],
        ),
      ),
    );
  }
}
