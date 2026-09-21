import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shababna/core/error/failures.dart';
import 'package:shababna/core/state/form_status.dart';
import 'package:shababna/features/auth/domain/repositories/auth_repository.dart';
import 'package:shababna/features/auth/presentation/cubit/forgot_password/verify_reset_code_cubit.dart';
import 'package:shababna/features/auth/presentation/cubit/forgot_password/verify_reset_code_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  group('verify', () {
    blocTest<VerifyResetCodeCubit, VerifyResetCodeState>(
      'emits submitting then success carrying the reset token',
      build: () {
        when(
          () => repository.verifyResetCode(
            email: any(named: 'email'),
            code: any(named: 'code'),
          ),
        ).thenAnswer((_) async => const Right('token-123'));
        return VerifyResetCodeCubit(repository);
      },
      act: (cubit) => cubit.verify(email: 'user@example.com', code: '482913'),
      expect: () => [
        const VerifyResetCodeState(status: FormStatus.submitting),
        const VerifyResetCodeState(status: FormStatus.success, resetToken: 'token-123'),
      ],
      verify: (_) {
        verify(
          () => repository.verifyResetCode(email: 'user@example.com', code: '482913'),
        ).called(1);
      },
    );

    blocTest<VerifyResetCodeCubit, VerifyResetCodeState>(
      'emits submitting then failure with the display message and no token',
      build: () {
        when(
          () => repository.verifyResetCode(
            email: any(named: 'email'),
            code: any(named: 'code'),
          ),
        ).thenAnswer((_) async => const Left(ServerFailure('Invalid or expired code')));
        return VerifyResetCodeCubit(repository);
      },
      act: (cubit) => cubit.verify(email: 'user@example.com', code: '000000'),
      expect: () => [
        const VerifyResetCodeState(status: FormStatus.submitting),
        const VerifyResetCodeState(
          status: FormStatus.failure,
          errorMessage: 'Invalid or expired code',
        ),
      ],
    );

    blocTest<VerifyResetCodeCubit, VerifyResetCodeState>(
      'surfaces the first field error of a validation failure',
      build: () {
        when(
          () => repository.verifyResetCode(
            email: any(named: 'email'),
            code: any(named: 'code'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            ValidationFailure(
              'Validation failed',
              errors: {
                'code': ['Code is invalid'],
              },
            ),
          ),
        );
        return VerifyResetCodeCubit(repository);
      },
      act: (cubit) => cubit.verify(email: 'user@example.com', code: '1'),
      expect: () => [
        const VerifyResetCodeState(status: FormStatus.submitting),
        const VerifyResetCodeState(
          status: FormStatus.failure,
          errorMessage: 'Code is invalid',
        ),
      ],
    );
  });

  group('resend', () {
    blocTest<VerifyResetCodeCubit, VerifyResetCodeState>(
      'clears any old message then emits the success message',
      build: () {
        when(() => repository.forgotPassword(email: any(named: 'email')))
            .thenAnswer((_) async => const Right('Code sent'));
        return VerifyResetCodeCubit(repository);
      },
      act: (cubit) => cubit.resend(email: 'user@example.com'),
      expect: () => [
        const VerifyResetCodeState(),
        const VerifyResetCodeState(resendMessage: 'Code sent'),
      ],
    );

    blocTest<VerifyResetCodeCubit, VerifyResetCodeState>(
      'flags a failed resend so the UI can pick the error style',
      build: () {
        when(() => repository.forgotPassword(email: any(named: 'email')))
            .thenAnswer((_) async => const Left(RateLimitFailure('Too many requests')));
        return VerifyResetCodeCubit(repository);
      },
      act: (cubit) => cubit.resend(email: 'user@example.com'),
      expect: () => [
        const VerifyResetCodeState(),
        const VerifyResetCodeState(
          resendMessage: 'Too many requests',
          resendFailed: true,
        ),
      ],
    );

    blocTest<VerifyResetCodeCubit, VerifyResetCodeState>(
      'clears the previous message first so an identical message is emitted again',
      build: () {
        when(() => repository.forgotPassword(email: any(named: 'email')))
            .thenAnswer((_) async => const Right('Code sent'));
        return VerifyResetCodeCubit(repository);
      },
      act: (cubit) async {
        await cubit.resend(email: 'user@example.com');
        await cubit.resend(email: 'user@example.com');
      },
      expect: () => [
        const VerifyResetCodeState(),
        const VerifyResetCodeState(resendMessage: 'Code sent'),
        const VerifyResetCodeState(),
        const VerifyResetCodeState(resendMessage: 'Code sent'),
      ],
    );
  });
}
