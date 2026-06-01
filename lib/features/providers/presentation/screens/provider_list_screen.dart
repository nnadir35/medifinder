import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medifinder/core/theme/app_theme_extension.dart';
import 'package:medifinder/core/utils/constants.dart';
import 'package:medifinder/core/utils/extensions.dart';
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
      builder: (_) => BlocProvider.value(
        value: context.read<ProviderBloc>(),
        child: FilterSheet(loadedState: state),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MediFinder'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              context.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            tooltip: 'Toggle theme',
            onPressed: () async {
              final newMode =
                  context.isDarkMode ? ThemeMode.light : ThemeMode.dark;
              themeModeNotifier.value = newMode;
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(
                AppConstants.themeModeKey,
                newMode == ThemeMode.dark ? 'dark' : 'light',
              );
            },
          ),
          BlocBuilder<ProviderBloc, ProviderState>(
            builder: (context, state) {
              final loaded = state is ProviderLoaded ? state : null;
              return IconButton(
                icon: Badge(
                  isLabelVisible: loaded != null &&
                      loaded.hasActiveFilters,
                  child: const Icon(Icons.tune_rounded),
                ),
                tooltip: 'Filter',
                onPressed: loaded != null
                    ? () => _openFilterSheet(context, loaded)
                    : null,
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              ext.spacingMd,
              ext.spacingSm,
              ext.spacingMd,
              ext.spacingXs,
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by name or specialty…',
                prefixIcon: Icon(Icons.search_rounded),
              ),
              onChanged: (q) =>
                  context.read<ProviderBloc>().add(ProviderSearchChanged(q)),
            ),
          ),
          BlocBuilder<ProviderBloc, ProviderState>(
            buildWhen: (prev, curr) {
              if (prev is ProviderLoaded && curr is ProviderLoaded) {
                return prev.activeFilter != curr.activeFilter;
              }
              return true;
            },
            builder: (context, state) {
              if (state is! ProviderLoaded) return const SizedBox.shrink();
              final filter = state.activeFilter;
              if (filter.isEmpty) return const SizedBox.shrink();

              final chips = [
                ...filter.selectedCountries.map((c) => (label: c, type: 'country')),
                ...filter.selectedCities.map((c) => (label: c, type: 'city')),
                ...filter.selectedSpecialties.map((s) => (label: s, type: 'specialty')),
              ];

              return SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: ext.spacingMd),
                  itemCount: chips.length,
                  separatorBuilder: (_, __) => SizedBox(width: ext.spacingXs),
                  itemBuilder: (context, i) {
                    final chip = chips[i];
                    return InputChip(
                      label: Text(chip.label),
                      onDeleted: () {
                        final bloc = context.read<ProviderBloc>();
                        final updated = switch (chip.type) {
                          'country' => filter.copyWith(
                              selectedCountries: filter.selectedCountries
                                  .where((c) => c != chip.label)
                                  .toList(),
                            ),
                          'city' => filter.copyWith(
                              selectedCities: filter.selectedCities
                                  .where((c) => c != chip.label)
                                  .toList(),
                            ),
                          _ => filter.copyWith(
                              selectedSpecialties: filter.selectedSpecialties
                                  .where((s) => s != chip.label)
                                  .toList(),
                            ),
                        };
                        updated.isEmpty
                            ? bloc.add(const ProviderFilterCleared())
                            : bloc.add(ProviderFilterApplied(updated));
                      },
                    );
                  },
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<ProviderBloc, ProviderState>(
              builder: (context, state) => switch (state) {
                ProviderInitial() => const SizedBox.shrink(),
                ProviderLoading() => const LoadingShimmer(),
                ProviderLoaded(:final filteredProviders) =>
                  filteredProviders.isEmpty
                      ? EmptyState(
                          onClearFilters: () {
                            _searchController.clear();
                            context.read<ProviderBloc>().add(const ProviderFilterCleared());
                          },
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(bottom: ext.spacingMd),
                          itemCount: filteredProviders.length,
                          itemBuilder: (_, i) => ProviderCard(
                            provider: filteredProviders[i],
                            onTap: () => context.push(
                              '/provider/${filteredProviders[i].id}',
                              extra: filteredProviders[i],
                            ),
                          ),
                        ),
                ProviderError(:final message) => ErrorState(
                    message: message,
                    onRetry: () => context
                        .read<ProviderBloc>()
                        .add(const ProviderRetryRequested()),
                  ),
              },
            ),
          ),
        ],
        ),
      ),
    );
  }
}


