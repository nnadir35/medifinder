import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medifinder/core/router/app_router.dart';
import 'package:medifinder/core/theme/app_theme.dart';
import 'package:medifinder/core/utils/constants.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_bloc.dart';
import 'package:medifinder/features/providers/presentation/bloc/provider_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getString(AppConstants.themeModeKey);
  if (stored == 'dark') {
    themeModeNotifier.value = ThemeMode.dark;
  } else if (stored == 'light') {
    themeModeNotifier.value = ThemeMode.light;
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
    themeModeNotifier.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    themeModeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProviderBloc>(
      create: (_) => ProviderBloc()..add(const ProviderLoadRequested()),
      child: MaterialApp.router(
        title: 'MediFinder',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeModeNotifier.value,
        routerConfig: appRouter,
      ),
    );
  }
}
