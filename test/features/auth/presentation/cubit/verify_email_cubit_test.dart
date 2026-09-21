import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shababna/core/error/failures.dart';
import 'package:shababna/core/state/form_status.dart';
import 'package:shababna/features/auth/domain/repositories/auth_repository.dart';
import 'package:shababna/features/auth/presentation/cubit/verify_email/verify_email_cubit.dart';
import 'package:shababna/features/auth/presentation/cubit/verify_email/verify_email_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  void stubVerify(Either<Failure, void> result) {
    when(
      () => repository.verifyEmail(
        email: any(named: 'email'),
        code: any(named: 'code'),
      ),
    ).thenAnswer((_) async => result);
  }

  group('verify', () {
    blocTest<VerifyEmailCubit, VerifyEmailState>(
      'emits submitting then success',
      build: () {
        stubVerify(const Right(null));
        return VerifyEmailCubit(repository);
      },
      act: (cubit) => cubit.verify(email: 'user@example.com', code: '482913'),
      expect: () => [
        const VerifyEmailState(status: FormStatus.submitting),
        const VerifyEmailState(status: FormStatus.success),
      ],
      verify: (_) {
        verify(
          () => repository.verifyEmail(email: 'user@example.com', code: '482913'),
        ).called(1);
      },
    );

    blocTest<VerifyEmailCubit, VerifyEmailState>(
      'emits submitting then failure with the backend message',
      build: () {
        stubVerify(const Left(ValidationFailure('Invalid or expired code')));
        return VerifyEmailCubit(repository);
      },
      act: (cubit) => cubit.verify(email: 'user@example.com', code: '000000'),
      expect: () => [
        const VerifyEmailState(status: FormStatus.submitting),
        const VerifyEmailState(
          status: FormStatus.failure,
          errorMessage: 'Invalid or expired code',
        ),
      ],
    );
  });

  group('resend', () {
    blocTest<VerifyEmailCubit, VerifyEmailState>(
      'clears any old message then emits the success message',
      build: () {
        when(() => repository.resendEmailVerification(email: any(named: 'email')))
            .thenAnswer((_) async => const Right('Code sent'));
        return VerifyEmailCubit(repository);
      },
      act: (cubit) => cubit.resend(email: 'user@example.com'),
      expect: () => [
        const VerifyEmailState(),
        const VerifyEmailState(resendMessage: 'Code sent'),
      ],
    );

    blocTest<VerifyEmailCubit, VerifyEmailState>(
      'flags a failed resend so the UI can pick the error style',
      build: () {
        when(() => repository.resendEmailVerification(email: any(named: 'email')))
            .thenAnswer((_) async => const Left(RateLimitFailure('Too many requests')));
        return VerifyEmailCubit(repository);
      },
      act: (cubit) => cubit.resend(email: 'user@example.com'),
      expect: () => [
        const VerifyEmailState(),
        const VerifyEmailState(resendMessage: 'Too many requests', resendFailed: true),
      ],
    );
  });
}
