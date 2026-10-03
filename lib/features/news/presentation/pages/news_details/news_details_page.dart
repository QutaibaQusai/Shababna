import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_share_links.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../../core/shared/widgets/share_icon_button.dart';
import '../../cubit/news_details/news_details_cubit.dart';
import '../../cubit/news_details/news_details_state.dart';
import '../../widgets/news_details/news_details_content.dart';
import '../../widgets/news_details/news_details_skeleton.dart';
import '../../widgets/shared/news_fill_viewport.dart';

class NewsDetailsPage extends StatelessWidget {
  const NewsDetailsPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewsDetailsCubit>(param1: id)..load(),
      child: const _NewsDetailsView(),
    );
  }
}

class _NewsDetailsView extends StatelessWidget {
  const _NewsDetailsView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NewsDetailsCubit>().state;
    final cubit = context.read<NewsDetailsCubit>();
    final article = state.article;

    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.navNews,
        onBack: () => context.pop(),
        actions: [ShareIconButton(path: AppShareLinks.newsDetails(cubit.id))],
      ),
      body: article != null
          ? NewsDetailsContent(article: article)
          : _placeholder(context, state, cubit),
    );
  }

  Widget _placeholder(BuildContext context, NewsDetailsState state, NewsDetailsCubit cubit) {
    if (state.hasError) {
      return NewsFillViewport(
        child: AppErrorWidget(
          message: state.errorMessage ?? context.l10n.somethingWentWrong,
          onRetry: cubit.load,
        ),
      );
    }
    return const NewsDetailsSkeleton();
  }
}
