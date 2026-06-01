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
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(ext.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Hero(
                  tag: provider.id,
                  child: ProviderAvatar(
                    name: provider.name,
                    imageUrl: provider.imageUrl,
                    radius: 32,
                  ),
                ),
              ),
              SizedBox(height: ext.spacingSm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      provider.name,
                      style: text.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (provider.isVerified)
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 1),
                      child: Icon(
                        Icons.verified_rounded,
                        size: 14,
                        color: colors.primary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                provider.specialty,
                style: text.bodySmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              RatingStars(
                rating: provider.rating,
                reviewCount: provider.reviewCount,
                starSize: 12,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 12,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      '${provider.city}, ${provider.country}',
                      style: text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
