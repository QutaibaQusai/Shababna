import 'package:equatable/equatable.dart';

import '../../domain/repositories/contact_info_repository.dart';

class ContactInfoState extends Equatable {
  const ContactInfoState({
    this.isLoading = false,
    this.content,
    this.errorMessage,
  });

  final bool isLoading;
  final ContactInfo? content;
  final String? errorMessage;

  ContactInfoState copyWith({
    bool? isLoading,
    ContactInfo? content,
    String? errorMessage,
  }) {
    return ContactInfoState(
      isLoading: isLoading ?? this.isLoading,
      content: content ?? this.content,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, content, errorMessage];
}
