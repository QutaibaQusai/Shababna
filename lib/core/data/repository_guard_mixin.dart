import 'package:dartz/dartz.dart';

import '../error/exceptions.dart';
import '../error/failures.dart';

mixin RepositoryGuardMixin {
  Future<Either<Failure, T>> guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
        e.message,
        errors: e.errors,
        code: e.code,
        extensions: e.extensions,
      ));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message, code: e.code, extensions: e.extensions));
    } on ConflictException catch (e) {
      return Left(ConflictFailure(e.message, code: e.code, extensions: e.extensions));
    } on RateLimitException catch (e) {
      return Left(RateLimitFailure(e.message, code: e.code, extensions: e.extensions));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code, extensions: e.extensions));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, kind: e.kind));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
