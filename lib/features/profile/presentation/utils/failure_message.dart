import '../../../../core/error/failures.dart';

extension FailureMessage on Failure {
  String? get userMessage => this is UnexpectedFailure ? null : displayMessage;
}
