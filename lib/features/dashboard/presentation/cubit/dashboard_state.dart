import 'package:equatable/equatable.dart';

import '../../domain/repositories/dashboard_repository.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.dashboard,
    this.errorMessage,
  });

  final DashboardStatus status;
  final VolunteerDashboard? dashboard;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, dashboard, errorMessage];
}
