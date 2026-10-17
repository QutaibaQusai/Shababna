import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../domain/repositories/home_repository.dart';
import '../../widgets/slider/home_slide_details_body.dart';
import '../../../../../core/shared/widgets/app_bottom_safe_area.dart';

class HomeSlideDetailsPage extends StatelessWidget {
  const HomeSlideDetailsPage({super.key, required this.slide});

  final HomeSlide slide;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: '', onBack: () => context.pop()),
      body: AppBottomSafeArea(child: HomeSlideDetailsBody(slide: slide)),
    );
  }
}
