import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_share_links.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_refresh_indicator.dart';
import '../../../../core/shared/widgets/share_icon_button.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/legal_repository.dart';
import '../cubit/legal_cubit.dart';
import '../widgets/legal_content_skeleton.dart';
import '../../../../core/shared/widgets/app_bottom_safe_area.dart';

enum LegalDocumentType { privacyPolicy, termsAndConditions }

class LegalContentPage extends StatelessWidget {
  const LegalContentPage({super.key, required this.documentType});

  final LegalDocumentType documentType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LegalCubit>()..loadContent(),
      child: _LegalContentView(documentType: documentType),
    );
  }
}

class _LegalContentView extends StatelessWidget {
  const _LegalContentView({required this.documentType});

  final LegalDocumentType documentType;

  String _titleFor(BuildContext context) => switch (documentType) {
        LegalDocumentType.privacyPolicy => context.l10n.profileMenuPrivacyPolicy,
        LegalDocumentType.termsAndConditions => context.l10n.profileMenuTermsAndConditions,
      };

  String _contentFor(LegalContent content, bool isArabic) => switch (documentType) {
        LegalDocumentType.privacyPolicy =>
          isArabic ? content.privacyPolicyAr : content.privacyPolicyEn,
        LegalDocumentType.termsAndConditions =>
          isArabic ? content.termsAndConditionsAr : content.termsAndConditionsEn,
      };

  String _pathFor() => switch (documentType) {
        LegalDocumentType.privacyPolicy => AppShareLinks.privacyPolicy,
        LegalDocumentType.termsAndConditions => AppShareLinks.termsAndConditions,
      };

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LegalCubit>().state;

    return Scaffold(
      appBar: AppAppBar(
        title: _titleFor(context),
        onBack: () => context.pop(),
        actions: [ShareIconButton(path: _pathFor())],
      ),
      body: AppBottomSafeArea(
        top: true,
        child: AppRefreshIndicator(
          onRefresh: () => context.read<LegalCubit>().loadContent(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppSpacing.screenMargin),
            child: state.errorMessage != null && !state.isLoading
                ? AppErrorWidget(
                    message: state.errorMessage!,
                    onRetry: () => context.read<LegalCubit>().loadContent(),
                  )
                : state.isLoading || state.content == null
                    ? const LegalContentSkeleton()
                    : Html(data: _contentFor(state.content!, context.isArabic)),
          ),
        ),
      ),
    );
  }
}
