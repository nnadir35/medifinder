import 'package:equatable/equatable.dart';
import 'package:medifinder/core/error/failures.dart';
import 'package:medifinder/features/providers/domain/entities/filter_state.dart';
import 'package:medifinder/features/providers/domain/entities/provider_entity.dart';

sealed class ProviderState extends Equatable {
  const ProviderState();

  @override
  List<Object?> get props => [];
}

final class ProviderInitial extends ProviderState {
  const ProviderInitial();
}

final class ProviderLoading extends ProviderState {
  const ProviderLoading();
}

final class ProviderLoaded extends ProviderState {
  const ProviderLoaded({
    required this.providers,
    required this.filteredProviders,
    required this.activeFilter,
    required this.searchQuery,
  });

  final List<ProviderEntity> providers;
  final List<ProviderEntity> filteredProviders;
  final FilterState activeFilter;
  final String searchQuery;

  @override
  List<Object?> get props => [
        providers,
        filteredProviders,
        activeFilter,
        searchQuery,
      ];
}

final class ProviderError extends ProviderState {
  const ProviderError({required this.message, required this.failure});

  final String message;
  final Failure failure;

  @override
  List<Object?> get props => [message, failure];
}
