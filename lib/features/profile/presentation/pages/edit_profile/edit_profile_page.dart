import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_dialog.dart';
import '../../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/state/form_status.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../cubit/edit_profile/edit_profile_cubit.dart';
import '../../cubit/edit_profile/edit_profile_state.dart';
import '../../cubit/profile/profile_cubit.dart';
import '../../cubit/profile/profile_state.dart';
import '../../cubit/profile_attachment/profile_attachment_cubit.dart';
import '../../cubit/profile_attachment/profile_attachment_state.dart';
import '../../utils/profile_missing_field.dart';
import '../../widgets/edit_profile/edit_profile_account_fields.dart';
import '../../widgets/edit_profile/edit_profile_address_section.dart';
import '../../widgets/edit_profile/edit_profile_bottom_bar.dart';
import '../../widgets/edit_profile/edit_profile_documents_section.dart';
import '../../widgets/edit_profile/edit_profile_form_scope.dart';
import '../../widgets/edit_profile/edit_profile_name_fields.dart';
import '../../widgets/edit_profile/edit_profile_personal_section.dart';
import '../../widgets/edit_profile/edit_profile_skeleton.dart';
import '../../widgets/edit_profile/edit_profile_volunteering_section.dart';
import '../../widgets/edit_profile/profile_attachment_flow.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key, this.missingFields = const []});

  final List<String> missingFields;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ProfileCubit>(),
      child: _EditProfileGate(missingFields: ProfileMissingField.parse(missingFields)),
    );
  }
}

class _EditProfileGate extends StatefulWidget {
  const _EditProfileGate({required this.missingFields});

  final Set<ProfileMissingField> missingFields;

  @override
  State<_EditProfileGate> createState() => _EditProfileGateState();
}

