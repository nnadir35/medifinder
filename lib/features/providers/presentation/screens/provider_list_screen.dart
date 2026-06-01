import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medifinder/core/theme/app_theme_extension.dart';
import 'package:medifinder/features/providers/data/mock/mock_providers.dart';
import 'package:medifinder/features/providers/domain/entities/filter_state.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_bloc.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_event.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_state.dart';
import 'package:medifinder/features/providers/presentation/widgets/empty_state.dart';
import 'package:medifinder/features/providers/presentation/widgets/error_state.dart';
import 'package:medifinder/features/providers/presentation/widgets/filter_chip_group.dart';
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
        child: _FilterSheet(loadedState: state),
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
          BlocBuilder<ProviderBloc, ProviderState>(
            builder: (context, state) {
              final loaded = state is ProviderLoaded ? state : null;
              return IconButton(
                icon: Badge(
                  isLabelVisible: loaded != null &&
                      !loaded.activeFilter.isEmpty,
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
      body: Column(
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
              if (curr is! ProviderLoaded) return false;
              return !curr.activeFilter.isEmpty;
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
                            context
                                .read<ProviderBloc>()
                                .add(const ProviderFilterCleared());
                            context
                                .read<ProviderBloc>()
                                .add(const ProviderSearchChanged(''));
                          },
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(bottom: ext.spacingMd),
                          itemCount: filteredProviders.length,
                          itemBuilder: (_, i) => ProviderCard(
                            provider: filteredProviders[i],
                            onTap: () => context.go(
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
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.loadedState});

  final ProviderLoaded loadedState;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late FilterState _draft;

  static final _countries =
      mockProviders.map((p) => p.country).toSet().toList()..sort();
  static final _cities =
      mockProviders.map((p) => p.city).toSet().toList()..sort();
  static final _specialties =
      mockProviders.map((p) => p.specialty).toSet().toList()..sort();

  @override
  void initState() {
    super.initState();
    _draft = widget.loadedState.activeFilter;
  }

  int get _resultCount {
    final all = widget.loadedState.providers;
    return all.where((p) {
      final matchesSearch = widget.loadedState.searchQuery.isEmpty ||
          p.name.toLowerCase().contains(widget.loadedState.searchQuery.toLowerCase()) ||
          p.specialty.toLowerCase().contains(widget.loadedState.searchQuery.toLowerCase());
      final matchesCountry = _draft.selectedCountries.isEmpty ||
          _draft.selectedCountries.contains(p.country);
      final matchesCity = _draft.selectedCities.isEmpty ||
          _draft.selectedCities.contains(p.city);
      final matchesSpecialty = _draft.selectedSpecialties.isEmpty ||
          _draft.selectedSpecialties.contains(p.specialty);
      return matchesSearch && matchesCountry && matchesCity && matchesSpecialty;
    }).length;
  }

  void _toggle(String value, List<String> current, void Function(List<String>) update) {
    setState(() {
      update(current.contains(value)
          ? current.where((e) => e != value).toList()
          : [...current, value]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: ext.spacingSm),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ext.spacingMd),
            child: Row(
              children: [
                Text('Filters',
                    style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    context.read<ProviderBloc>().add(const ProviderFilterCleared());
                    Navigator.of(context).pop();
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.all(ext.spacingMd),
              children: [
                FilterChipGroup(
                  title: 'Country',
                  options: _countries,
                  selected: _draft.selectedCountries,
                  onToggle: (v) => _toggle(
                    v,
                    _draft.selectedCountries,
                    (list) => _draft = _draft.copyWith(selectedCountries: list),
                  ),
                ),
                SizedBox(height: ext.spacingMd),
                FilterChipGroup(
                  title: 'City',
                  options: _cities,
                  selected: _draft.selectedCities,
                  onToggle: (v) => _toggle(
                    v,
                    _draft.selectedCities,
                    (list) => _draft = _draft.copyWith(selectedCities: list),
                  ),
                ),
                SizedBox(height: ext.spacingMd),
                FilterChipGroup(
                  title: 'Specialty',
                  options: _specialties,
                  selected: _draft.selectedSpecialties,
                  onToggle: (v) => _toggle(
                    v,
                    _draft.selectedSpecialties,
                    (list) => _draft = _draft.copyWith(selectedSpecialties: list),
                  ),
                ),
                SizedBox(height: ext.spacingXl),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                ext.spacingMd,
                ext.spacingXs,
                ext.spacingMd,
                ext.spacingMd,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    context
                        .read<ProviderBloc>()
                        .add(ProviderFilterApplied(_draft));
                    Navigator.of(context).pop();
                  },
                  child: Text('Show $_resultCount Results'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
