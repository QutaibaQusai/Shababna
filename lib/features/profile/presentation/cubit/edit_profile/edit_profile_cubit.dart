import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_lookups_repository.dart';
import '../../../domain/repositories/profile_repository.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._profileRepository, this._lookupsRepository)
      : super(const EditProfileState());

  final ProfileRepository _profileRepository;
  final ProfileLookupsRepository _lookupsRepository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, loadError: null));

    final profileFuture = _profileRepository.getProfile();
    final countriesFuture = _lookupsRepository.getCountries();
    final citiesFuture = _lookupsRepository.getCities();
    final educationsFuture = _lookupsRepository.getEducations();
    final volunteeringTypesFuture = _lookupsRepository.getVolunteeringTypes();

    final profileResult = await profileFuture;
    final countriesResult = await countriesFuture;
    final citiesResult = await citiesFuture;
    final educationsResult = await educationsFuture;
    final volunteeringTypesResult = await volunteeringTypesFuture;

    final error = profileResult.fold((failure) => failure.displayMessage, (_) => null) ??
        countriesResult.fold((failure) => failure.displayMessage, (_) => null) ??
        citiesResult.fold((failure) => failure.displayMessage, (_) => null) ??
        educationsResult.fold((failure) => failure.displayMessage, (_) => null) ??
        volunteeringTypesResult.fold((failure) => failure.displayMessage, (_) => null);

    if (error != null) {
      emit(state.copyWith(isLoading: false, loadError: error));
      return;
    }

    emit(state.copyWith(
      isLoading: false,
      profile: profileResult.fold((_) => null, (profile) => profile),
      countries: countriesResult.fold((_) => <Country>[], (items) => items),
      cities: citiesResult.fold((_) => <City>[], (items) => items),
      educations: educationsResult.fold((_) => <Education>[], (items) => items),
      volunteeringTypes:
          volunteeringTypesResult.fold((_) => <VolunteeringType>[], (items) => items),
    ));
  }

  Future<void> submit({
    String? nationalityId,
    String? cityId,
    String? dateOfBirth,
    ProfileGender? gender,
    String? educationId,
    String? major,
    String? universityName,
    bool? isFirstTimeVolunteer,
    String? nearestLandmark,
    String? district,
    String? neighborhood,
    String? detailedAddress,
    bool? volunteerAwards,
    bool? isAvailableToVolunteer,
    int? estimatedWeeklyHours,
    bool? willSignVolunteerServiceAgreement,
    bool? willProvideNcc,
    List<String>? volunteeringTypeIds,
    String? otherVolunteeringSubjects,
  }) async {
    emit(state.copyWith(submitStatus: FormStatus.submitting, submitError: null));

    final result = await _profileRepository.updateDetails(
      nationalityId: nationalityId,
      cityId: cityId,
      dateOfBirth: dateOfBirth,
      gender: gender,
      educationId: educationId,
      major: major,
      universityName: universityName,
      isFirstTimeVolunteer: isFirstTimeVolunteer,
      nearestLandmark: nearestLandmark,
      district: district,
      neighborhood: neighborhood,
      detailedAddress: detailedAddress,
      volunteerAwards: volunteerAwards,
      isAvailableToVolunteer: isAvailableToVolunteer,
      estimatedWeeklyHours: estimatedWeeklyHours,
      willSignVolunteerServiceAgreement: willSignVolunteerServiceAgreement,
      willProvideNcc: willProvideNcc,
      volunteeringTypeIds: volunteeringTypeIds,
      otherVolunteeringSubjects: otherVolunteeringSubjects,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(submitStatus: FormStatus.failure, submitError: failure.displayMessage),
      ),
      (profile) => emit(state.copyWith(submitStatus: FormStatus.success, profile: profile)),
    );
  }
}
