import 'package:equatable/equatable.dart';

class OnboardingItem extends Equatable {
  final String title;
  final String description;
  final String imageUrl;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [title, description, imageUrl];
}
