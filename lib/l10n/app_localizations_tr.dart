// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'MediFinder';

  @override
  String get heroTitle => 'Uzman Sağlık\nHizmeti Ara';

  @override
  String get heroSubtitle => 'Uzmanlık, konum ve daha\nfazlasına göre filtrele';

  @override
  String get tooltipLightMode => 'Açık tema';

  @override
  String get tooltipDarkMode => 'Koyu tema';

  @override
  String get tooltipLanguage => 'Dili değiştir';

  @override
  String get searchHint => 'İsme göre ara…';

  @override
  String get filtersLabel => 'Filtreler';

  @override
  String resultsCount(String count) {
    return '$count sonuç';
  }

  @override
  String get providerNotFound => 'Sağlayıcı bulunamadı.';

  @override
  String get contactSectionTitle => 'İletişim';

  @override
  String callingSnackbar(String phone) {
    return 'Aranıyor: $phone';
  }

  @override
  String openingSnackbar(String website) {
    return 'Açılıyor: $website';
  }

  @override
  String get aboutSectionTitle => 'Hakkında';

  @override
  String get emptyStateTitle => 'Sağlayıcı bulunamadı';

  @override
  String get emptyStateMessage =>
      'Arama veya filtrelerinizi ayarlamayı deneyin.';

  @override
  String get clearFiltersButton => 'Filtreleri Temizle';

  @override
  String get errorStateTitle => 'Bir şeyler ters gitti';

  @override
  String get retryButton => 'Tekrar Dene';

  @override
  String get errorNetworkHint =>
      'İnternet bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get filterSheetTitle => 'Filtreler';

  @override
  String get clearAllButton => 'Tümünü Temizle';

  @override
  String get filterCountryLabel => 'Ülke';

  @override
  String get filterCityLabel => 'Şehir';

  @override
  String get filterSpecialtyLabel => 'Uzmanlık';

  @override
  String showResultsButton(int count) {
    return '$count Sonucu Göster';
  }

  @override
  String get specialtyCardiologist => 'Kardiyolog';

  @override
  String get specialtyDermatologist => 'Dermatolog';

  @override
  String get specialtyOrthopedist => 'Ortopedist';

  @override
  String get specialtyNeurologist => 'Nörolog';

  @override
  String get specialtyDentist => 'Diş Hekimi';

  @override
  String get specialtyOphthalmologist => 'Göz Doktoru';
}
