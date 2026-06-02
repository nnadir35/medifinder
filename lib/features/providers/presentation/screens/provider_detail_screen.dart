import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medifinder/core/theme/app_theme_extension.dart';
import 'package:medifinder/core/utils/specialty_l10n.dart';
import 'package:medifinder/l10n/app_localizations.dart';
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
      final l10n = AppLocalizations.of(context)!;
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.providerNotFound)),
      );
    }

    final ext = context.appTheme;

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
          _ProviderHeader(provider: p),
          SizedBox(height: ext.spacingLg),
          _ContactSection(provider: p),
          if (p.bio != null) _BioSection(bio: p.bio!),
        ],
      ),
    );
  }
}

class _ProviderHeader extends StatelessWidget {
  const _ProviderHeader({required this.provider});

  final ProviderEntity provider;

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Center(
      child: Column(
        children: [
          Hero(
            tag: provider.id,
            child: ProviderAvatar(
              name: provider.name,
              imageUrl: provider.imageUrl,
              radius: 52.r,
            ),
          ),
          SizedBox(height: ext.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                provider.name,
                style: text.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: ext.spacingXs),
          Text(
            AppLocalizations.of(context)!.localizeSpecialty(provider.specialty),
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
                style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
          SizedBox(height: ext.spacingSm),
          RatingStars(
            rating: provider.rating,
            reviewCount: provider.reviewCount,
            starSize: 20.r,
          ),
        ],
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({required this.provider});

  final ProviderEntity provider;

  @override
  Widget build(BuildContext context) {
    if (provider.phone == null && provider.website == null) {
      return const SizedBox.shrink();
    }

    final ext = context.appTheme;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.contactSectionTitle,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: ext.spacingXs),
        Card(
          child: Column(
            children: [
              if (provider.phone != null)
                ListTile(
                  leading: Icon(Icons.phone_outlined, color: colors.primary),
                  title: Text(provider.phone!),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.callingSnackbar(provider.phone!))),
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
                    SnackBar(content: Text(AppLocalizations.of(context)!.openingSnackbar(provider.website!))),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: ext.spacingLg),
      ],
    );
  }
}

class _BioSection extends StatelessWidget {
  const _BioSection({required this.bio});

  final String bio;

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.aboutSectionTitle,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: ext.spacingXs),
        Card(
          child: Padding(
            padding: EdgeInsets.all(ext.spacingMd),
            child: Text(bio, style: text.bodyMedium),
          ),
        ),
      ],
    );
  }
}
