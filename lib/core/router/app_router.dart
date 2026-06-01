import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medifinder/features/providers/domain/entities/provider_entity.dart';
import 'package:medifinder/features/providers/presentation/screens/provider_detail_screen.dart';
import 'package:medifinder/features/providers/presentation/screens/provider_list_screen.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _navigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ProviderListScreen()),
    GoRoute(
      path: '/provider/:id',
      builder: (context, state) {
        final provider = state.extra as ProviderEntity?;
        return ProviderDetailScreen(provider: provider);
      },
    ),
  ],
);
