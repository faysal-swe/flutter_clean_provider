/// A lightweight, hand-rolled `Either<L, R>` type.
///
/// We use this instead of a package like `dartz` so the project has
/// zero extra dependencies for something this small.
///
/// Convention (same as the video / most Clean Architecture examples):
///   - `Left`  => Failure / error case
///   - `Right` => Success case
abstract class Either<L, R> {
  const Either();

  /// Runs [onLeft] if this is a [Left], otherwise runs [onRight].
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight);

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onLeft(value);
  }
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onRight(value);
  }
}
