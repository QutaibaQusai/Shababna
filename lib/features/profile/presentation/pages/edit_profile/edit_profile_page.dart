import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_date_field.dart';
import '../../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_picker_field.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/state/form_status.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/profile_lookups_repository.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../cubit/edit_profile/edit_profile_cubit.dart';
import '../../cubit/edit_profile/edit_profile_state.dart';
import '../../widgets/edit_profile/edit_profile_bottom_bar.dart';
import '../../widgets/edit_profile/edit_profile_picture_field.dart';
import '../../widgets/edit_profile/edit_profile_section_title.dart';
import '../../widgets/edit_profile/edit_profile_skeleton.dart';
import '../../widgets/edit_profile/field_card.dart';
import '../../widgets/edit_profile/gender_option.dart';
import '../../widgets/edit_profile/multi_select_field.dart';
import '../../widgets/edit_profile/switch_row.dart';
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
        return AppLoadingOverlay(
          isLoading: state.submitStatus == FormStatus.submitting,
          child: Scaffold(
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
                        : _buildContent(context, state, state.profile!),
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
                EditProfilePictureField(
                  hasPicture: profile.hasProfilePicture,
                  pictureUrl: profile.profilePictureUrl,
                  onTap: () => _navigateAndReload(
                    context,
                    AppRoutes.editProfilePicture,
                    extra: EditProfilePictureArgs(
                      hasPicture: profile.hasProfilePicture,
                      pictureUrl: profile.profilePictureUrl,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                EditProfileSectionTitle(title: context.l10n.personalInfoSectionTitle),
                SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: context.l10n.fullNameLabel,
                  controller: TextEditingController(
                    text: context.isArabic ? profile.fullNameAr : profile.fullNameEn,
                  ),
                  readOnly: true,
                  prefixIcon: LucideIcons.user,
                ),
                SizedBox(height: AppSpacing.sm),
                FieldCard(
                  label: context.l10n.phoneNumberLabel,
                  icon: LucideIcons.phone,
                  value: profile.phoneNumber,
                  valueDirection: TextDirection.ltr,
                  onTap: () => _navigateAndReload(
                    context,
                    AppRoutes.changePhoneNumber,
                    extra: profile.phoneNumber,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                FieldCard(
                  label: context.l10n.emailLabel,
                  icon: LucideIcons.mail,
                  value: profile.email,
                  isVerified: profile.emailConfirmed,
                  onTap: () => _navigateAndReload(context, AppRoutes.changeEmail),
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: GenderOption(
                        label: context.l10n.genderMale,
                        icon: Icons.male,
                        selected: _gender == ProfileGender.male,
                        onTap: () => setState(() => _gender = ProfileGender.male),
                      ),
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: GenderOption(
                        label: context.l10n.genderFemale,
                        icon: Icons.female,
                        selected: _gender == ProfileGender.female,
                        onTap: () => setState(() => _gender = ProfileGender.female),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                AppDateField(
                  label: context.l10n.dateOfBirthLabel,
                  value: _dateOfBirth,
                  onChanged: (value) => setState(() => _dateOfBirth = value),
                ),
                SizedBox(height: AppSpacing.sm),
                AppPickerField<Country>(
                  label: context.l10n.nationalityLabel,
                  items: state.countries,
                  itemLabel: (item) => item.displayName(context.isArabic),
                  selectedItem: _nationality,
                  onSelected: (value) => setState(() => _nationality = value),
                  searchHint: context.l10n.actionSearch,
                  prefixIcon: LucideIcons.flag,
                ),
                SizedBox(height: AppSpacing.sm),
                AppPickerField<City>(
                  label: context.l10n.cityLabel,
                  items: state.cities,
                  itemLabel: (item) => item.displayName(context.isArabic),
                  selectedItem: _city,
                  onSelected: (value) => setState(() => _city = value),
                  searchHint: context.l10n.actionSearch,
                  prefixIcon: LucideIcons.mapPin,
                ),
                SizedBox(height: AppSpacing.sm),
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
                SizedBox(height: AppSpacing.lg),
                EditProfileSectionTitle(title: context.l10n.addressSectionTitle),
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
                SizedBox(height: AppSpacing.lg),
                EditProfileSectionTitle(title: context.l10n.volunteeringSectionTitle),
                SizedBox(height: AppSpacing.sm),
                SwitchRow(
                  label: context.l10n.isFirstTimeVolunteerLabel,
                  value: _isFirstTimeVolunteer,
                  onChanged: (value) => setState(() => _isFirstTimeVolunteer = value),
                ),
                SwitchRow(
                  label: context.l10n.volunteerAwardsLabel,
                  value: _volunteerAwards,
                  onChanged: (value) => setState(() => _volunteerAwards = value),
                ),
                SwitchRow(
                  label: context.l10n.isAvailableToVolunteerLabel,
                  value: _isAvailableToVolunteer,
                  onChanged: (value) => setState(() => _isAvailableToVolunteer = value),
                ),
                SwitchRow(
                  label: context.l10n.willSignVolunteerServiceAgreementLabel,
                  value: _willSignVolunteerServiceAgreement,
                  onChanged: (value) =>
                      setState(() => _willSignVolunteerServiceAgreement = value),
                ),
                SwitchRow(
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
                MultiSelectField<VolunteeringType>(
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
                ),
                SizedBox(height: AppSpacing.lg),
                EditProfileSectionTitle(title: context.l10n.documentsSectionTitle),
                SizedBox(height: AppSpacing.sm),
                FieldCard(
                  label: context.l10n.cvLabel,
                  icon: LucideIcons.fileText,
                  value: profile.hasCv
                      ? (profile.cvFileName ?? context.l10n.documentUploadedStatus)
                      : context.l10n.documentNotUploadedStatus,
                  onTap: () => _navigateAndReload(
                    context,
                    AppRoutes.editCv,
                    extra: EditCvArgs(hasCv: profile.hasCv, cvFileName: profile.cvFileName),
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                FieldCard(
                  label: context.l10n.nationalIdPictureLabel,
                  icon: LucideIcons.idCard,
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
        EditProfileBottomBar(percentage: profile.completionPercentage, onSave: _submit),
      ],
    );
  }
}
