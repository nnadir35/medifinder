import 'package:equatable/equatable.dart';

class ProviderEntity extends Equatable {
  const ProviderEntity({
    required this.id,
    required this.name,
    required this.specialty,
    required this.country,
    required this.city,
    required this.rating,
    required this.reviewCount,
    this.imageUrl,
    this.phone,
    this.website,
    this.bio,
  });

  final String id;
  final String name;
  final String specialty;
  final String country;
  final String city;
  final double rating;
  final int reviewCount;
  final String? imageUrl;
  final String? phone;
  final String? website;
  final String? bio;

  @override
  List<Object?> get props => [
        id,
        name,
        specialty,
        country,
        city,
        rating,
        reviewCount,
        imageUrl,
        phone,
        website,
        bio,
      ];
}
