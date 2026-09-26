import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../widgets/edit_profile/profile_birth_date_field.dart';
import '../../../../../core/shared/widgets/app_dialog.dart';
import '../../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/state/form_status.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../../domain/repositories/profile_lookups_repository.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../cubit/edit_profile/edit_profile_cubit.dart';
import '../../cubit/edit_profile/edit_profile_state.dart';
import '../../cubit/profile/profile_cubit.dart';
import '../../cubit/profile/profile_state.dart';
import '../../cubit/profile_attachment/profile_attachment_cubit.dart';
import '../../cubit/profile_attachment/profile_attachment_state.dart';
import '../../widgets/edit_profile/edit_profile_account_fields.dart';
import '../../widgets/edit_profile/edit_profile_bottom_bar.dart';
import '../../widgets/edit_profile/edit_profile_documents_section.dart';
import '../../widgets/edit_profile/edit_profile_section_title.dart';
import '../../widgets/edit_profile/edit_profile_skeleton.dart';
import '../../widgets/edit_profile/gender_option.dart';
import '../../widgets/edit_profile/profile_attachment_flow.dart';
import '../../widgets/edit_profile/profile_lookup_field.dart';
import '../../widgets/edit_profile/switch_row.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ProfileCubit>(),
      child: const _EditProfileGate(),
    );
  }
}

class _EditProfileGate extends StatefulWidget {
  const _EditProfileGate();

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
            child: const _EditProfileView(),
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
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  static const _minWeeklyHours = 1;
  static const _maxWeeklyHours = 168;

