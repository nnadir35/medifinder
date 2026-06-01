import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medifinder/core/theme/app_theme_extension.dart';
import 'package:medifinder/features/providers/domain/entities/provider_entity.dart';
import 'package:medifinder/features/providers/presentation/widgets/provider_avatar.dart';
import 'package:medifinder/features/providers/presentation/widgets/rating_stars.dart';

class ProviderDetailScreen extends StatelessWidget {
  const ProviderDetailScreen({super.key, required this.provider});

  final ProviderEntity? provider;

  @override
  Widget build(BuildContext context) {
    final p = provider;
    if (p == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Provider not found.')),
      );
    }

    final ext = context.appTheme;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        leading: BackButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        actions: const [],
      ),
      body: ListView(
        padding: EdgeInsets.all(ext.spacingMd),
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Hero(
                  tag: p.id,
                  child: ProviderAvatar(
                    name: p.name,
                    imageUrl: p.imageUrl,
                    radius: 52,
                  ),
                ),
                SizedBox(height: ext.spacingMd),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      p.name,
                      style: text.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (p.isVerified) ...[
                      SizedBox(width: ext.spacingXs),
                      Icon(Icons.verified_rounded, color: colors.primary, size: 22),
                    ],
                  ],
                ),
                SizedBox(height: ext.spacingXs),
                Text(
                  p.specialty,
                  style: text.titleMedium?.copyWith(color: colors.primary),
                ),
                SizedBox(height: ext.spacingXs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 16, color: colors.onSurfaceVariant),
                    SizedBox(width: ext.spacingXs / 2),
                    Text(
                      '${p.city}, ${p.country}',
                      style: text.bodyMedium
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
                SizedBox(height: ext.spacingSm),
                RatingStars(
                  rating: p.rating,
                  reviewCount: p.reviewCount,
                  starSize: 20,
                ),
              ],
            ),
          ),

          SizedBox(height: ext.spacingLg),

          // Contact section
          if (p.phone != null || p.website != null) ...[
            Text('Contact', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: ext.spacingXs),
            Card(
              child: Column(
                children: [
                  if (p.phone != null)
                    ListTile(
                      leading: Icon(Icons.phone_outlined, color: colors.primary),
                      title: Text(p.phone!),
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling: ${p.phone}')),
                      ),
                    ),
                  if (p.phone != null && p.website != null)
                    Divider(height: 1, indent: ext.spacingLg + ext.spacingMd),
                  if (p.website != null)
                    ListTile(
                      leading: Icon(Icons.language_outlined, color: colors.primary),
                      title: Text(
                        p.website!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening: ${p.website}')),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: ext.spacingLg),
          ],

          // Bio section
          if (p.bio != null) ...[
            Text('About', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: ext.spacingXs),
            Card(
              child: Padding(
                padding: EdgeInsets.all(ext.spacingMd),
                child: Text(p.bio!, style: text.bodyMedium),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
