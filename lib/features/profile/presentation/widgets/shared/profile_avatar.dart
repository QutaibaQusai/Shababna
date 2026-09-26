import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/storage/secure_storage.dart';
import '../../../../../core/storage/storage_keys.dart';

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({
    super.key,
    required this.name,
    required this.size,
    this.imageUrl,
    this.cacheKey,
    this.localFilePath,
  });

  final String name;
  final double size;
  final String? imageUrl;
  final String? cacheKey;
  final String? localFilePath;

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  late final Future<String?> _token = sl<AppSecureStorage>().read(StorageKeys.accessToken);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(color: context.colorScheme.primary, shape: BoxShape.circle),
      child: ClipOval(child: _content(context)),
    );
  }

  Widget _content(BuildContext context) {
    final localFilePath = widget.localFilePath;
    if (localFilePath != null) {
      return Image.file(
        File(localFilePath),
        fit: BoxFit.cover,
        width: widget.size,
        height: widget.size,
      );
    }

    final imageUrl = widget.imageUrl;
    final cacheKey = widget.cacheKey;
    if (imageUrl == null || cacheKey == null) return _initials(context);

    return FutureBuilder<String?>(
      future: _token,
      builder: (context, snapshot) {
        final token = snapshot.data;
        if (token == null) return _initials(context);

        return CachedNetworkImage(
          key: ValueKey(cacheKey),
          imageUrl: imageUrl,
          cacheKey: cacheKey,
          httpHeaders: {'Authorization': 'Bearer $token'},
          fit: BoxFit.cover,
          width: widget.size,
          height: widget.size,
          fadeInDuration: Duration.zero,
          placeholder: (context, url) => _initials(context),
          errorWidget: (context, url, error) => _initials(context),
        );
      },
    );
  }

  Widget _initials(BuildContext context) {
    return Center(
      child: Text(
        _initialsOf(widget.name),
        style: context.textTheme.titleLarge?.copyWith(
          color: context.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: widget.size * 0.36,
        ),
      ),
    );
  }

  String _initialsOf(String name) {
    final parts = name.split(' ').where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) {
      return parts.first.length >= 2
          ? parts.first.substring(0, 2).toUpperCase()
          : parts.first.toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
