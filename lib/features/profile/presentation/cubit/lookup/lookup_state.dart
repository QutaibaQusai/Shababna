import 'package:equatable/equatable.dart';

class LookupState<T> extends Equatable {
  const LookupState({
    this.isLoading = false,
    this.items = const [],
    this.hasError = false,
    this.errorMessage,
  });

  final bool isLoading;
  final List<T> items;
  final bool hasError;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, items, hasError, errorMessage];
}
