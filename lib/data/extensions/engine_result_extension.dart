import 'dart:async';

import 'package:engine/lib.dart';

extension FutureEngineResult<L, R> on Future<EngineResult<L, R>> {
  /// Represents the left side of [EngineResult] class which by convention is a "Failure".
  Future<bool> get isFailed => then((final e) => e.isFailure);

  /// Represents the right side of [EngineResult] class which by convention is a "Success"
  Future<bool> get isSuccessful => then((final e) => e.isSuccessful);

  /// Transform values of [Failure] and [Successful]
  Future<EngineResult<TF, TR>> e<TF, TR>(final TF Function(L fail) fnFail, final TR Function(R success) fnSuccess) =>
      then((final e) => e.transform(fnFail, fnSuccess));

  /// Transform value of [Successful]
  Future<EngineResult<L, TR>> mapRight<TR>(final FutureOr<TR> Function(R success) fnSuccess) => then((final e) => e.mapAsync(fnSuccess));

  /// Transform value of [Failure]
  Future<EngineResult<TF, R>> mapFailure<TF>(final FutureOr<TF> Function(L fail) fnFail) => then((final e) => e.mapFailureAsync(fnFail));

  /// Async transform value of [Successful] when transformation may be finished with an error
  Future<EngineResult<L, TR>> thenRight<TR>(final FutureOr<EngineResult<L, TR>> Function(R success) fnSuccess) => then((final e) => e.thenAsync(fnSuccess));

  /// Async transform value of [Failure] when transformation may be finished with an [Successful]
  Future<EngineResult<TF, R>> thenFailure<TF>(final FutureOr<EngineResult<TF, R>> Function(L fail) fnFail) => then((final e) => e.thenFailureAsync(fnFail));

  /// Fold [Failure] and [Successful] into the value of one type
  Future<T> fold<T>(
    final FutureOr<T> Function(L fail) fnFail,
    final FutureOr<T> Function(R success) fnSuccess,
  ) =>
      then((final e) => e.fold(fnFail, fnSuccess));

  /// Swap [Failure] and [Successful]
  Future<EngineResult<R, L>> swap() => this.fold<EngineResult<R, L>>((final left) => Successful(left), (final right) => Failure(right));
}
