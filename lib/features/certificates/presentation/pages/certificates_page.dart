import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_empty_widget.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_refresh_indicator.dart';
import '../cubit/certificates_list/certificates_list_cubit.dart';
import '../cubit/certificates_list/certificates_list_state.dart';
import '../widgets/list/certificates_list_content.dart';
import '../widgets/list/certificates_list_skeleton.dart';
import '../widgets/shared/certificate_fill_viewport.dart';
import '../../../../core/shared/widgets/app_bottom_safe_area.dart';

class CertificatesPage extends StatelessWidget {
  const CertificatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CertificatesListCubit>()..loadFirstPage(),
      child: Scaffold(
        appBar: AppAppBar(title: context.l10n.certificatesMyTitle, onBack: () => context.pop()),
        body: const AppBottomSafeArea(child: _CertificatesView()),
      ),
    );
  }
}

class _CertificatesView extends StatelessWidget {
  const _CertificatesView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CertificatesListCubit>().state;
    final cubit = context.read<CertificatesListCubit>();

    return AppRefreshIndicator(
      onRefresh: cubit.refresh,
      child: switch (state.status) {
        CertificatesListStatus.initial ||
        CertificatesListStatus.loading => const CertificatesListSkeleton(),
        CertificatesListStatus.failure => CertificateFillViewport(
          child: AppErrorWidget(
            message: state.errorMessage ?? context.l10n.somethingWentWrong,
            onRetry: cubit.loadFirstPage,
          ),
        ),
        CertificatesListStatus.success when state.items.isEmpty => CertificateFillViewport(
          child: AppEmptyWidget(
            message: context.l10n.certificatesEmptyMessage,
            asset: AppAssets.illustrationCertificates,
          ),
        ),
        CertificatesListStatus.success => CertificatesListContent(state: state),
      },
    );
  }
}
