import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../cubit/certificates_list/certificates_list_cubit.dart';
import '../../cubit/certificates_list/certificates_list_state.dart';
import 'certificate_card.dart';
import 'certificate_load_more_footer.dart';

class CertificatesListContent extends StatelessWidget {
  const CertificatesListContent({super.key, required this.state});

  static const _loadMoreThreshold = 300.0;

  final CertificatesListState state;

  bool _onScroll(BuildContext context, ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis == Axis.vertical &&
        metrics.maxScrollExtent - metrics.pixels <= _loadMoreThreshold) {
      context.read<CertificatesListCubit>().loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final items = state.items;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) => _onScroll(context, notification),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        itemCount: items.length + 1 + (state.hasNextPage ? 1 : 0),
        separatorBuilder: (context, index) =>
            SizedBox(height: index == 0 ? AppSpacing.md : AppSpacing.sm),
        itemBuilder: (context, index) {
          if (index == 0) {
            return AppPageHeader(
              title: context.l10n.certificatesMyTitle,
              subtitle: context.l10n.certificatesHeaderSubtitle,
            );
          }
          final itemIndex = index - 1;
          if (itemIndex == items.length) {
            return CertificateLoadMoreFooter(
              failed: state.loadMoreFailed,
              onRetry: context.read<CertificatesListCubit>().retryLoadMore,
            );
          }
          return CertificateCard(certificate: items[itemIndex]);
        },
      ),
    );
  }
}
