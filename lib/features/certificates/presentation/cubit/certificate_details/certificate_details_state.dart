import 'package:equatable/equatable.dart';

import '../../../domain/repositories/certificates_repository.dart';

sealed class CertificateFileFeedback extends Equatable {
  const CertificateFileFeedback();
}

final class CertificateFileReady extends CertificateFileFeedback {
  const CertificateFileReady(this.path);

  final String path;

  @override
  List<Object?> get props => [path, identityHashCode(this)];
}

final class CertificateFileFailed extends CertificateFileFeedback {
  const CertificateFileFailed(this.message);

  final String? message;

  @override
  List<Object?> get props => [message, identityHashCode(this)];
}

class CertificateDetailsState extends Equatable {
  const CertificateDetailsState({
    this.certificate,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.busyLanguage,
    this.feedback,
  });

  final Certificate? certificate;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final CertificateLanguage? busyLanguage;
  final CertificateFileFeedback? feedback;

  bool get isBusy => busyLanguage != null;

  CertificateDetailsState copyWith({
    Certificate? certificate,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    CertificateLanguage? Function()? busyLanguage,
    CertificateFileFeedback? feedback,
  }) {
    return CertificateDetailsState(
      certificate: certificate ?? this.certificate,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      busyLanguage: busyLanguage != null ? busyLanguage() : this.busyLanguage,
      feedback: feedback ?? this.feedback,
    );
  }

  @override
  List<Object?> get props => [
    certificate,
    isLoading,
    hasError,
    errorMessage,
    busyLanguage,
    feedback,
  ];
}
