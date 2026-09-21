import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.navNews,
        style: context.textTheme.headlineMedium,
      ),
    );
  }
}
