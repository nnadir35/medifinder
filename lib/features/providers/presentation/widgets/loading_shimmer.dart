import 'package:flutter/material.dart';
import 'package:medifinder/core/theme/app_theme_extension.dart';

class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({super.key});

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _colorAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _colorAnim = ColorTween(
      begin: Colors.grey[300],
      end: Colors.grey[100],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return AnimatedBuilder(
      animation: _colorAnim,
      builder: (context, _) {
        final shimmerColor = _colorAnim.value ?? Colors.grey[200]!;
        return ListView.builder(
          itemCount: 6,
          padding: EdgeInsets.symmetric(vertical: ext.spacingSm),
          itemBuilder: (_, __) => _ShimmerCard(color: shimmerColor, ext: ext),
        );
      },
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({required this.color, required this.ext});

  final Color color;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: ext.spacingMd,
        vertical: ext.spacingSm / 2,
      ),
      child: Padding(
        padding: EdgeInsets.all(ext.spacingMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: Duration.zero,
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: ext.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _block(color, double.infinity, 14),
                  SizedBox(height: ext.spacingXs),
                  _block(color, 120, 12),
                  SizedBox(height: ext.spacingXs),
                  _block(color, 180, 12),
                  SizedBox(height: ext.spacingXs),
                  _block(color, 100, 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _block(Color color, double width, double height) => AnimatedContainer(
        duration: Duration.zero,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      );
}
