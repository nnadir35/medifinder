import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medifinder/core/theme/app_theme_extension.dart';
import 'package:medifinder/core/utils/specialty_l10n.dart';
import 'package:medifinder/features/providers/domain/entities/provider_entity.dart';
import 'package:medifinder/features/providers/presentation/widgets/provider_avatar.dart';
import 'package:medifinder/features/providers/presentation/widgets/rating_stars.dart';
import 'package:medifinder/l10n/app_localizations.dart';

class ProviderCard extends StatelessWidget {
  const ProviderCard({super.key, required this.provider, required this.onTap});

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
            children: [
              Center(
                child: Hero(
                  tag: provider.id,
                  child: ProviderAvatar(
                    name: provider.name,
                    imageUrl: provider.imageUrl,
                    radius: 32.r,
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
                ],
              ),
              SizedBox(height: 2.r),
              Text(
                AppLocalizations.of(
                  context,
                )!.localizeSpecialty(provider.specialty),
                style: text.bodySmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6.r),
              RatingStars(
                rating: provider.rating,
                reviewCount: provider.reviewCount,
                starSize: 12.r,
              ),
              SizedBox(height: 4.r),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 12.r,
                    color: colors.onSurfaceVariant,
                  ),
                  SizedBox(width: 2.r),
                  Expanded(
                    child: Text(
                      '${provider.city}, ${provider.country}',
                      style: text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontSize: 11.sp,
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
