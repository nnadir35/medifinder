import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medifinder/core/router/app_router.dart';
import 'package:medifinder/core/theme/app_theme.dart';
import 'package:medifinder/core/utils/constants.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_bloc.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medifinder/l10n/app_localizations.dart';

final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);
final localeNotifier = ValueNotifier<Locale>(const Locale('en'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getString(AppConstants.themeModeKey);
  if (stored == 'dark') {
    themeModeNotifier.value = ThemeMode.dark;
  } else if (stored == 'light') {
    themeModeNotifier.value = ThemeMode.light;
  }
  final storedLocale = prefs.getString(AppConstants.localeKey);
  if (storedLocale == 'tr') {
    localeNotifier.value = const Locale('tr');
  }
  runApp(const MediFinderApp());
}

class MediFinderApp extends StatefulWidget {
  const MediFinderApp({super.key});

  @override
  State<MediFinderApp> createState() => _MediFinderAppState();
}

class _MediFinderAppState extends State<MediFinderApp> {
  @override
  void initState() {
    super.initState();
    themeModeNotifier.addListener(_rebuild);
    localeNotifier.addListener(_rebuild);
  }

  @override
  void dispose() {
    themeModeNotifier.removeListener(_rebuild);
    localeNotifier.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => BlocProvider<ProviderBloc>(
        create: (_) => ProviderBloc()..add(const ProviderLoadRequested()),
        child: MaterialApp.router(
          title: 'MediFinder',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeModeNotifier.value,
          locale: localeNotifier.value,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
