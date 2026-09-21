import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shababna/core/error/failures.dart';
import 'package:shababna/core/state/form_status.dart';
import 'package:shababna/features/auth/domain/repositories/auth_repository.dart';
import 'package:shababna/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:shababna/features/auth/presentation/cubit/register/register_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  void stubRegister(Either<Failure, RegisterResult> result) {
    when(
      () => repository.register(
        email: any(named: 'email'),
        phoneNumber: any(named: 'phoneNumber'),
        fullNameEn: any(named: 'fullNameEn'),
        fullNameAr: any(named: 'fullNameAr'),
        password: any(named: 'password'),
        confirmPassword: any(named: 'confirmPassword'),
      ),
    ).thenAnswer((_) async => result);
  }

  Future<void> submit(RegisterCubit cubit) => cubit.submit(
        email: 'user@example.com',
        phoneNumber: '+962791234567',
        fullNameEn: 'Test User',
        fullNameAr: 'مستخدم',
        password: 'Passw0rd!',
        confirmPassword: 'Passw0rd!',
      );

  group('submit', () {
    blocTest<RegisterCubit, RegisterState>(
      'stores the registered email and that verification is required',
      build: () {
        stubRegister(
          const Right(
            RegisterResult(email: 'user@example.com', emailVerificationRequired: true),
          ),
        );
        return RegisterCubit(repository);
      },
      act: submit,
      expect: () => [
        const RegisterState(status: FormStatus.submitting),
        const RegisterState(
          status: FormStatus.success,
          registeredEmail: 'user@example.com',
          emailVerificationRequired: true,
        ),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'keeps the backend decision when verification is not required',
      build: () {
        stubRegister(
          const Right(
            RegisterResult(email: 'user@example.com', emailVerificationRequired: false),
          ),
        );
        return RegisterCubit(repository);
      },
      act: submit,
      expect: () => [
        const RegisterState(status: FormStatus.submitting),
        const RegisterState(
          status: FormStatus.success,
          registeredEmail: 'user@example.com',
          emailVerificationRequired: false,
        ),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'emits failure with the backend message',
      build: () {
        stubRegister(const Left(ConflictFailure('Email already registered')));
        return RegisterCubit(repository);
      },
      act: submit,
      expect: () => [
        const RegisterState(status: FormStatus.submitting),
        const RegisterState(
          status: FormStatus.failure,
          errorMessage: 'Email already registered',
        ),
      ],
    );
  });

  group('loadPhoneCodes', () {
    const jordan = CountryPhoneCode(
      countryName: 'Jordan',
      countryCode: 'JO',
      callingCode: '+962',
      flag: 'JO',
      nationalNumberLength: 9,
      mobilePrefixes: ['77', '78', '79', '75'],
    );

    blocTest<RegisterCubit, RegisterState>(
      'loads the countries including their number rules',
      build: () {
        when(() => repository.getPhoneCodes()).thenAnswer((_) async => const Right([jordan]));
        return RegisterCubit(repository);
      },
      act: (cubit) => cubit.loadPhoneCodes(),
      expect: () => [
        const RegisterState(isLoadingPhoneCodes: true),
        const RegisterState(phoneCodes: [jordan]),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'reports the error so the picker can offer a retry',
      build: () {
        when(() => repository.getPhoneCodes())
            .thenAnswer((_) async => const Left(NetworkFailure('No connection')));
        return RegisterCubit(repository);
      },
      act: (cubit) => cubit.loadPhoneCodes(),
      expect: () => [
        const RegisterState(isLoadingPhoneCodes: true),
        const RegisterState(phoneCodesError: 'No connection'),
      ],
    );
  });
}
