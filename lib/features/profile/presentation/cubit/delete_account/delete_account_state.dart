import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class DeleteAccountState extends Equatable {
  const DeleteAccountState({this.status = FormStatus.initial, this.errorMessage});

  final FormStatus status;
  final String? errorMessage;

  bool get isSubmitting => status == FormStatus.submitting;

  @override
  List<Object?> get props => [status, errorMessage];
}
