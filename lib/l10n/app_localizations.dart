import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MediFinder'**
  String get appTitle;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'Search for\nSpecialized Care'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Refine results by specialty,\nlocation, and more'**
  String get heroSubtitle;

  /// No description provided for @tooltipLightMode.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get tooltipLightMode;

  /// No description provided for @tooltipDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get tooltipDarkMode;

  /// No description provided for @tooltipLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get tooltipLanguage;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or specialty…'**
  String get searchHint;

  /// No description provided for @filtersLabel.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersLabel;

  /// No description provided for @resultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} results'**
  String resultsCount(String count);

  /// No description provided for @providerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Provider not found.'**
  String get providerNotFound;

  /// No description provided for @contactSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactSectionTitle;

  /// No description provided for @callingSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Calling: {phone}'**
  String callingSnackbar(String phone);

  /// No description provided for @openingSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Opening: {website}'**
  String openingSnackbar(String website);

  /// No description provided for @aboutSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSectionTitle;

  /// No description provided for @emptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'No providers found'**
  String get emptyStateTitle;

  /// No description provided for @emptyStateMessage.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters.'**
  String get emptyStateMessage;

  /// No description provided for @clearFiltersButton.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFiltersButton;

  /// No description provided for @errorStateTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorStateTitle;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @errorNetworkHint.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again.'**
  String get errorNetworkHint;

  /// No description provided for @filterSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filterSheetTitle;

  /// No description provided for @clearAllButton.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAllButton;

  /// No description provided for @filterCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get filterCountryLabel;

  /// No description provided for @filterCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get filterCityLabel;

  /// No description provided for @filterSpecialtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get filterSpecialtyLabel;

  /// No description provided for @showResultsButton.
  ///
  /// In en, this message translates to:
  /// **'Show {count} Results'**
  String showResultsButton(int count);

  /// No description provided for @specialtyCardiologist.
  ///
  /// In en, this message translates to:
  /// **'Cardiologist'**
  String get specialtyCardiologist;

  /// No description provided for @specialtyDermatologist.
  ///
  /// In en, this message translates to:
  /// **'Dermatologist'**
  String get specialtyDermatologist;

  /// No description provided for @specialtyOrthopedist.
  ///
  /// In en, this message translates to:
  /// **'Orthopedist'**
  String get specialtyOrthopedist;

  /// No description provided for @specialtyNeurologist.
  ///
  /// In en, this message translates to:
  /// **'Neurologist'**
  String get specialtyNeurologist;

  /// No description provided for @specialtyDentist.
  ///
  /// In en, this message translates to:
  /// **'Dentist'**
  String get specialtyDentist;

  /// No description provided for @specialtyOphthalmologist.
  ///
  /// In en, this message translates to:
  /// **'Ophthalmologist'**
  String get specialtyOphthalmologist;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
