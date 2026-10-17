import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../core/shared/widgets/app_toast.dart';
import '../cubit/certificate_details/certificate_details_cubit.dart';
import '../cubit/certificate_details/certificate_details_state.dart';
import '../widgets/details/certificate_details_content.dart';
import '../widgets/details/certificate_details_skeleton.dart';
import '../../../../core/shared/widgets/app_bottom_safe_area.dart';

class CertificateDetailsPage extends StatelessWidget {
  const CertificateDetailsPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CertificateDetailsCubit>(param1: id)..load(),
      child: const _CertificateDetailsView(),
    );
  }
}

class _CertificateDetailsView extends StatelessWidget {
  const _CertificateDetailsView();

  Future<void> _onFeedback(BuildContext context, CertificateFileFeedback feedback) async {
    switch (feedback) {
      case CertificateFileReady(:final path):
        final result = await OpenFilex.open(path);
        if (result.type != ResultType.done && context.mounted) {
          AppToast.error(context, context.l10n.certificateOpenFailed);
        }
      case CertificateFileFailed(:final message):
        AppToast.error(context, message ?? context.l10n.certificateOpenFailed);
    }
  }

  Future<void> _copyCode(BuildContext context, String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (context.mounted) AppToast.success(context, context.l10n.certificateCodeCopied);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CertificateDetailsCubit>().state;
    final cubit = context.read<CertificateDetailsCubit>();
    final certificate = state.certificate;

    return BlocListener<CertificateDetailsCubit, CertificateDetailsState>(
      listenWhen: (previous, current) =>
          current.feedback != null && previous.feedback != current.feedback,
      listener: (context, state) => _onFeedback(context, state.feedback!),
      child: AppLoadingOverlay(
        isLoading: state.isBusy,
        child: Scaffold(
          appBar: AppAppBar(
            title: context.l10n.certificateDetailsTitle,
            onBack: () => context.pop(),
          ),
          body: AppBottomSafeArea(
            child: switch (certificate) {
              null when state.hasError => AppErrorWidget(
                message: state.errorMessage ?? context.l10n.somethingWentWrong,
                onRetry: cubit.load,
              ),
              null => const CertificateDetailsSkeleton(),
              final certificate => CertificateDetailsContent(
                certificate: certificate,
                onOpen: cubit.open,
                onCopyCode: () => _copyCode(context, certificate.verificationCode),
              ),
            },
          ),
        ),
      ),
    );
  }
}
