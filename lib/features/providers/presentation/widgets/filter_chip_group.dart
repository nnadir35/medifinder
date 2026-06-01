import 'package:flutter/material.dart';
import 'package:medifinder/core/theme/app_theme_extension.dart';

class FilterChipGroup extends StatelessWidget {
  const FilterChipGroup({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  final String title;
  final List<String> options;
  final List<String> selected;
  final void Function(String option) onToggle;

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: ext.spacingXs),
        Wrap(
          spacing: ext.spacingSm,
          runSpacing: ext.spacingXs,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onToggle(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}
