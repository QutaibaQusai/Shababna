import 'package:equatable/equatable.dart';

import '../device_authenticator.dart';

class AppLockState extends Equatable {
  const AppLockState({
    this.isEnabled = false,
    this.isLocked = false,
    this.isAuthenticating = false,
    this.isAvailable,
    this.unlockResult,
  });

  final bool isEnabled;
  final bool isLocked;
  final bool isAuthenticating;
  final bool? isAvailable;
  final DeviceAuthResult? unlockResult;

  bool get canToggle => isEnabled || isAvailable == true;

  AppLockState copyWith({
    bool? isEnabled,
    bool? isLocked,
    bool? isAuthenticating,
    bool? isAvailable,
    DeviceAuthResult? Function()? unlockResult,
  }) {
    return AppLockState(
      isEnabled: isEnabled ?? this.isEnabled,
      isLocked: isLocked ?? this.isLocked,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      isAvailable: isAvailable ?? this.isAvailable,
      unlockResult: unlockResult != null ? unlockResult() : this.unlockResult,
    );
  }

  @override
  List<Object?> get props => [isEnabled, isLocked, isAuthenticating, isAvailable, unlockResult];
}
