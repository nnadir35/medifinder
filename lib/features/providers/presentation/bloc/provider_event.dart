import 'package:equatable/equatable.dart';
import 'package:medifinder/features/providers/domain/entities/filter_state.dart';

sealed class ProviderEvent extends Equatable {
  const ProviderEvent();

  @override
  List<Object?> get props => [];
}

final class ProviderLoadRequested extends ProviderEvent {
  const ProviderLoadRequested();
}

final class ProviderSearchChanged extends ProviderEvent {
  const ProviderSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class ProviderFilterApplied extends ProviderEvent {
  const ProviderFilterApplied(this.filter);

  final FilterState filter;

  @override
  List<Object?> get props => [filter];
}

final class ProviderFilterCleared extends ProviderEvent {
  const ProviderFilterCleared();
}

final class ProviderRetryRequested extends ProviderEvent {
  const ProviderRetryRequested();
}
