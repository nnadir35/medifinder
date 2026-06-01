import 'package:flutter/material.dart';
import 'package:medifinder/core/theme/app_theme_extension.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.reviewCount,
    this.starSize = 16,
  });

  final double rating;
  final int? reviewCount;
  final double starSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          final filled = i + 1 <= rating;
          final half = !filled && i < rating && rating - i >= 0.5;
          return Icon(
            filled
                ? Icons.star_rounded
                : half
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded,
            size: starSize,
            color: Colors.amber,
          );
        }),
        if (reviewCount != null) ...[
          SizedBox(width: Theme.of(context).extension<AppThemeExtension>()!.spacingXs),
          Text(
            '($reviewCount)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ],
    );
  }
}
