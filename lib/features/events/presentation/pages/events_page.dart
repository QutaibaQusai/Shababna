import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.navEvents,
        style: context.textTheme.headlineMedium,
      ),
    );
  }
}
