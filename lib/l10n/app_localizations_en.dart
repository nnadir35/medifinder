// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MediFinder';

  @override
  String get heroTitle => 'Search for\nSpecialized Care';

  @override
  String get heroSubtitle => 'Refine results by specialty,\nlocation, and more';

  @override
  String get tooltipLightMode => 'Light mode';

  @override
  String get tooltipDarkMode => 'Dark mode';

  @override
  String get tooltipLanguage => 'Change language';

  @override
  String get searchHint => 'Search by name or specialty…';

  @override
  String get filtersLabel => 'Filters';

  @override
  String resultsCount(String count) {
    return '$count results';
  }

  @override
  String get sortRelevance => 'Relevance';

  @override
  String get providerNotFound => 'Provider not found.';

  @override
  String get contactSectionTitle => 'Contact';

  @override
  String callingSnackbar(String phone) {
    return 'Calling: $phone';
  }

  @override
  String openingSnackbar(String website) {
    return 'Opening: $website';
  }

  @override
  String get aboutSectionTitle => 'About';

  @override
  String get emptyStateTitle => 'No providers found';

  @override
  String get emptyStateMessage => 'Try adjusting your search or filters.';

  @override
  String get clearFiltersButton => 'Clear Filters';

  @override
  String get errorStateTitle => 'Something went wrong';

  @override
  String get retryButton => 'Retry';

  @override
  String get filterSheetTitle => 'Filters';

  @override
  String get clearAllButton => 'Clear All';

  @override
  String get filterCountryLabel => 'Country';

  @override
  String get filterCityLabel => 'City';

  @override
  String get filterSpecialtyLabel => 'Specialty';

  @override
  String showResultsButton(int count) {
    return 'Show $count Results';
  }
}
