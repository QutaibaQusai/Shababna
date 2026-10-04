import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';

class TaskDescription extends StatelessWidget {
  const TaskDescription({super.key, required this.html});

  static const _lineHeight = 1.6;

  final String html;

  Future<void> _openLink(String? url) async {
    final uri = url == null ? null : Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Html(
      data: html,
      onLinkTap: (url, attributes, element) => _openLink(url),
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(context.textTheme.bodyLarge?.fontSize ?? 16),
          lineHeight: const LineHeight(_lineHeight),
          color: context.colorScheme.onSurface,
        ),
        'p': Style(margin: Margins.only(top: 0, bottom: AppSpacing.xs)),
        'a': Style(color: context.colorScheme.primary),
      },
    );
  }
}
