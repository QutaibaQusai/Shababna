import '../../domain/repositories/dashboard_repository.dart';

double _readDouble(Object? value) => switch (value) {
  final num number => number.toDouble(),
  final String text => double.tryParse(text) ?? 0,
  _ => 0,
};

int _readInt(Object? value) => _readDouble(value).round();

Map<String, dynamic>? _readObject(Object? value) =>
    value is Map<String, dynamic> ? value : null;

class DashboardTierModel {
  const DashboardTierModel({
    required this.name,
    required this.lightIconUrl,
    required this.darkIconUrl,
  });

  factory DashboardTierModel.fromJson(Map<String, dynamic> json) {
    return DashboardTierModel(
      name: json['name'] as String? ?? '',
      lightIconUrl: json['lightIconUrl'] as String? ?? '',
      darkIconUrl: json['darkIconUrl'] as String? ?? '',
    );
  }

  final String name;
  final String lightIconUrl;
  final String darkIconUrl;

  DashboardTier toEntity() => DashboardTier(
    name: name,
    lightIconUrl: lightIconUrl,
    darkIconUrl: darkIconUrl,
  );
}

class DashboardNextTierModel {
  const DashboardNextTierModel({
    required this.name,
    required this.remainingHours,
  });

  factory DashboardNextTierModel.fromJson(Map<String, dynamic> json) {
    return DashboardNextTierModel(
      name: json['name'] as String? ?? '',
      remainingHours: _readDouble(json['remainingHours']),
    );
  }

  final String name;
  final double remainingHours;

  DashboardNextTier toEntity() =>
      DashboardNextTier(name: name, remainingHours: remainingHours);
}

class DashboardModel {
  const DashboardModel({
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

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final tier = _readObject(json['tier']);
    final nextTier = _readObject(json['nextTier']);
    return DashboardModel(
      totalVolunteeringHours: _readDouble(json['totalVolunteeringHours']),
      registeredEventsCount: _readInt(json['registeredEventsCount']),
      completedEventsCount: _readInt(json['completedEventsCount']),
      upcomingEventsCount: _readInt(json['upcomingEventsCount']),
      pendingApprovalCount: _readInt(json['pendingApprovalCount']),
      earnedCertificatesCount: _readInt(json['earnedCertificatesCount']),
      tasksCompletedCount: _readInt(json['tasksCompletedCount']),
      pendingTaskSubmissionsCount: _readInt(
        json['pendingTaskSubmissionsCount'],
      ),
      tierProgressPercentage: _readInt(json['tierProgressPercentage']),
      tier: tier == null ? null : DashboardTierModel.fromJson(tier),
      nextTier: nextTier == null
          ? null
          : DashboardNextTierModel.fromJson(nextTier),
    );
  }

  final double totalVolunteeringHours;
  final int registeredEventsCount;
  final int completedEventsCount;
  final int upcomingEventsCount;
  final int pendingApprovalCount;
  final int earnedCertificatesCount;
  final int tasksCompletedCount;
  final int pendingTaskSubmissionsCount;
  final int tierProgressPercentage;
  final DashboardTierModel? tier;
  final DashboardNextTierModel? nextTier;

  VolunteerDashboard toEntity() => VolunteerDashboard(
    totalVolunteeringHours: totalVolunteeringHours,
    registeredEventsCount: registeredEventsCount,
    completedEventsCount: completedEventsCount,
    upcomingEventsCount: upcomingEventsCount,
    pendingApprovalCount: pendingApprovalCount,
    earnedCertificatesCount: earnedCertificatesCount,
    tasksCompletedCount: tasksCompletedCount,
    pendingTaskSubmissionsCount: pendingTaskSubmissionsCount,
    tierProgressPercentage: tierProgressPercentage.clamp(0, 100),
    tier: tier?.toEntity(),
    nextTier: nextTier?.toEntity(),
  );
}
