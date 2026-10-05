import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/config/app_assets.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/storage/secure_storage.dart';
import '../../../../../core/storage/storage_keys.dart';
import '../../../../../core/theme/app_sizes.dart';

class HomeAuthorizedImage extends StatefulWidget {
  const HomeAuthorizedImage({super.key, required this.url});

  final String url;

  @override
  State<HomeAuthorizedImage> createState() => _HomeAuthorizedImageState();
}

class _HomeAuthorizedImageState extends State<HomeAuthorizedImage> {
  late final Future<String?> _token = sl<AppSecureStorage>().read(StorageKeys.accessToken);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _token,
      builder: (context, snapshot) {
        final token = snapshot.data;
        if (snapshot.connectionState != ConnectionState.done) return _placeholder(context);

        return CachedNetworkImage(
          imageUrl: widget.url,
          httpHeaders: {if (token != null) 'Authorization': 'Bearer $token'},
          fit: BoxFit.cover,
          placeholder: (context, _) => _placeholder(context),
          errorWidget: (context, _, _) => _placeholder(context),
        );
      },
    );
  }

  Widget _placeholder(BuildContext context) {
    final size = AppSizes.iconLg * 2;

    return ColoredBox(
      color: context.colorScheme.surface,
      child: Center(
        child: Image.asset(AppAssets.logoPlaceholder, width: size, height: size),
      ),
    );
  }
}
