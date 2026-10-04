import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';

class TaskSectionTitle extends StatelessWidget {
  const TaskSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold));
  }
}