  final _formKey = GlobalKey<FormState>();
  final _lookups = sl<ProfileLookupsRepository>();

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
  }

  @override
  void dispose() {
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

    sync(_majorController, details.major);
    sync(_universityNameController, details.universityName);
    sync(_nearestLandmarkController, details.nearestLandmark);
    sync(_districtController, details.district);
    sync(_neighborhoodController, details.neighborhood);
    sync(_detailedAddressController, details.detailedAddress);
    sync(_weeklyHoursController, details.estimatedWeeklyHours);
    sync(_otherSubjectsController, details.otherVolunteeringSubjects);
  }

  void _edit(ProfileDetails Function(ProfileDetails draft) change) => _cubit.edit(change);

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

  String? _validateWeeklyHours(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final hours = int.tryParse(text);
    if (hours == null || hours < _minWeeklyHours || hours > _maxWeeklyHours) {
      return context.l10n.weeklyHoursRangeError(_minWeeklyHours, _maxWeeklyHours);
    }
    return null;
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
                    Expanded(child: _buildForm(context, state.draft)),
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

  Widget _buildForm(BuildContext context, ProfileDetails draft) {
    final isArabic = context.isArabic;

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
            EditProfileSectionTitle(title: context.l10n.personalInfoSectionTitle),
            SizedBox(height: AppSpacing.sm),
            const EditProfileContactFields(),
            SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: GenderOption(
                    label: context.l10n.genderMale,
                    icon: Icons.male,
                    selected: draft.gender == ProfileGender.male,
                    onTap: () => _edit((d) => d.copyWith(gender: ProfileGender.male)),
                  ),
                ),
                SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: GenderOption(
                    label: context.l10n.genderFemale,
                    icon: Icons.female,
                    selected: draft.gender == ProfileGender.female,
                    onTap: () => _edit((d) => d.copyWith(gender: ProfileGender.female)),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            ProfileBirthDateField(
              label: context.l10n.dateOfBirthLabel,
              value: draft.dateOfBirth,
              onChanged: (value) => _edit((d) => d.copyWith(dateOfBirth: value)),
            ),
            SizedBox(height: AppSpacing.sm),
            ProfileLookupField<Country>(
              label: context.l10n.nationalityLabel,
              icon: LucideIcons.flag,
              selectedId: draft.nationality?.id,
              selectedLabel: draft.nationality?.name,
              loader: _lookups.getCountries,
              idOf: (item) => item.id,
              itemLabel: (item) => item.displayName(isArabic),
              onSelected: (item) => _edit(
                (d) => d.copyWith(
                  nationality: ProfileReference(id: item.id, name: item.displayName(isArabic)),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            ProfileLookupField<City>(
              label: context.l10n.cityLabel,
              icon: LucideIcons.mapPin,
              selectedId: draft.city?.id,
              selectedLabel: draft.city?.name,
              loader: _lookups.getCities,
              idOf: (item) => item.id,
              itemLabel: (item) => item.displayName(isArabic),
              onSelected: (item) => _edit(
                (d) => d.copyWith(
                  city: ProfileReference(id: item.id, name: item.displayName(isArabic)),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            ProfileLookupField<Education>(
              label: context.l10n.educationLabel,
              icon: LucideIcons.graduationCap,
              selectedId: draft.education?.id,
              selectedLabel: draft.education?.name,
              loader: _lookups.getEducations,
              idOf: (item) => item.id,
              itemLabel: (item) => item.displayName(isArabic),
              onSelected: (item) => _edit(
                (d) => d.copyWith(
                  education: ProfileEducation(
                    id: item.id,
                    name: item.displayName(isArabic),
                    isMajorRequired: item.isMajorRequired,
                  ),
                ),
              ),
            ),
            if (draft.isMajorRequired) ...[
              SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: context.l10n.majorLabel,
                controller: _majorController,
                prefixIcon: LucideIcons.bookOpen,
                textInputAction: TextInputAction.next,
                onChanged: (value) => _edit((d) => d.copyWith(major: value)),
                validator: AppValidators.required(context.l10n.majorRequiredError),
              ),
            ],
            SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: context.l10n.universityNameLabel,
              controller: _universityNameController,
              prefixIcon: LucideIcons.school,
              textInputAction: TextInputAction.next,
              onChanged: (value) => _edit((d) => d.copyWith(universityName: value)),
            ),
            SizedBox(height: AppSpacing.lg),
            EditProfileSectionTitle(title: context.l10n.addressSectionTitle),
            SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: context.l10n.nearestLandmarkLabel,
              controller: _nearestLandmarkController,
              prefixIcon: LucideIcons.landmark,
              textInputAction: TextInputAction.next,
              onChanged: (value) => _edit((d) => d.copyWith(nearestLandmark: value)),
            ),
            SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: context.l10n.districtLabel,
              controller: _districtController,
              prefixIcon: LucideIcons.map,
              textInputAction: TextInputAction.next,
              onChanged: (value) => _edit((d) => d.copyWith(district: value)),
            ),
            SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: context.l10n.neighborhoodLabel,
              controller: _neighborhoodController,
              prefixIcon: LucideIcons.house,
              textInputAction: TextInputAction.next,
              onChanged: (value) => _edit((d) => d.copyWith(neighborhood: value)),
            ),
            SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: context.l10n.detailedAddressLabel,
              controller: _detailedAddressController,
              maxLines: 3,
              minLines: 2,
              onChanged: (value) => _edit((d) => d.copyWith(detailedAddress: value)),
            ),
            SizedBox(height: AppSpacing.lg),
            EditProfileSectionTitle(title: context.l10n.volunteeringSectionTitle),
            SizedBox(height: AppSpacing.sm),
            SwitchRow(
              label: context.l10n.isFirstTimeVolunteerLabel,
              value: draft.isFirstTimeVolunteer,
              onChanged: (value) => _edit((d) => d.copyWith(isFirstTimeVolunteer: value)),
            ),
            SwitchRow(
              label: context.l10n.volunteerAwardsLabel,
              value: draft.volunteerAwards,
              onChanged: (value) => _edit((d) => d.copyWith(volunteerAwards: value)),
            ),
            SwitchRow(
              label: context.l10n.isAvailableToVolunteerLabel,
              value: draft.isAvailableToVolunteer,
              onChanged: (value) => _edit((d) => d.copyWith(isAvailableToVolunteer: value)),
            ),
            SwitchRow(
              label: context.l10n.willSignVolunteerServiceAgreementLabel,
              value: draft.willSignVolunteerServiceAgreement,
              onChanged: (value) =>
                  _edit((d) => d.copyWith(willSignVolunteerServiceAgreement: value)),
            ),
            SwitchRow(
              label: context.l10n.willProvideNccLabel,
              value: draft.willProvideNcc,
              onChanged: (value) => _edit((d) => d.copyWith(willProvideNcc: value)),
            ),
            SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: context.l10n.estimatedWeeklyHoursLabel,
              controller: _weeklyHoursController,
              prefixIcon: LucideIcons.clock,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              onChanged: (value) => _edit((d) => d.copyWith(estimatedWeeklyHours: value)),
              validator: _validateWeeklyHours,
            ),
            SizedBox(height: AppSpacing.sm),
            ProfileLookupMultiField<VolunteeringType>(
              label: context.l10n.volunteeringTypesLabel,
              icon: LucideIcons.handHeart,
              selected: draft.volunteeringTypes,
              loader: _lookups.getVolunteeringTypes,
              idOf: (item) => item.id,
              itemLabel: (item) => item.displayName(isArabic),
              onChanged: (value) => _edit((d) => d.copyWith(volunteeringTypes: value)),
            ),
            SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: context.l10n.otherVolunteeringSubjectsLabel,
              controller: _otherSubjectsController,
              textInputAction: TextInputAction.done,
              onChanged: (value) => _edit((d) => d.copyWith(otherVolunteeringSubjects: value)),
            ),
            SizedBox(height: AppSpacing.lg),
            EditProfileSectionTitle(title: context.l10n.documentsSectionTitle),
            SizedBox(height: AppSpacing.sm),
            const EditProfileDocumentsSection(),
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
