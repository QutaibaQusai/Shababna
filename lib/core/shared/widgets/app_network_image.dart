import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

import '../../config/app_assets.dart';
import '../../extensions/context_extensions.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({super.key, this.url, this.size = 24, this.fit = BoxFit.cover});

  final String? url;
  final double size;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final url = this.url;
    if (url == null || url.isEmpty) return _fallback(context);

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (context, url) => _fallback(context),
      errorWidget: (context, url, error) => _fallback(context),
    );
  }

  Widget _fallback(BuildContext context) {
    return ColoredBox(
      color: context.colorScheme.surface,
      child: Center(
        child: Image.asset(
          AppAssets.logoPlaceholder,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
