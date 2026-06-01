import 'package:flutter/material.dart';
import 'package:medifinder/core/theme/app_theme_extension.dart';
import 'package:medifinder/features/providers/domain/entities/provider_entity.dart';
import 'package:medifinder/features/providers/presentation/widgets/provider_avatar.dart';
import 'package:medifinder/features/providers/presentation/widgets/rating_stars.dart';

class ProviderCard extends StatelessWidget {
  const ProviderCard({
    super.key,
    required this.provider,
    required this.onTap,
  });

  final ProviderEntity provider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: ext.spacingMd,
        vertical: ext.spacingSm / 2,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ext.radiusMd),
        child: Padding(
          padding: EdgeInsets.all(ext.spacingMd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: provider.id,
                child: ProviderAvatar(
                  name: provider.name,
                  imageUrl: provider.imageUrl,
                  radius: 30,
                ),
              ),
              SizedBox(width: ext.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            provider.name,
                            style: text.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (provider.isVerified) ...[
                          SizedBox(width: ext.spacingXs),
                          Icon(
                            Icons.verified_rounded,
                            size: 18,
                            color: colors.primary,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: ext.spacingXs),
                    Chip(
                      label: Text(
                        provider.specialty,
                        style: text.labelSmall,
                      ),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    SizedBox(height: ext.spacingXs),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: colors.onSurfaceVariant,
                        ),
                        SizedBox(width: ext.spacingXs / 2),
                        Expanded(
                          child: Text(
                            '${provider.city}, ${provider.country}',
                            style: text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ext.spacingXs),
                    RatingStars(
                      rating: provider.rating,
                      reviewCount: provider.reviewCount,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
