import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';

class DashboardTier extends Equatable {
  const DashboardTier({
    required this.name,
    required this.lightIconUrl,
    required this.darkIconUrl,
  });

  final String name;
  final String lightIconUrl;
  final String darkIconUrl;

  String iconUrl({required bool isDark}) {
    final preferred = isDark ? darkIconUrl : lightIconUrl;
    return preferred.isNotEmpty
        ? preferred
        : (isDark ? lightIconUrl : darkIconUrl);
  }

  @override
  List<Object?> get props => [name, lightIconUrl, darkIconUrl];
}

class DashboardNextTier extends Equatable {
  const DashboardNextTier({required this.name, required this.remainingHours});

  final String name;
  final double remainingHours;

  @override
  List<Object?> get props => [name, remainingHours];
}

class VolunteerDashboard extends Equatable {
  const VolunteerDashboard({
    required this.totalVolunteeringHours,
    required this.registeredEventsCount,
    required this.completedEventsCount,
    required this.upcomingEventsCount,
    required this.pendingApprovalCount,
    required this.earnedCertificatesCount,
    required this.tasksCompletedCount,
    required this.pendingTaskSubmissionsCount,
    required this.tierProgressPercentage,
    this.tier,
    this.nextTier,
  });

  final double totalVolunteeringHours;
  final int registeredEventsCount;
  final int completedEventsCount;
  final int upcomingEventsCount;
  final int pendingApprovalCount;
  final int earnedCertificatesCount;
  final int tasksCompletedCount;
  final int pendingTaskSubmissionsCount;
  final int tierProgressPercentage;
  final DashboardTier? tier;
  final DashboardNextTier? nextTier;

  @override
  List<Object?> get props => [
    totalVolunteeringHours,
    registeredEventsCount,
    completedEventsCount,
    upcomingEventsCount,
    pendingApprovalCount,
    earnedCertificatesCount,
    tasksCompletedCount,
    pendingTaskSubmissionsCount,
    tierProgressPercentage,
    tier,
    nextTier,
  ];
}

abstract interface class DashboardRepository {
  Future<Either<Failure, VolunteerDashboard>> getDashboard();
}
