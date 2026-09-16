import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class LoginState extends Equatable {
  const LoginState({this.status = FormStatus.initial, this.errorMessage});

  final FormStatus status;
  final String? errorMessage;

  LoginState copyWith({FormStatus? status, String? errorMessage}) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
