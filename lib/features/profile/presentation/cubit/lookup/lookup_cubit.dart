import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../utils/failure_message.dart';
import 'lookup_state.dart';

typedef LookupLoader<T> = Future<Either<Failure, List<T>>> Function();

class LookupCubit<T> extends Cubit<LookupState<T>> {
  LookupCubit(this._loader) : super(LookupState<T>());

  final LookupLoader<T> _loader;

  Future<void> load() async {
    if (state.isLoading || state.items.isNotEmpty) return;
    emit(LookupState<T>(isLoading: true));

    final result = await _loader();
    if (isClosed) return;

    result.fold(
      (failure) => emit(LookupState<T>(hasError: true, errorMessage: failure.userMessage)),
      (items) => emit(LookupState<T>(items: items)),
    );
  }
}
