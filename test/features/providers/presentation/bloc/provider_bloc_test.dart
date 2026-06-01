import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medifinder/features/providers/data/mock/mock_providers.dart';
import 'package:medifinder/features/providers/domain/entities/filter_state.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_bloc.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_event.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_state.dart';

void main() {
  group('ProviderBloc', () {
    late ProviderBloc bloc;

    setUp(() {
      bloc = ProviderBloc();
    });

    tearDown(() {
      bloc.close();
    });

    // 1. ProviderLoadRequested emits [Loading, Loaded] with all mock providers
    blocTest<ProviderBloc, ProviderState>(
      'emits [ProviderLoading, ProviderLoaded] with all mock providers on ProviderLoadRequested',
      build: () => ProviderBloc(),
      act: (bloc) => bloc.add(const ProviderLoadRequested()),
      wait: const Duration(milliseconds: 900),
      expect: () => [
        const ProviderLoading(),
        isA<ProviderLoaded>()
            .having(
              (s) => s.providers.length,
              'providers count',
              mockProviders.length,
            )
            .having(
              (s) => s.filteredProviders.length,
              'filteredProviders count',
              mockProviders.length,
            )
            .having(
              (s) => s.activeFilter,
              'activeFilter',
              FilterState.empty,
            )
            .having(
              (s) => s.searchQuery,
              'searchQuery',
              '',
            ),
      ],
    );

    // 2. ProviderSearchChanged with 'Cardio' returns only Cardiologists
    blocTest<ProviderBloc, ProviderState>(
      'emits ProviderLoaded with only Cardiologists when searching "Cardio"',
      build: () => ProviderBloc(),
      seed: () => ProviderLoaded(
        providers: mockProviders,
        filteredProviders: mockProviders,
        activeFilter: FilterState.empty,
        searchQuery: '',
      ),
      act: (bloc) => bloc.add(const ProviderSearchChanged('Cardio')),
      expect: () => [
        isA<ProviderLoaded>().having(
          (s) => s.filteredProviders.every((p) => p.specialty == 'Cardiologist'),
          'all results are Cardiologists',
          true,
        ),
      ],
    );

    // 3. ProviderSearchChanged with '' returns all providers
    blocTest<ProviderBloc, ProviderState>(
      'emits ProviderLoaded with all providers when search query is cleared',
      build: () => ProviderBloc(),
      seed: () => ProviderLoaded(
        providers: mockProviders,
        filteredProviders: mockProviders,
        activeFilter: FilterState.empty,
        searchQuery: 'Cardio',
      ),
      act: (bloc) => bloc.add(const ProviderSearchChanged('')),
      expect: () => [
        isA<ProviderLoaded>().having(
          (s) => s.filteredProviders.length,
          'filteredProviders.length == providers.length',
          mockProviders.length,
        ),
      ],
    );

    // 4. ProviderFilterApplied with Turkey returns only Turkish providers
    blocTest<ProviderBloc, ProviderState>(
      'emits ProviderLoaded with only Turkish providers when filtering by 🇹🇷 Turkey',
      build: () => ProviderBloc(),
      seed: () => ProviderLoaded(
        providers: mockProviders,
        filteredProviders: mockProviders,
        activeFilter: FilterState.empty,
        searchQuery: '',
      ),
      act: (bloc) => bloc.add(
        const ProviderFilterApplied(
          FilterState(
            selectedCountries: ['🇹🇷 Turkey'],
            selectedCities: [],
            selectedSpecialties: [],
          ),
        ),
      ),
      expect: () => [
        isA<ProviderLoaded>()
            .having(
              (s) => s.filteredProviders.every((p) => p.country == '🇹🇷 Turkey'),
              'all results are from Turkey',
              true,
            )
            .having(
              (s) => s.filteredProviders.isNotEmpty,
              'results are not empty',
              true,
            ),
      ],
    );

    // 5. ProviderFilterCleared resets to FilterState.empty
    blocTest<ProviderBloc, ProviderState>(
      'emits ProviderLoaded with FilterState.empty after ProviderFilterCleared',
      build: () => ProviderBloc(),
      seed: () => ProviderLoaded(
        providers: mockProviders,
        filteredProviders: mockProviders
            .where((p) => p.country == '🇹🇷 Turkey')
            .toList(),
        activeFilter: const FilterState(
          selectedCountries: ['🇹🇷 Turkey'],
          selectedCities: [],
          selectedSpecialties: [],
        ),
        searchQuery: '',
      ),
      act: (bloc) => bloc.add(const ProviderFilterCleared()),
      expect: () => [
        isA<ProviderLoaded>()
            .having(
              (s) => s.activeFilter,
              'activeFilter is empty',
              FilterState.empty,
            )
            .having(
              (s) => s.filteredProviders.length,
              'all providers restored',
              mockProviders.length,
            ),
      ],
    );

    // 6. ProviderRetryRequested emits [Loading, Loaded]
    blocTest<ProviderBloc, ProviderState>(
      'emits [ProviderLoading, ProviderLoaded] on ProviderRetryRequested',
      build: () => ProviderBloc(),
      act: (bloc) => bloc.add(const ProviderRetryRequested()),
      wait: const Duration(milliseconds: 900),
      expect: () => [
        const ProviderLoading(),
        isA<ProviderLoaded>()
            .having(
              (s) => s.providers.length,
              'providers count',
              mockProviders.length,
            )
            .having(
              (s) => s.activeFilter,
              'activeFilter is empty',
              FilterState.empty,
            ),
      ],
    );
  });
}
