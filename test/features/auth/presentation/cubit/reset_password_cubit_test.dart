import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shababna/core/error/failures.dart';
import 'package:shababna/core/state/form_status.dart';
import 'package:shababna/features/auth/domain/repositories/auth_repository.dart';
import 'package:shababna/features/auth/presentation/cubit/reset_password/reset_password_cubit.dart';
import 'package:shababna/features/auth/presentation/cubit/reset_password/reset_password_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  void stubResetPassword(Either<Failure, void> result) {
    when(
      () => repository.resetPassword(
        email: any(named: 'email'),
        resetToken: any(named: 'resetToken'),
        newPassword: any(named: 'newPassword'),
        confirmPassword: any(named: 'confirmPassword'),
      ),
    ).thenAnswer((_) async => result);
  }

  blocTest<ResetPasswordCubit, ResetPasswordState>(
    'sends the reset token and emits submitting then success',
    build: () {
      stubResetPassword(const Right(null));
      return ResetPasswordCubit(repository);
    },
    act: (cubit) => cubit.submit(
      email: 'user@example.com',
      resetToken: 'token-123',
      newPassword: 'NewPass#1',
      confirmPassword: 'NewPass#1',
    ),
    expect: () => [
      const ResetPasswordState(status: FormStatus.submitting),
      const ResetPasswordState(status: FormStatus.success),
    ],
    verify: (_) {
      verify(
        () => repository.resetPassword(
          email: 'user@example.com',
          resetToken: 'token-123',
          newPassword: 'NewPass#1',
          confirmPassword: 'NewPass#1',
        ),
      ).called(1);
    },
  );

  blocTest<ResetPasswordCubit, ResetPasswordState>(
    'emits submitting then failure with the backend message',
    build: () {
      stubResetPassword(const Left(ValidationFailure('Password is too weak')));
      return ResetPasswordCubit(repository);
    },
    act: (cubit) => cubit.submit(
      email: 'user@example.com',
      resetToken: 'token-123',
      newPassword: 'weak',
      confirmPassword: 'weak',
    ),
    expect: () => [
      const ResetPasswordState(status: FormStatus.submitting),
      const ResetPasswordState(
        status: FormStatus.failure,
        errorMessage: 'Password is too weak',
      ),
    ],
  );
}
