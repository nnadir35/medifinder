import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProviderAvatar extends StatelessWidget {
  const ProviderAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 28,
  });

  final String name;
  final String? imageUrl;
  final double radius;

  String get _initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return _fallback(context);
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => _initialsWidget(context),
          placeholder: (_, __) => _initialsWidget(context),
        ),
      ),
    );
  }

  Widget _fallback(BuildContext context) => CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: _initialsWidget(context),
      );

  Widget _initialsWidget(BuildContext context) => Text(
        _initials,
        style: TextStyle(
          fontSize: radius * 0.6,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      );
}
