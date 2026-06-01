import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:medifinder/core/error/exceptions.dart';
import 'package:medifinder/features/providers/data/mock/mock_providers.dart';
import 'package:medifinder/features/providers/domain/entities/provider_entity.dart';
import 'package:medifinder/features/providers/domain/repositories/provider_repository.dart';

class ProviderRepositoryImpl implements ProviderRepository {
  const ProviderRepositoryImpl();

  @override
  Future<List<ProviderEntity>> getProviders() async {
    final result = await Connectivity().checkConnectivity();
    final hasConnection = result.any((r) => r != ConnectivityResult.none);
    if (!hasConnection) throw const NetworkException('No internet connection');
    await Future.delayed(const Duration(milliseconds: 800));
    return mockProviders;
  }
}
