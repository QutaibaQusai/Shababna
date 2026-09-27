import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/session/auth_session_cubit.dart';
import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../utils/failure_message.dart';
import 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit(this._repository, this._authSession) : super(const DeleteAccountState());

  final ProfileRepository _repository;
  final AuthSessionCubit _authSession;

  Future<void> submit({required String currentPassword, String? reason}) async {
    if (state.isSubmitting) return;
    emit(const DeleteAccountState(status: FormStatus.submitting));

    final result = await _repository.deleteAccount(
      currentPassword: currentPassword,
      reason: reason,
    );
    if (isClosed) return;

    await result.fold(
      (failure) async => emit(
        DeleteAccountState(status: FormStatus.failure, errorMessage: failure.userMessage),
      ),
      (_) async {
        emit(const DeleteAccountState(status: FormStatus.success));
        await _authSession.markUnauthenticated();
      },
    );
  }
}
