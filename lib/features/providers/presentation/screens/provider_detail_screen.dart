import 'package:flutter/material.dart';
import 'package:medifinder/core/theme/app_theme_extension.dart';
import 'package:medifinder/features/providers/domain/entities/provider_entity.dart';
import 'package:medifinder/features/providers/presentation/widgets/provider_avatar.dart';
import 'package:medifinder/features/providers/presentation/widgets/rating_stars.dart';

class ProviderDetailScreen extends StatefulWidget {
  const ProviderDetailScreen({super.key, required this.provider});

  final ProviderEntity? provider;

  @override
  State<ProviderDetailScreen> createState() => _ProviderDetailScreenState();
}

class _ProviderDetailScreenState extends State<ProviderDetailScreen> {
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    if (provider == null) {
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
        title: Text(provider.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: ext.spacingSm),
            child: FilledButton(
              onPressed: () => setState(() => _isFollowing = !_isFollowing),
              style: _isFollowing
                  ? FilledButton.styleFrom(
                      backgroundColor: colors.secondaryContainer,
                      foregroundColor: colors.onSecondaryContainer,
                    )
                  : null,
              child: Text(_isFollowing ? 'Following' : 'Follow'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(ext.spacingMd),
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Hero(
                  tag: provider.id,
                  child: ProviderAvatar(
                    name: provider.name,
                    imageUrl: provider.imageUrl,
                    radius: 52,
                  ),
                ),
                SizedBox(height: ext.spacingMd),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      provider.name,
                      style: text.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (provider.isVerified) ...[
                      SizedBox(width: ext.spacingXs),
                      Icon(Icons.verified_rounded, color: colors.primary, size: 22),
                    ],
                  ],
                ),
                SizedBox(height: ext.spacingXs),
                Text(
                  provider.specialty,
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
                      '${provider.city}, ${provider.country}',
                      style: text.bodyMedium
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
                SizedBox(height: ext.spacingSm),
                RatingStars(
                  rating: provider.rating,
                  reviewCount: provider.reviewCount,
                  starSize: 20,
                ),
              ],
            ),
          ),

          SizedBox(height: ext.spacingLg),

          // Contact section
          if (provider.phone != null || provider.website != null) ...[
            Text('Contact', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: ext.spacingXs),
            Card(
              child: Column(
                children: [
                  if (provider.phone != null)
                    ListTile(
                      leading: Icon(Icons.phone_outlined, color: colors.primary),
                      title: Text(provider.phone!),
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling: ${provider.phone}')),
                      ),
                    ),
                  if (provider.phone != null && provider.website != null)
                    Divider(height: 1, indent: ext.spacingLg + ext.spacingMd),
                  if (provider.website != null)
                    ListTile(
                      leading: Icon(Icons.language_outlined, color: colors.primary),
                      title: Text(
                        provider.website!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening: ${provider.website}')),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: ext.spacingLg),
          ],

          // Bio section
          if (provider.bio != null) ...[
            Text('About', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: ext.spacingXs),
            Card(
              child: Padding(
                padding: EdgeInsets.all(ext.spacingMd),
                child: Text(provider.bio!, style: text.bodyMedium),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
