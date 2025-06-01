import 'dart:async';

typedef Lazy<T> = T Function();

/// Represents a value of one of two possible types.
/// Instances of [EngineResult] are result an instance of [Failure] or [Successful].
///
/// [Failure] is used for "failure".
/// [Successful] is used for "success".
sealed class EngineResult<L, R> {
  const EngineResult();

  /// Represents the failure side of [EngineResult] class which by convention is a "Failure".
  bool get isFailure => this is Failure<L, R>;

  /// Represents the successful side of [EngineResult] class which by convention is a "Success"
  bool get isSuccessful => this is Successful<L, R>;

  /// Get [Failure] value, may throw an exception when the value is [Successful]
  L get failure => this.fold<L>((final value) => value, (final data) => throw Exception('Illegal use. You should check isFailure before calling'));

  /// Get [Successful] value, may throw an exception when the value is [Failure]
  R get data => this.fold<R>((final failure) => throw Exception('Illegal use. You should check isSuccessful before calling'), (final value) => value);

  /// Transform values of [Failure] and [Successful]
  EngineResult<TL, TR> transform<TL, TR>(final TL Function(L failure) failure, final TR Function(R data) data);

  /// Transform value of [Successful] when transformation may be finished with an error
  EngineResult<L, TR> then<TR>(final EngineResult<L, TR> Function(R successful) data);

  /// Transform value of [Successful] when transformation may be finished with an error
  Future<EngineResult<L, TR>> thenAsync<TR>(final FutureOr<EngineResult<L, TR>> Function(R data) data);

  /// Transform value of [Failure] when transformation may be finished with an [Successful]
  EngineResult<TL, R> thenFailure<TL>(final EngineResult<TL, R> Function(L failure) failure);

  /// Transform value of [Failure] when transformation may be finished with an [Successful]
  Future<EngineResult<TL, R>> thenFailureAsync<TL>(final FutureOr<EngineResult<TL, R>> Function(L failure) failure);

  /// Transform value of [Successful]
  EngineResult<L, TR> map<TR>(final TR Function(R data) data);

  /// Transform value of [Failure]
  EngineResult<TL, R> mapFailure<TL>(final TL Function(L failure) failure);

  /// Transform value of [Successful]
  Future<EngineResult<L, TR>> mapAsync<TR>(final FutureOr<TR> Function(R data) data);

  /// Transform value of [Failure]
  Future<EngineResult<TL, R>> mapFailureAsync<TL>(final FutureOr<TL> Function(L failure) failure);

  /// Fold [Failure] and [Successful] into the value of one type
  T fold<T>(final T Function(L failure) failure, final T Function(R data) data);

  /// Swap [Failure] and [Successful]
  EngineResult<R, L> swap() => fold((final failure) => Successful(failure), (final data) => Failure(data));

  /// Constructs a new [EngineResult] from a function that might throw
  static EngineResult<L, R> tryCatch<L, R, Err extends Object>(final L Function(Err err) onError, final R Function() data) {
    try {
      return Successful(data());
    } on Err catch (e) {
      return Failure(onError(e));
    }
  }

  /// Constructs a new [EngineResult] from a function that might throw
  ///
  /// simplified version of [EngineResult.tryCatch]
  ///
  /// ```dart
  /// final fileOrError = EngineHttpResult.tryExcept<FileError>(() => /* maybe throw */);
  /// ```
  static EngineResult<Err, R> tryExcept<Err extends Object, R>(final R Function() data) {
    try {
      return Successful(data());
    } on Err catch (e) {
      return Failure(e);
    }
  }

  /// If the condition is true then return [successfulValue] in [Successful] else [failureValue] in [Failure]
  static EngineResult<L, R> cond<L, R>(final bool test, final L failureValue, final R successfulValue) =>
      test ? Successful(successfulValue) : Failure(failureValue);

