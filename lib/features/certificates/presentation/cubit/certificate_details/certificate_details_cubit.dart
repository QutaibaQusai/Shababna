import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/repositories/certificates_repository.dart';
import 'certificate_details_state.dart';

class CertificateDetailsCubit extends Cubit<CertificateDetailsState> {
  CertificateDetailsCubit(this._repository, {required this.id})
    : super(const CertificateDetailsState());

  final CertificatesRepository _repository;
  final String id;

  Future<void> load() async {
    if (state.isLoading || state.isBusy) return;
    emit(const CertificateDetailsState(isLoading: true));

    final result = await _repository.getCertificate(id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(CertificateDetailsState(hasError: true, errorMessage: _messageOf(failure))),
      (certificate) => emit(CertificateDetailsState(certificate: certificate)),
    );
  }

  Future<void> open(CertificateLanguage language) async {
    final certificate = state.certificate;
    if (certificate == null || certificate.isRevoked || state.isBusy) return;
    emit(state.copyWith(busyLanguage: () => language));

    final result = await _repository.downloadDocument(certificate, language);
    if (isClosed) return;

    emit(
      state.copyWith(
        busyLanguage: () => null,
        feedback: result.fold(
          (failure) => CertificateFileFailed(_messageOf(failure)),
          CertificateFileReady.new,
        ),
      ),
    );
  }

  String? _messageOf(Failure failure) =>
      failure is UnexpectedFailure ? null : failure.displayMessage;
}
