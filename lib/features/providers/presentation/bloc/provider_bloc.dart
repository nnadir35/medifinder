import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medifinder/core/error/failures.dart';
import 'package:medifinder/features/providers/data/mock/mock_providers.dart';
import 'package:medifinder/features/providers/domain/entities/filter_state.dart';
import 'package:medifinder/features/providers/domain/entities/provider_entity.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_event.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_state.dart';

class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  ProviderBloc() : super(const ProviderLoading()) {
    on<ProviderLoadRequested>(_onLoadRequested);
    on<ProviderSearchChanged>(_onSearchChanged);
    on<ProviderFilterApplied>(_onFilterApplied);
    on<ProviderFilterCleared>(_onFilterCleared);
    on<ProviderRetryRequested>(_onRetryRequested);
  }

  Future<void> _onLoadRequested(
    ProviderLoadRequested event,
    Emitter<ProviderState> emit,
  ) async {
    emit(const ProviderLoading());
    await Future.delayed(const Duration(milliseconds: 800));
    emit(ProviderLoaded(
      providers: mockProviders,
      filteredProviders: mockProviders,
      activeFilter: FilterState.empty,
      searchQuery: '',
    ));
  }

  void _onSearchChanged(
    ProviderSearchChanged event,
    Emitter<ProviderState> emit,
  ) {
    final current = state;
    if (current is! ProviderLoaded) return;

    final filtered = _applyFilters(
      current.providers,
      event.query,
      current.activeFilter,
    );

    emit(ProviderLoaded(
      providers: current.providers,
      filteredProviders: filtered,
      activeFilter: current.activeFilter,
      searchQuery: event.query,
    ));
  }

  void _onFilterApplied(
    ProviderFilterApplied event,
    Emitter<ProviderState> emit,
  ) {
    final current = state;
    if (current is! ProviderLoaded) return;

    final filtered = _applyFilters(
      current.providers,
      current.searchQuery,
      event.filter,
    );

    emit(ProviderLoaded(
      providers: current.providers,
      filteredProviders: filtered,
      activeFilter: event.filter,
      searchQuery: current.searchQuery,
    ));
  }

  void _onFilterCleared(
    ProviderFilterCleared event,
    Emitter<ProviderState> emit,
  ) {
    final current = state;
    if (current is! ProviderLoaded) return;

    emit(ProviderLoaded(
      providers: current.providers,
      filteredProviders: current.providers,
      activeFilter: FilterState.empty,
      searchQuery: '',
    ));
  }

  Future<void> _onRetryRequested(
    ProviderRetryRequested event,
    Emitter<ProviderState> emit,
  ) async {
    try {
      emit(const ProviderLoading());
      await Future.delayed(const Duration(milliseconds: 800));
      emit(ProviderLoaded(
        providers: mockProviders,
        filteredProviders: mockProviders,
        activeFilter: FilterState.empty,
        searchQuery: '',
      ));
    } catch (e) {
      emit(ProviderError(
        message: e.toString(),
        failure: const NetworkFailure(),
      ));
    }
  }

  List<ProviderEntity> _applyFilters(
    List<ProviderEntity> all,
    String query,
    FilterState filter,
  ) {
    return all.where((p) {
      final q = query.toLowerCase();
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
    }).toList();
  }
}
