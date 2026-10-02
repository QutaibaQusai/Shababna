import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';

class SearchMessage extends StatelessWidget {
  const SearchMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final size = AppSizes.illustrationSize;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture(
              SvgAssetLoader(
                AppAssets.illustrationSearch,
                colorMapper: _PrimaryColorMapper(context.colorScheme.primary),
              ),
              height: size,
              placeholderBuilder: (_) => SizedBox(height: size),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryColorMapper extends ColorMapper {
  const _PrimaryColorMapper(this.primary);

  static const _placeholder = Color(0xFF6C63FF);

  final Color primary;

  @override
  Color substitute(String? id, String elementName, String attributeName, Color color) {
    return color.toARGB32() == _placeholder.toARGB32() ? primary : color;
  }

  @override
  bool operator ==(Object other) => other is _PrimaryColorMapper && other.primary == primary;

  @override
  int get hashCode => primary.hashCode;
}
