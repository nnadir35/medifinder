import 'package:medifinder/features/providers/domain/entities/provider_entity.dart';

class ProviderModel extends ProviderEntity {
  const ProviderModel({
    required super.id,
    required super.name,
    required super.specialty,
    required super.country,
    required super.city,
    required super.rating,
    required super.reviewCount,
    required super.isVerified,
    super.imageUrl,
    super.phone,
    super.website,
    super.bio,
  });

  static ProviderModel fromMap(Map<String, dynamic> map) => ProviderModel(
        id: map['id'] as String,
        name: map['name'] as String,
        specialty: map['specialty'] as String,
        country: map['country'] as String,
        city: map['city'] as String,
        rating: (map['rating'] as num).toDouble(),
        reviewCount: map['reviewCount'] as int,
        isVerified: map['isVerified'] as bool,
        imageUrl: map['imageUrl'] as String?,
        phone: map['phone'] as String?,
        website: map['website'] as String?,
        bio: map['bio'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'specialty': specialty,
        'country': country,
        'city': city,
        'rating': rating,
        'reviewCount': reviewCount,
        'isVerified': isVerified,
        'imageUrl': imageUrl,
        'phone': phone,
        'website': website,
        'bio': bio,
      };
}
