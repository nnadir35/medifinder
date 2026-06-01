import 'package:flutter/material.dart';
import 'package:medifinder/core/theme/app_theme_extension.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.onClearFilters});

  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(ext.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: colors.onSurfaceVariant),
            SizedBox(height: ext.spacingMd),
            Text(
              'No providers found',
              style: text.titleMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            SizedBox(height: ext.spacingSm),
            Text(
              'Try adjusting your search or filters.',
              style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ext.spacingLg),
            FilledButton(
              onPressed: onClearFilters,
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
