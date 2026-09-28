import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/extensions/context_extensions.dart';

class VolunteerTierBadge extends StatelessWidget {
  const VolunteerTierBadge({
    super.key,
    required this.name,
    required this.lightIconUrl,
    required this.darkIconUrl,
    required this.size,
  });

  final String name;
  final String lightIconUrl;
  final String darkIconUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final url = context.isDark ? darkIconUrl : lightIconUrl;

    return Tooltip(
      message: name,
      child: Semantics(
        label: name,
        child: SvgPicture.network(
          url,
          key: ValueKey(url),
          width: size,
          height: size,
          fit: BoxFit.contain,
          placeholderBuilder: (_) => SizedBox.square(dimension: size),
        ),
      ),
    );
  }
}
