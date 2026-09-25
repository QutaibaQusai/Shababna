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
import '../cubit/about_us_cubit.dart';
import '../widgets/about_us_skeleton.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AboutUsCubit>()..loadAboutUs(),
      child: const _AboutUsView(),
    );
  }
}

class _AboutUsView extends StatelessWidget {
  const _AboutUsView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AboutUsCubit>().state;

    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.profileMenuAboutUs,
        onBack: () => context.pop(),
        actions: [ShareIconButton(path: AppShareLinks.aboutUs)],
      ),
      body: SafeArea(
        child: AppRefreshIndicator(
          onRefresh: () => context.read<AboutUsCubit>().loadAboutUs(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppSpacing.screenMargin),
            child: state.errorMessage != null && !state.isLoading
                ? AppErrorWidget(
                    message: state.errorMessage!,
                    onRetry: () => context.read<AboutUsCubit>().loadAboutUs(),
                  )
                : state.isLoading || state.content == null
                    ? const AboutUsSkeleton()
                    : Html(
                        data: context.isArabic
                            ? state.content!.aboutUsAr
                            : state.content!.aboutUsEn,
                      ),
          ),
        ),
      ),
    );
  }
}
