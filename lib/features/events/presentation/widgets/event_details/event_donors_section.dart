import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_network_image.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/events_repository.dart';
import 'event_section_title.dart';

class EventDonorsSection extends StatelessWidget {
  const EventDonorsSection({super.key, required this.donors});

  final List<EventDonor> donors;

  @override
  Widget build(BuildContext context) {
    final margin = AppSpacing.screenMargin;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: margin),
          child: EventSectionTitle(title: context.l10n.eventSupportedByTitle),
        ),
        SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: margin),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < donors.length; i++) ...[
                if (i > 0) SizedBox(width: AppSpacing.sm),
                _DonorItem(donor: donors[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DonorItem extends StatelessWidget {
  const _DonorItem({required this.donor});

  static const _widthFactor = 1.75;

  final EventDonor donor;

  @override
  Widget build(BuildContext context) {
    final logoSize = AppSizes.eventDonorLogoSize;

    return SizedBox(
      width: logoSize * _widthFactor,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: AppRadius.lgRadius,
            child: ColoredBox(
              color: context.colorScheme.surfaceContainerHighest,
              child: SizedBox.square(
                dimension: logoSize,
                child: AppNetworkImage(
                  url: donor.imageUrl,
                  size: logoSize / 2,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xxs),
          Text(
            donor.title,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
