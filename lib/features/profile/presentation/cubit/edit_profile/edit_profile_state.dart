import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_lookups_repository.dart';
import '../../../domain/repositories/profile_repository.dart';

class EditProfileState extends Equatable {
  const EditProfileState({
    this.isLoading = false,
    this.profile,
    this.countries = const [],
    this.cities = const [],
    this.educations = const [],
    this.volunteeringTypes = const [],
    this.loadError,
    this.submitStatus = FormStatus.initial,
    this.submitError,
  });

  final bool isLoading;
  final Profile? profile;
  final List<Country> countries;
  final List<City> cities;
  final List<Education> educations;
  final List<VolunteeringType> volunteeringTypes;
  final String? loadError;
  final FormStatus submitStatus;
  final String? submitError;

  EditProfileState copyWith({
    bool? isLoading,
    Profile? profile,
    List<Country>? countries,
    List<City>? cities,
    List<Education>? educations,
    List<VolunteeringType>? volunteeringTypes,
    String? loadError,
    FormStatus? submitStatus,
    String? submitError,
  }) {
    return EditProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      countries: countries ?? this.countries,
      cities: cities ?? this.cities,
      educations: educations ?? this.educations,
      volunteeringTypes: volunteeringTypes ?? this.volunteeringTypes,
      loadError: loadError,
      submitStatus: submitStatus ?? this.submitStatus,
      submitError: submitError,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        profile,
        countries,
        cities,
        educations,
        volunteeringTypes,
        loadError,
        submitStatus,
        submitError,
      ];
}
