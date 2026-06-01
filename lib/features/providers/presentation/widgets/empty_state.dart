import 'package:flutter/material.dart';
import 'package:medifinder/core/theme/app_theme_extension.dart';
import 'package:medifinder/l10n/app_localizations.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.onClearFilters});

  final VoidCallback onClearFilters;

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
            Icon(Icons.search_off_rounded, size: 64, color: colors.onSurfaceVariant),
            SizedBox(height: ext.spacingMd),
            Text(
              l10n.emptyStateTitle,
              style: text.titleMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            SizedBox(height: ext.spacingSm),
            Text(
              l10n.emptyStateMessage,
              style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ext.spacingLg),
            FilledButton(
              onPressed: onClearFilters,
              child: Text(l10n.clearFiltersButton),
            ),
          ],
        ),
      ),
    );
  }
}
