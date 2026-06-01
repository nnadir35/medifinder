import 'package:equatable/equatable.dart';

class FilterState extends Equatable {
  const FilterState({
    required this.selectedCountries,
    required this.selectedCities,
    required this.selectedSpecialties,
  });

  static const empty = FilterState(
    selectedCountries: [],
    selectedCities: [],
    selectedSpecialties: [],
  );

  final List<String> selectedCountries;
  final List<String> selectedCities;
  final List<String> selectedSpecialties;

  bool get isEmpty =>
      selectedCountries.isEmpty &&
      selectedCities.isEmpty &&
      selectedSpecialties.isEmpty;

  FilterState copyWith({
    List<String>? selectedCountries,
    List<String>? selectedCities,
    List<String>? selectedSpecialties,
  }) =>
      FilterState(
        selectedCountries: selectedCountries ?? this.selectedCountries,
        selectedCities: selectedCities ?? this.selectedCities,
        selectedSpecialties: selectedSpecialties ?? this.selectedSpecialties,
      );

  @override
  List<Object?> get props => [
        selectedCountries,
        selectedCities,
        selectedSpecialties,
      ];
}
