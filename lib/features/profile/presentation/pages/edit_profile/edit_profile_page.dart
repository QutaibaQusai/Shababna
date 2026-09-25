import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_card.dart';
import '../../../../../core/shared/widgets/app_date_field.dart';
import '../../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_multi_select_field.dart';
import '../../../../../core/shared/widgets/app_picker_field.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/state/form_status.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/profile_lookups_repository.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../cubit/edit_profile/edit_profile_cubit.dart';
import '../../cubit/edit_profile/edit_profile_state.dart';
import '../../widgets/edit_profile/edit_profile_skeleton.dart';
import '../edit_cv/edit_cv_args.dart';
import '../edit_profile_picture/edit_profile_picture_args.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EditProfileCubit>()..load(),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  bool _initialized = false;

  final _majorController = TextEditingController();
  final _universityNameController = TextEditingController();
  final _nearestLandmarkController = TextEditingController();
  final _districtController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _detailedAddressController = TextEditingController();
  final _estimatedWeeklyHoursController = TextEditingController();
  final _otherVolunteeringSubjectsController = TextEditingController();

  ProfileGender? _gender;
  DateTime? _dateOfBirth;
  Country? _nationality;
  City? _city;
  Education? _education;
  bool _isFirstTimeVolunteer = false;
  bool _volunteerAwards = false;
  bool _isAvailableToVolunteer = false;
  bool _willSignVolunteerServiceAgreement = false;
  bool _willProvideNcc = false;
  List<VolunteeringType> _volunteeringTypes = [];

  @override
  void dispose() {
    _majorController.dispose();
    _universityNameController.dispose();
    _nearestLandmarkController.dispose();
    _districtController.dispose();
    _neighborhoodController.dispose();
    _detailedAddressController.dispose();
    _estimatedWeeklyHoursController.dispose();
    _otherVolunteeringSubjectsController.dispose();
    super.dispose();
  }

  T? _findById<T>(List<T> items, String? id, String Function(T) idOf) {
    if (id == null) return null;
    for (final item in items) {
      if (idOf(item) == id) return item;
    }
    return null;
  }

  void _syncFromProfile(EditProfileState state) {
    final profile = state.profile;
    if (profile == null || _initialized) return;
    _initialized = true;

    _majorController.text = profile.major ?? '';
    _universityNameController.text = profile.universityName ?? '';
    _nearestLandmarkController.text = profile.nearestLandmark ?? '';
    _districtController.text = profile.district ?? '';
    _neighborhoodController.text = profile.neighborhood ?? '';
    _detailedAddressController.text = profile.detailedAddress ?? '';
    _estimatedWeeklyHoursController.text = profile.estimatedWeeklyHours?.toString() ?? '';
    _otherVolunteeringSubjectsController.text = profile.otherVolunteeringSubjects ?? '';

    _gender = profile.gender;
    _dateOfBirth = profile.dateOfBirth == null ? null : DateTime.tryParse(profile.dateOfBirth!);
    _nationality = _findById(state.countries, profile.nationality?.id, (c) => c.id);
    _city = _findById(state.cities, profile.city?.id, (c) => c.id);
    _education = _findById(state.educations, profile.education?.id, (e) => e.id);
    _isFirstTimeVolunteer = profile.isFirstTimeVolunteer;
    _volunteerAwards = profile.volunteerAwards ?? false;
    _isAvailableToVolunteer = profile.isAvailableToVolunteer ?? false;
    _willSignVolunteerServiceAgreement = profile.willSignVolunteerServiceAgreement ?? false;
    _willProvideNcc = profile.willProvideNcc ?? false;
    _volunteeringTypes = profile.volunteeringTypes
        .map((reference) => _findById(state.volunteeringTypes, reference.id, (v) => v.id))
        .whereType<VolunteeringType>()
        .toList();
  }

  String? _orNull(String text) => text.trim().isEmpty ? null : text.trim();

  String _isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> _navigateAndReload(BuildContext context, String route, {Object? extra}) async {
    final changed = await context.push<bool>(route, extra: extra);
    if (changed == true && context.mounted) {
      context.read<EditProfileCubit>().load();
    }
  }

  void _submit() {
    context.read<EditProfileCubit>().submit(
          nationalityId: _nationality?.id,
          cityId: _city?.id,
          dateOfBirth: _dateOfBirth == null ? null : _isoDate(_dateOfBirth!),
          gender: _gender,
          educationId: _education?.id,
          major: _education?.isMajorRequired == true ? _orNull(_majorController.text) : null,
          universityName: _orNull(_universityNameController.text),
          isFirstTimeVolunteer: _isFirstTimeVolunteer,
          nearestLandmark: _orNull(_nearestLandmarkController.text),
          district: _orNull(_districtController.text),
          neighborhood: _orNull(_neighborhoodController.text),
          detailedAddress: _orNull(_detailedAddressController.text),
          volunteerAwards: _volunteerAwards,
          isAvailableToVolunteer: _isAvailableToVolunteer,
          estimatedWeeklyHours: int.tryParse(_estimatedWeeklyHoursController.text.trim()),
          willSignVolunteerServiceAgreement: _willSignVolunteerServiceAgreement,
          willProvideNcc: _willProvideNcc,
          volunteeringTypeIds: _volunteeringTypes.map((item) => item.id).toList(),
          otherVolunteeringSubjects: _orNull(_otherVolunteeringSubjectsController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        _syncFromProfile(state);
        if (state.submitStatus == FormStatus.success) {
          AppToast.success(context, context.l10n.editProfileSuccessMessage);
        } else if (state.submitStatus == FormStatus.failure) {
          AppToast.error(context, state.submitError ?? context.l10n.somethingWentWrong);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppAppBar(title: context.l10n.editProfileTitle, onBack: () => context.pop()),
          body: state.isLoading
              ? const EditProfileSkeleton()
              : state.loadError != null
                  ? AppErrorWidget(
                      message: state.loadError!,
                      onRetry: () => context.read<EditProfileCubit>().load(),
                    )
                  : state.profile == null
                      ? const SizedBox.shrink()
                      : AppLoadingOverlay(
                          isLoading: state.submitStatus == FormStatus.submitting,
                          child: _buildContent(context, state, state.profile!),
                        ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, EditProfileState state, Profile profile) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.screenMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _NameCard(profile: profile),
                SizedBox(height: AppSpacing.sm),
                _StatusRow(
                  icon: LucideIcons.image,
                  title: context.l10n.profilePictureLabel,
                  value: profile.hasProfilePicture
                      ? context.l10n.documentUploadedStatus
                      : context.l10n.documentNotUploadedStatus,
                  onTap: () => _navigateAndReload(
                    context,
                    AppRoutes.editProfilePicture,
                    extra: EditProfilePictureArgs(
                      hasPicture: profile.hasProfilePicture,
                      pictureUrl: profile.profilePictureUrl,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                _StatusRow(
                  icon: LucideIcons.phone,
                  title: context.l10n.phoneNumberLabel,
                  value: profile.phoneNumber,
                  onTap: () => _navigateAndReload(
                    context,
                    AppRoutes.changePhoneNumber,
                    extra: profile.phoneNumber,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                _StatusRow(
                  icon: LucideIcons.mail,
                  title: context.l10n.emailLabel,
                  value: profile.email,
                  isVerified: profile.emailConfirmed,
                  onTap: () => _navigateAndReload(context, AppRoutes.changeEmail),
                ),
                SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(context.l10n.genderLabel, style: context.textTheme.titleSmall),
                      SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Expanded(
                            child: _GenderOption(
                              label: context.l10n.genderMale,
                              icon: Icons.male,
                              selected: _gender == ProfileGender.male,
                              onTap: () => setState(() => _gender = ProfileGender.male),
                            ),
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: _GenderOption(
                              label: context.l10n.genderFemale,
                              icon: Icons.female,
                              selected: _gender == ProfileGender.female,
                              onTap: () => setState(() => _gender = ProfileGender.female),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: AppDateField(
                    label: context.l10n.dateOfBirthLabel,
                    value: _dateOfBirth,
                    onChanged: (value) => setState(() => _dateOfBirth = value),
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: AppPickerField<Country>(
                    label: context.l10n.nationalityLabel,
                    items: state.countries,
                    itemLabel: (item) => item.displayName(context.isArabic),
                    selectedItem: _nationality,
                    onSelected: (value) => setState(() => _nationality = value),
                    searchHint: context.l10n.actionSearch,
                    prefixIcon: LucideIcons.flag,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: AppPickerField<City>(
                    label: context.l10n.cityLabel,
                    items: state.cities,
                    itemLabel: (item) => item.displayName(context.isArabic),
                    selectedItem: _city,
                    onSelected: (value) => setState(() => _city = value),
                    searchHint: context.l10n.actionSearch,
                    prefixIcon: LucideIcons.mapPin,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppPickerField<Education>(
                        label: context.l10n.educationLabel,
                        items: state.educations,
                        itemLabel: (item) => item.displayName(context.isArabic),
                        selectedItem: _education,
                        onSelected: (value) => setState(() => _education = value),
                        searchHint: context.l10n.actionSearch,
                        prefixIcon: LucideIcons.graduationCap,
                      ),
                      if (_education?.isMajorRequired == true) ...[
                        SizedBox(height: AppSpacing.sm),
                        AppTextField(
                          label: context.l10n.majorLabel,
                          controller: _majorController,
                          prefixIcon: LucideIcons.bookOpen,
                        ),
                      ],
                      SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        label: context.l10n.universityNameLabel,
                        controller: _universityNameController,
                        prefixIcon: LucideIcons.school,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(context.l10n.addressSectionTitle, style: context.textTheme.titleSmall),
                      SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        label: context.l10n.nearestLandmarkLabel,
                        controller: _nearestLandmarkController,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        label: context.l10n.districtLabel,
                        controller: _districtController,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        label: context.l10n.neighborhoodLabel,
                        controller: _neighborhoodController,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        label: context.l10n.detailedAddressLabel,
                        controller: _detailedAddressController,
                        maxLines: 3,
                        minLines: 2,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        context.l10n.volunteeringSectionTitle,
                        style: context.textTheme.titleSmall,
                      ),
                      SizedBox(height: AppSpacing.xs),
                      _SwitchRow(
                        label: context.l10n.isFirstTimeVolunteerLabel,
                        value: _isFirstTimeVolunteer,
                        onChanged: (value) => setState(() => _isFirstTimeVolunteer = value),
                      ),
                      _SwitchRow(
                        label: context.l10n.volunteerAwardsLabel,
                        value: _volunteerAwards,
                        onChanged: (value) => setState(() => _volunteerAwards = value),
                      ),
                      _SwitchRow(
                        label: context.l10n.isAvailableToVolunteerLabel,
                        value: _isAvailableToVolunteer,
                        onChanged: (value) => setState(() => _isAvailableToVolunteer = value),
                      ),
                      _SwitchRow(
                        label: context.l10n.willSignVolunteerServiceAgreementLabel,
                        value: _willSignVolunteerServiceAgreement,
                        onChanged: (value) =>
                            setState(() => _willSignVolunteerServiceAgreement = value),
                      ),
                      _SwitchRow(
                        label: context.l10n.willProvideNccLabel,
                        value: _willProvideNcc,
                        onChanged: (value) => setState(() => _willProvideNcc = value),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        label: context.l10n.estimatedWeeklyHoursLabel,
                        controller: _estimatedWeeklyHoursController,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppMultiSelectField<VolunteeringType>(
                        label: context.l10n.volunteeringTypesLabel,
                        items: state.volunteeringTypes,
                        itemLabel: (item) => item.displayName(context.isArabic),
                        selectedItems: _volunteeringTypes,
                        onChanged: (value) => setState(() => _volunteeringTypes = value),
                        searchHint: context.l10n.actionSearch,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        label: context.l10n.otherVolunteeringSubjectsLabel,
                        controller: _otherVolunteeringSubjectsController,
                        maxLines: 3,
                        minLines: 2,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                _StatusRow(
                  icon: LucideIcons.fileText,
                  title: context.l10n.cvLabel,
                  value: profile.hasCv
                      ? (profile.cvFileName ?? context.l10n.documentUploadedStatus)
                      : context.l10n.documentNotUploadedStatus,
                  onTap: () => _navigateAndReload(
                    context,
                    AppRoutes.editCv,
                    extra: EditCvArgs(hasCv: profile.hasCv, cvFileName: profile.cvFileName),
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                _StatusRow(
                  icon: LucideIcons.idCard,
                  title: context.l10n.nationalIdPictureLabel,
                  value: profile.hasNationalIdPicture
                      ? context.l10n.documentUploadedStatus
                      : context.l10n.documentNotUploadedStatus,
                  onTap: () => _navigateAndReload(
                    context,
                    AppRoutes.editNationalId,
                    extra: profile.hasNationalIdPicture,
                  ),
                ),
              ],
            ),
          ),
        ),
        _BottomBar(percentage: profile.completionPercentage, onSave: _submit),
      ],
    );
  }
}

class _NameCard extends StatelessWidget {
  const _NameCard({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final name = context.isArabic ? profile.fullNameAr : profile.fullNameEn;

    return AppCard(
      child: Row(
        children: [
          Icon(LucideIcons.user, size: AppSizes.iconMd, color: context.colorScheme.onSurface),
          SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              name,
              style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.icon,
    required this.title,
    required this.value,
    this.isVerified = false,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? value;
  final bool isVerified;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Icon(icon, size: AppSizes.iconMd, color: context.colorScheme.onSurfaceVariant),
            SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxs),
                  Text(value ?? '-', style: context.textTheme.bodyLarge),
                ],
              ),
            ),
            if (isVerified) ...[
              Icon(LucideIcons.badgeCheck, size: AppSizes.iconMd, color: context.colorScheme.primary),
              SizedBox(width: AppSpacing.xs),
            ],
            if (onTap != null)
              Icon(
                context.isRTL ? LucideIcons.chevronLeft : LucideIcons.chevronRight,
                size: AppSizes.iconMd,
                color: context.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.mdRadius,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? context.colorScheme.primary : context.colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
          borderRadius: AppRadius.mdRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSizes.iconMd,
              color: selected ? context.colorScheme.primary : context.colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: AppSpacing.xxs),
            Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: selected ? context.colorScheme.primary : context.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: context.textTheme.bodyMedium)),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.percentage, required this.onSave});

  final int percentage;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          border: Border(top: BorderSide(color: context.colorScheme.outlineVariant)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.completeYourProfileLabel,
                  style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer,
                    borderRadius: AppRadius.pillRadius,
                  ),
                  child: Text(
                    '$percentage%',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            AppButton.primary(label: context.l10n.saveButton, onPressed: onSave),
          ],
        ),
      ),
    );
  }
}
