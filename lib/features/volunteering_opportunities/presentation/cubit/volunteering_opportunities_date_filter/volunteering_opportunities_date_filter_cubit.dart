import 'package:flutter_bloc/flutter_bloc.dart';

class VolunteeringOpportunitiesDateFilterCubit extends Cubit<DateTime?> {
  VolunteeringOpportunitiesDateFilterCubit() : super(null);

  void select(DateTime? date) {
    final day = date == null ? null : DateTime(date.year, date.month, date.day);
    if (day != state) emit(day);
  }
}
