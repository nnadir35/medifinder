import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medifinder/l10n/app_localizations.dart';
import 'package:medifinder/features/providers/domain/entities/provider_entity.dart';
import 'package:medifinder/core/theme/app_theme_extension.dart';
import 'package:medifinder/features/providers/data/mock/mock_providers.dart';
import 'package:medifinder/features/providers/domain/entities/filter_state.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_bloc.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_event.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_state.dart';
import 'package:medifinder/features/providers/presentation/widgets/filter_chip_group.dart';

int _countMatchingProviders({
  required List<ProviderEntity> providers,
  required String searchQuery,
  required FilterState filter,
}) {
  return providers.where((p) {
    final q = searchQuery.toLowerCase();
    final matchesSearch = q.isEmpty ||
        p.name.toLowerCase().contains(q) ||
        p.specialty.toLowerCase().contains(q);
    final matchesCountry = filter.selectedCountries.isEmpty ||
        filter.selectedCountries.contains(p.country);
    final matchesCity = filter.selectedCities.isEmpty ||
        filter.selectedCities.contains(p.city);
    final matchesSpecialty = filter.selectedSpecialties.isEmpty ||
        filter.selectedSpecialties.contains(p.specialty);
    return matchesSearch && matchesCountry && matchesCity && matchesSpecialty;
  }).length;
}

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key, required this.loadedState});

  final ProviderLoaded loadedState;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late FilterState _draft;

  static final _countries =
      mockProviders.map((p) => p.country).toSet().toList()..sort();
  static final _specialties =
      mockProviders.map((p) => p.specialty).toSet().toList()..sort();

  List<String> get _filteredCities {
    if (_draft.selectedCountries.isEmpty) {
      return mockProviders.map((p) => p.city).toSet().toList()..sort();
    }
    return mockProviders
        .where((p) => _draft.selectedCountries.contains(p.country))
        .map((p) => p.city)
        .toSet()
        .toList()
      ..sort();
  }

  @override
  void initState() {
    super.initState();
    _draft = widget.loadedState.activeFilter;
  }

  int get _resultCount => _countMatchingProviders(
        providers: widget.loadedState.providers,
        searchQuery: widget.loadedState.searchQuery,
        filter: _draft,
      );

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

    final l10n = AppLocalizations.of(context)!;

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
                Text(l10n.filterSheetTitle, style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    context.read<ProviderBloc>().add(const ProviderFilterCleared());
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.clearAllButton),
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
                  title: l10n.filterCountryLabel,
                  options: _countries,
                  selected: _draft.selectedCountries,
                  onToggle: (v) => _toggle(
                    v,
                    _draft.selectedCountries,
                    (list) {
                      final validCities = mockProviders
                          .where((p) => list.contains(p.country))
                          .map((p) => p.city)
                          .toSet();
                      _draft = _draft.copyWith(
                        selectedCountries: list,
                        selectedCities: _draft.selectedCities
                            .where((c) => validCities.contains(c))
                            .toList(),
                      );
                    },
                  ),
                ),
                SizedBox(height: ext.spacingMd),
                FilterChipGroup(
                  title: l10n.filterCityLabel,
                  options: _filteredCities,
                  selected: _draft.selectedCities,
                  onToggle: (v) => _toggle(
                    v,
                    _draft.selectedCities,
                    (list) => _draft = _draft.copyWith(selectedCities: list),
                  ),
                ),
                SizedBox(height: ext.spacingMd),
                FilterChipGroup(
                  title: l10n.filterSpecialtyLabel,
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
                    context.read<ProviderBloc>().add(ProviderFilterApplied(_draft));
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.showResultsButton(_resultCount)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
