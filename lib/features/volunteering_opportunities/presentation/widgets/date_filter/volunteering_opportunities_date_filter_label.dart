import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';

class VolunteeringOpportunitiesDateFilterLabel extends StatelessWidget {
  const VolunteeringOpportunitiesDateFilterLabel({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat.MMMEd(context.locale.toLanguageTag()).format(date);

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        AppSpacing.screenMargin,
        AppSpacing.xs,
        AppSpacing.screenMargin,
        0,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          context.l10n.volunteeringOpportunitiesOnDate(formatted),
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
