import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/errors/error_handler.dart';
import 'package:whatsapp/core/errors/server_failure.dart';

abstract class BaseRepo {
  Future<Either<ServerFailure, T>> safeCall<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } catch (e, stack) {
      return Left(ErrorHandler.handle(e, stack));
    }
  }
}
