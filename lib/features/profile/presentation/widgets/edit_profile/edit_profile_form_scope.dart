import 'package:flutter/widgets.dart';

import '../../../domain/repositories/profile_repository.dart';
import '../../utils/profile_missing_field.dart';

typedef ProfileDraftEdit = void Function(ProfileDetails Function(ProfileDetails draft) change);

class EditProfileFormScope {
  const EditProfileFormScope({
    required this.draft,
    required this.edit,
    required this.isMissing,
    required this.anchor,
  });

  final ProfileDetails draft;
  final ProfileDraftEdit edit;
  final bool Function(ProfileMissingField field) isMissing;
  final Widget Function(ProfileMissingField field, Widget child) anchor;
}
