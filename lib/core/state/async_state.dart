/// The one async-state contract for network-backed screens (spec 0012) —
/// replaces per-provider ad hoc `isLoading`/`errorMessage` booleans with a
/// single sealed type so a screen can render purely off `state`, not off
/// flags that can drift out of sync with each other.
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

/// A successful response with zero results (e.g. no flights/buses matched) —
/// distinct from [AsyncError]: an empty result set is not a failure.
class AsyncEmpty<T> extends AsyncState<T> {
  const AsyncEmpty();
}

class AsyncError<T> extends AsyncState<T> {
  const AsyncError(this.message);

  final String message;
}

/// Detected via [ConnectivityService] before a request is attempted —
/// distinct from [AsyncError] so the UI can offer a connectivity-specific
/// retry message instead of a generic failure message.
class AsyncOffline<T> extends AsyncState<T> {
  const AsyncOffline();
}
