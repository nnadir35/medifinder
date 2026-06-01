import 'package:medifinder/l10n/app_localizations.dart';

extension SpecialtyL10n on AppLocalizations {
  String localizeSpecialty(String specialty) {
    return switch (specialty) {
      'Cardiologist' => specialtyCardiologist,
      'Dermatologist' => specialtyDermatologist,
      'Orthopedist' => specialtyOrthopedist,
      'Neurologist' => specialtyNeurologist,
      'Dentist' => specialtyDentist,
      'Ophthalmologist' => specialtyOphthalmologist,
      _ => specialty,
    };
  }
}
