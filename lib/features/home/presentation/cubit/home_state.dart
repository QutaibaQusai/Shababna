import 'package:equatable/equatable.dart';

import '../../domain/repositories/home_repository.dart';

enum HomeStatus { loading, ready, failure }

class HomeState extends Equatable {
  const HomeState({
    required this.selectedDay,
    this.status = HomeStatus.loading,
    this.isMember = false,
    this.feed = const HomeFeed(),
    this.isDayLoading = false,
    this.errorMessage,
  });

  final HomeStatus status;
  final bool isMember;
  final HomeFeed feed;
  final DateTime selectedDay;
  final bool isDayLoading;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    bool? isMember,
    HomeFeed? feed,
    DateTime? selectedDay,
    bool? isDayLoading,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      isMember: isMember ?? this.isMember,
      feed: feed ?? this.feed,
      selectedDay: selectedDay ?? this.selectedDay,
      isDayLoading: isDayLoading ?? this.isDayLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, isMember, feed, selectedDay, isDayLoading, errorMessage];
}
