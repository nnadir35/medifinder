import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medifinder/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:medifinder/core/theme/app_theme_extension.dart';
import 'package:medifinder/core/utils/constants.dart';
import 'package:medifinder/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:medifinder/features/providers/presentation/bloc/provider_bloc.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_event.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_state.dart';
import 'package:medifinder/features/providers/presentation/widgets/empty_state.dart';
import 'package:medifinder/features/providers/presentation/widgets/error_state.dart';
import 'package:medifinder/features/providers/presentation/widgets/filter_sheet.dart';
import 'package:medifinder/features/providers/presentation/widgets/loading_shimmer.dart';
import 'package:medifinder/features/providers/presentation/widgets/provider_card.dart';

class ProviderListScreen extends StatefulWidget {
  const ProviderListScreen({super.key});

  @override
  State<ProviderListScreen> createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet(BuildContext context, ProviderLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (_) => BlocProvider.value(
            value: context.read<ProviderBloc>(),
            child: FilterSheet(loadedState: state),
          ),
    );
  }

  Future<void> _toggleLocale() async {
    final current = localeNotifier.value.languageCode;
    final next = current == 'en' ? 'tr' : 'en';
    localeNotifier.value = Locale(next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.localeKey, next);
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: CustomScrollView(
          slivers: [
            _buildHeroHeader(context, ext, colors),
            SliverToBoxAdapter(child: _buildSearchBar(context, ext)),
            SliverToBoxAdapter(child: _buildFilterBar(context, ext, colors)),
            _buildResultsHeader(context, ext, colors),
            _buildProviderGrid(context, ext),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(
    BuildContext context,
    AppThemeExtension ext,
    ColorScheme colors,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B2FF7), Color(0xFF9C4DFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.fromLTRB(
          ext.spacingMd,
          MediaQuery.of(context).padding.top + ext.spacingMd,
          ext.spacingMd,
          ext.spacingLg,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.heroTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: ext.spacingSm),
                  Text(
                    l10n.heroSubtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            // Language toggle button
            ValueListenableBuilder<Locale>(
              valueListenable: localeNotifier,
              builder: (context, locale, _) {
                return IconButton(
                  icon: const Icon(Icons.language_rounded, color: Colors.white),
                  tooltip: l10n.tooltipLanguage,
                  onPressed: _toggleLocale,
                );
              },
            ),
            // Theme toggle button
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeModeNotifier,
              builder: (context, mode, _) {
                final isDark = mode == ThemeMode.dark;
                return IconButton(
                  icon: Icon(
                    isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    color: Colors.white,
                  ),
                  tooltip:
                      isDark ? l10n.tooltipLightMode : l10n.tooltipDarkMode,
                  onPressed: () async {
                    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
                    themeModeNotifier.value = newMode;
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString(
                      AppConstants.themeModeKey,
                      newMode == ThemeMode.dark ? 'dark' : 'light',
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, AppThemeExtension ext) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        ext.spacingMd,
        ext.spacingMd,
        ext.spacingMd,
        ext.spacingXs,
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: l10n.searchHint,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: BlocBuilder<ProviderBloc, ProviderState>(
            builder: (context, state) {
              final hasQuery = _searchController.text.isNotEmpty;
              if (!hasQuery) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  _searchController.clear();
                  context.read<ProviderBloc>().add(
                    const ProviderSearchChanged(''),
                  );
                },
              );
            },
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ext.radiusMd),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged:
            (q) => context.read<ProviderBloc>().add(ProviderSearchChanged(q)),
      ),
    );
  }

  Widget _buildFilterBar(
    BuildContext context,
    AppThemeExtension ext,
    ColorScheme colors,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ProviderBloc, ProviderState>(
      buildWhen: (prev, curr) {
        if (prev is ProviderLoaded && curr is ProviderLoaded) {
          return prev.activeFilter != curr.activeFilter;
        }
        return true;
      },
      builder: (context, state) {
        final loaded = state is ProviderLoaded ? state : null;
        final filter = loaded?.activeFilter;

        final categoryChips = <({String label, String type})>[];
        if (filter != null) {
          if (filter.selectedCountries.isNotEmpty) {
            final all = filter.selectedCountries;
            final label =
                all.length == 1
                    ? all.first
                    : '${all.take(2).join(', ')}${all.length > 2 ? ' +${all.length - 2}' : ''}';
            categoryChips.add((label: label, type: 'country'));
          }
          if (filter.selectedCities.isNotEmpty) {
            final all = filter.selectedCities;
            final label =
                all.length == 1
                    ? all.first
                    : '${all.take(2).join(', ')}${all.length > 2 ? ' +${all.length - 2}' : ''}';
            categoryChips.add((label: label, type: 'city'));
          }
          if (filter.selectedSpecialties.isNotEmpty) {
            final all = filter.selectedSpecialties;
            final label =
                all.length == 1
                    ? all.first
                    : '${all.take(2).join(', ')}${all.length > 2 ? ' +${all.length - 2}' : ''}';
            categoryChips.add((label: label, type: 'specialty'));
          }
        }

        return Padding(
          padding: EdgeInsets.symmetric(vertical: ext.spacingXs),
          child: SizedBox(
            height: 42.r,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: ext.spacingMd),
                  child: OutlinedButton.icon(
                    onPressed:
                        loaded != null
                            ? () => _openFilterSheet(context, loaded)
                            : null,
                    icon: Badge(
                      isLabelVisible: loaded?.hasActiveFilters ?? false,
                      smallSize: 7.r,
                      child: Icon(Icons.tune_rounded, size: 17.r),
                    ),
                    label: Text(l10n.filtersLabel),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.r,
                        vertical: 0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ext.radiusMd),
                      ),
                      side: BorderSide(color: colors.outline),
                    ),
                  ),
                ),
                if (categoryChips.isNotEmpty) ...[
                  SizedBox(width: ext.spacingXs),
                  VerticalDivider(
                    width: 1.r,
                    thickness: 1,
                    indent: 8.r,
                    endIndent: 8.r,
                    color: colors.outlineVariant,
                  ),
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: ext.spacingXs),
                      itemCount: categoryChips.length,
                      separatorBuilder:
                          (_, __) => SizedBox(width: ext.spacingXs),
                      itemBuilder: (context, i) {
                        final chip = categoryChips[i];
                        return InputChip(
                          avatar: Icon(switch (chip.type) {
                            'country' => Icons.public_rounded,
                            'city' => Icons.location_city_rounded,
                            _ => Icons.medical_services_outlined,
                          }, size: 15.r),
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(chip.label),
                              SizedBox(width: 2.r),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                size: 16.r,
                                color: colors.onSurfaceVariant,
                              ),
                            ],
                          ),
                          onPressed:
                              loaded != null
                                  ? () => _openFilterSheet(context, loaded)
                                  : null,
                          onDeleted: () {
                            final bloc = context.read<ProviderBloc>();
                            final updated = switch (chip.type) {
                              'country' => filter!.copyWith(
                                selectedCountries: [],
                              ),
                              'city' => filter!.copyWith(selectedCities: []),
                              _ => filter!.copyWith(selectedSpecialties: []),
                            };
                            updated.isEmpty
                                ? bloc.add(const ProviderFilterCleared())
                                : bloc.add(ProviderFilterApplied(updated));
                          },
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultsHeader(
    BuildContext context,
    AppThemeExtension ext,
    ColorScheme colors,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return SliverToBoxAdapter(
      child: BlocBuilder<ProviderBloc, ProviderState>(
        builder: (context, state) {
          if (state is! ProviderLoaded) return const SizedBox.shrink();
          final count = state.filteredProviders.length;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ext.spacingMd,
              vertical: ext.spacingXs,
            ),
            child: Row(
              children: [
                Text(
                  l10n.resultsCount(_formatCount(count)),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(count % 1000 == 0 ? 0 : 1)}k';
    }
    return count.toString();
  }

  Widget _buildProviderGrid(BuildContext context, AppThemeExtension ext) {
    return BlocBuilder<ProviderBloc, ProviderState>(
      builder: (context, state) {
        return switch (state) {
          ProviderInitial() => const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          ),
          ProviderLoading() => const SliverToBoxAdapter(
            child: LoadingShimmer(),
          ),
          ProviderLoaded(:final filteredProviders) =>
            filteredProviders.isEmpty
                ? SliverToBoxAdapter(
                  child: EmptyState(
                    onClearFilters: () {
                      _searchController.clear();
                      context.read<ProviderBloc>().add(
                        const ProviderFilterCleared(),
                      );
                    },
                  ),
                )
                : SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount =
                        constraints.crossAxisExtent > 600 ? 3 : 2;
                    final spacing = 12.r;
                    return SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: filteredProviders.length,
                      itemBuilder:
                          (_, i) => ProviderCard(
                            provider: filteredProviders[i],
                            onTap:
                                () => context.push(
                                  '/provider/${filteredProviders[i].id}',
                                  extra: filteredProviders[i],
                                ),
                          ),
                    );
                  },
                ),
          ProviderError(:final message) => SliverToBoxAdapter(
            child: ErrorState(
              message: message,
              onRetry:
                  () => context.read<ProviderBloc>().add(
                    const ProviderRetryRequested(),
                  ),
            ),
          ),
        };
      },
    );
  }
}