class _EditProfileGateState extends State<_EditProfileGate> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().ensureLoaded();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          (previous.profile == null) != (current.profile == null) ||
          previous.hasError != current.hasError,
      builder: (context, state) {
        final profile = state.profile;
        if (profile != null) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<EditProfileCubit>(param1: profile)),
              BlocProvider(create: (_) => sl<ProfileAttachmentCubit>()),
            ],
            child: _EditProfileView(missingFields: widget.missingFields),
          );
        }

        return Scaffold(
          appBar: AppAppBar(
            title: context.l10n.editProfileTitle,
            onBack: () => Navigator.of(context).maybePop(),
          ),
          body: state.hasError
              ? AppErrorWidget(
                  message: state.errorMessage ?? context.l10n.somethingWentWrong,
                  onRetry: () => context.read<ProfileCubit>().refresh(),
                )
              : const EditProfileSkeleton(),
        );
      },
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView({required this.missingFields});

  final Set<ProfileMissingField> missingFields;

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  static const _scrollDuration = Duration(milliseconds: 450);
  static const _scrollAlignment = 0.15;

  final _formKey = GlobalKey<FormState>();
  final _fieldKeys = {for (final field in ProfileMissingField.values) field: GlobalKey()};
  bool _showMissing = false;

  late final _fullNameArController = TextEditingController();
  late final _fullNameEnController = TextEditingController();
  late final _majorController = TextEditingController();
  late final _universityNameController = TextEditingController();
  late final _nearestLandmarkController = TextEditingController();
  late final _districtController = TextEditingController();
  late final _neighborhoodController = TextEditingController();
  late final _detailedAddressController = TextEditingController();
  late final _weeklyHoursController = TextEditingController();
  late final _otherSubjectsController = TextEditingController();

  EditProfileCubit get _cubit => context.read<EditProfileCubit>();

  @override
  void initState() {
    super.initState();
    _syncControllers(_cubit.state.draft);
    if (widget.missingFields.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToFirstMissing());
    }
  }

  Future<void> _scrollToFirstMissing() async {
    final first = ProfileMissingField.values.where(widget.missingFields.contains).firstOrNull;
    final target = first == null ? null : _fieldKeys[first]?.currentContext;
    if (target != null && target.mounted) {
      await Scrollable.ensureVisible(
        target,
        duration: _scrollDuration,
        curve: Curves.easeOutCubic,
        alignment: _scrollAlignment,
      );
    }
    if (mounted) setState(() => _showMissing = true);
  }

  bool _isMissing(ProfileMissingField field, ProfileDetails draft, bool hasNationalIdPicture) =>
      _showMissing &&
      widget.missingFields.contains(field) &&
      !field.isFilled(draft, hasNationalIdPicture: hasNationalIdPicture);

  @override
  void dispose() {
    _fullNameArController.dispose();
    _fullNameEnController.dispose();
    _majorController.dispose();
    _universityNameController.dispose();
    _nearestLandmarkController.dispose();
    _districtController.dispose();
    _neighborhoodController.dispose();
    _detailedAddressController.dispose();
    _weeklyHoursController.dispose();
    _otherSubjectsController.dispose();
    super.dispose();
  }

  void _syncControllers(ProfileDetails details) {
    void sync(TextEditingController controller, String value) {
      if (controller.text != value) controller.text = value;
    }

    sync(_fullNameArController, details.fullNameAr);
    sync(_fullNameEnController, details.fullNameEn);
    sync(_majorController, details.major);
    sync(_universityNameController, details.universityName);
    sync(_nearestLandmarkController, details.nearestLandmark);
    sync(_districtController, details.district);
    sync(_neighborhoodController, details.neighborhood);
    sync(_detailedAddressController, details.detailedAddress);
    sync(_weeklyHoursController, details.estimatedWeeklyHours);
    sync(_otherSubjectsController, details.otherVolunteeringSubjects);
  }

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _cubit.submit();
  }

  Future<void> _confirmDiscard() async {
    final discard = await AppDialog.confirm(
      context,
      title: context.l10n.discardChangesTitle,
      message: context.l10n.discardChangesMessage,
      confirmText: context.l10n.discardButton,
      cancelText: context.l10n.cancelButton,
      isDestructive: true,
    );
    if (discard && mounted) Navigator.of(context).pop();
  }

  void _onEditStatusChanged(BuildContext context, EditProfileState state) {
    if (state.status == FormStatus.success) {
      AppToast.success(context, context.l10n.editProfileSuccessMessage);
      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop();
      } else {
        _syncControllers(state.draft);
      }
    } else if (state.status == FormStatus.failure) {
      AppToast.error(context, state.errorMessage ?? context.l10n.somethingWentWrong);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EditProfileCubit, EditProfileState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: _onEditStatusChanged,
        ),
        BlocListener<ProfileAttachmentCubit, ProfileAttachmentState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: ProfileAttachmentFlow.showResult,
        ),
      ],
      child: BlocBuilder<EditProfileCubit, EditProfileState>(
        builder: (context, state) {
          return PopScope(
            canPop: !state.isDirty,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop && !state.isSubmitting) _confirmDiscard();
            },
            child: AppLoadingOverlay(
              isLoading: state.isSubmitting,
              child: Scaffold(
                appBar: AppAppBar(
                  title: context.l10n.editProfileTitle,
                  onBack: () => Navigator.of(context).maybePop(),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: _buildForm(
                        context,
                        state.draft,
                        context.select(
                          (ProfileCubit cubit) =>
                              cubit.state.profile?.hasNationalIdPicture ?? false,
                        ),
                      ),
                    ),
                    _BottomBar(onSave: state.canSave ? _submit : null),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, ProfileDetails draft, bool hasNationalIdPicture) {
    final scope = EditProfileFormScope(
      draft: draft,
      edit: _cubit.edit,
      isMissing: (field) => _isMissing(field, draft, hasNationalIdPicture),
      anchor: (field, child) => KeyedSubtree(key: _fieldKeys[field], child: child),
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.screenMargin),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const EditProfileAvatar(),
            SizedBox(height: AppSpacing.md),
            EditProfileNameFields(
              scope: scope,
              fullNameArController: _fullNameArController,
              fullNameEnController: _fullNameEnController,
            ),
            SizedBox(height: AppSpacing.sm),
            const EditProfileContactFields(),
            SizedBox(height: AppSpacing.sm),
            EditProfilePersonalSection(
              scope: scope,
              majorController: _majorController,
              universityNameController: _universityNameController,
            ),
            SizedBox(height: AppSpacing.lg),
            EditProfileAddressSection(
              scope: scope,
              nearestLandmarkController: _nearestLandmarkController,
              districtController: _districtController,
              neighborhoodController: _neighborhoodController,
              detailedAddressController: _detailedAddressController,
            ),
            SizedBox(height: AppSpacing.lg),
            EditProfileVolunteeringSection(
              scope: scope,
              weeklyHoursController: _weeklyHoursController,
              otherSubjectsController: _otherSubjectsController,
            ),
            SizedBox(height: AppSpacing.lg),
            scope.anchor(
              ProfileMissingField.nationalIdPicture,
              EditProfileDocumentsSection(
                isNationalIdMissing: scope.isMissing(ProfileMissingField.nationalIdPicture),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onSave});

  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final percentage = context.select(
      (ProfileCubit cubit) => cubit.state.profile?.completionPercentage ?? 0,
    );
    return EditProfileBottomBar(percentage: percentage, onSave: onSave);
  }
}
