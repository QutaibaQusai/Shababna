import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.navProfile,
        style: context.textTheme.headlineMedium,
      ),
    );
  }
}
