import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class LogoutState extends Equatable {
  const LogoutState({this.status = FormStatus.initial});

  final FormStatus status;

  LogoutState copyWith({FormStatus? status}) {
    return LogoutState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
