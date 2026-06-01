import 'package:medifinder/features/providers/domain/entities/provider_entity.dart';

abstract interface class ProviderRepository {
  Future<List<ProviderEntity>> getProviders();
}
