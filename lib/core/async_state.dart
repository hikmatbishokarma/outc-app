/// One contract for "where is this network call right now," used by
/// providers instead of each one inventing its own `isLoading`/`hasError`
/// boolean pair that can drift out of sync with each other (spec 0012).
/// `sealed` so a `switch` over it in a `build()` method is exhaustiveness-
/// checked by the analyzer — a missing case is a compile error, not a
/// silently blank screen.
sealed class AsyncState<T> {
  const AsyncState();
}

class AsyncLoading<T> extends AsyncState<T> {
  const AsyncLoading();
}

class AsyncData<T> extends AsyncState<T> {
  const AsyncData(this.value);
  final T value;
}

/// A successful response with zero items — distinct from [AsyncError].
class AsyncEmpty<T> extends AsyncState<T> {
  const AsyncEmpty();
}

class AsyncError<T> extends AsyncState<T> {
  const AsyncError(this.message);
  final String message;
}

/// The connectivity check failed before the network call was attempted.
class AsyncOffline<T> extends AsyncState<T> {
  const AsyncOffline();
}
