import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';

class ContactLocationMap extends StatefulWidget {
  const ContactLocationMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.onTap,
  });

  final double latitude;
  final double longitude;
  final VoidCallback onTap;

  static double get height => 180.r;

  @override
  State<ContactLocationMap> createState() => _ContactLocationMapState();
}

class _ContactLocationMapState extends State<ContactLocationMap> {
  static const _zoom = 16;
  static const _darkFilter = 'invert(90%) hue-rotate(180deg)';

  bool _isLoaded = false;
  bool _hasFailed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final language = context.locale.languageCode;

    return Semantics(
      button: true,
      label: context.l10n.contactInfoOpenInMaps,
      child: ClipRRect(
        borderRadius: AppRadius.lgRadius,
        child: SizedBox(
          height: ContactLocationMap.height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (_hasFailed)
                ColoredBox(
                  color: context.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    LucideIcons.mapPin,
                    size: AppSizes.iconLg,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                )
              else
                IgnorePointer(
                  child: InAppWebView(
                    key: ValueKey('$isDark-$language'),
                    initialData: InAppWebViewInitialData(
                      data: _embedHtml(isDark: isDark, language: language),
                      baseUrl: WebUri('https://www.google.com'),
                    ),
                    initialSettings: InAppWebViewSettings(
                      transparentBackground: true,
                      supportZoom: false,
                      builtInZoomControls: false,
                      displayZoomControls: false,
                      disableHorizontalScroll: true,
                      disableVerticalScroll: true,
                    ),
                    onLoadStop: (_, _) {
                      if (mounted) setState(() => _isLoaded = true);
                    },
                    onReceivedError: (_, request, _) {
                      if (request.isForMainFrame ?? true) {
                        if (mounted) setState(() => _hasFailed = true);
                      }
                    },
                  ),
                ),
              if (!_isLoaded && !_hasFailed)
                Skeletonizer.zone(
                  child: Bone(width: double.infinity, height: ContactLocationMap.height),
                ),
              Material(
                type: MaterialType.transparency,
                child: InkWell(onTap: widget.onTap),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _embedHtml({required bool isDark, required String language}) {
    final source = Uri.https('www.google.com', '/maps', {
      'q': '${widget.latitude},${widget.longitude}',
      'z': '$_zoom',
      'hl': language,
      'output': 'embed',
    });
    final filter = isDark ? 'filter:$_darkFilter;' : '';

    return '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<style>
html, body { margin: 0; padding: 0; height: 100%; overflow: hidden; background: transparent; }
iframe { border: 0; width: 100%; height: 100%; $filter }
</style>
</head>
<body>
<iframe src="$source" loading="eager" referrerpolicy="no-referrer-when-downgrade"></iframe>
</body>
</html>
''';
  }
}