  /// If the condition is true then return [successfulValue] in [Successful] else [failureValue] in [Failure]
  static EngineResult<L, R> condLazy<L, R>(final bool test, final Lazy<L> failureValue, final Lazy<R> successfulValue) =>
      test ? Successful(successfulValue()) : Failure(failureValue());

  @override
  bool operator ==(final Object other) => this.fold(
        (final failure) => other is Failure && failure == other.value,
        (final data) => other is Successful && data == other.value,
      );

  @override
  int get hashCode => fold((final failure) => failure.hashCode, (final data) => data.hashCode);
}

/// Used for "failure"
class Failure<L, R> extends EngineResult<L, R> {
  final L value;

  const Failure(this.value);

  @override
  EngineResult<TL, TR> transform<TL, TR>(final TL Function(L failure) failure, final TR Function(R data) data) => Failure<TL, TR>(failure(value));

  @override
  EngineResult<L, TR> then<TR>(final EngineResult<L, TR> Function(R data) data) => Failure<L, TR>(value);

  @override
  Future<EngineResult<L, TR>> thenAsync<TR>(final FutureOr<EngineResult<L, TR>> Function(R data) data) => Future.value(Failure<L, TR>(value));

  @override
  EngineResult<TL, R> thenFailure<TL>(final EngineResult<TL, R> Function(L failure) failure) => failure(value);

  @override
  Future<EngineResult<TL, R>> thenFailureAsync<TL>(final FutureOr<EngineResult<TL, R>> Function(L failure) failure) => Future.value(failure(value));

  @override
  EngineResult<L, TR> map<TR>(final TR Function(R data) data) => Failure<L, TR>(value);

  @override
  EngineResult<TL, R> mapFailure<TL>(final TL Function(L failure) failure) => Failure<TL, R>(failure(value));

  @override
  Future<EngineResult<L, TR>> mapAsync<TR>(final FutureOr<TR> Function(R data) data) => Future.value(Failure<L, TR>(value));

  @override
  Future<EngineResult<TL, R>> mapFailureAsync<TL>(final FutureOr<TL> Function(L failure) failure) =>
      Future.value(failure(value)).then((final value) => Failure<TL, R>(value));

  @override
  T fold<T>(final T Function(L failure) failure, final T Function(R data) data) => failure(value);
}

/// Used for "success"
class Successful<L, R> extends EngineResult<L, R> {
  final R value;

  const Successful(this.value);

  @override
  EngineResult<TL, TR> transform<TL, TR>(final TL Function(L failure) failure, final TR Function(R data) data) => Successful<TL, TR>(data(value));

  @override
  EngineResult<L, TR> then<TR>(final EngineResult<L, TR> Function(R data) data) => data(value);

  @override
  Future<EngineResult<L, TR>> thenAsync<TR>(final FutureOr<EngineResult<L, TR>> Function(R data) data) => Future.value(data(value));

  @override
  EngineResult<TL, R> thenFailure<TL>(final EngineResult<TL, R> Function(L failure) failure) => Successful<TL, R>(value);

  @override
  Future<EngineResult<TL, R>> thenFailureAsync<TL>(final FutureOr<EngineResult<TL, R>> Function(L failure) failure) => Future.value(Successful<TL, R>(value));

  @override
  EngineResult<L, TR> map<TR>(final TR Function(R data) data) => Successful<L, TR>(data(value));

  @override
  EngineResult<TL, R> mapFailure<TL>(final TL Function(L failure) failure) => Successful<TL, R>(value);

  @override
  Future<EngineResult<L, TR>> mapAsync<TR>(final FutureOr<TR> Function(R data) data) =>
      Future.value(data(value)).then((final value) => Successful<L, TR>(value));

  @override
  Future<EngineResult<TL, R>> mapFailureAsync<TL>(final FutureOr<TL> Function(L failure) failure) => Future.value(Successful<TL, R>(value));

  @override
  T fold<T>(final T Function(L failure) failure, final T Function(R data) data) => data(value);
}
