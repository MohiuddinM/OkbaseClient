class Result<T> {
  final bool isError;
  final String message;
  final T value;

  Result(this.isError, this.message, this.value);

  factory Result.ok([T value]) {
    return Result(false, '', value);
  }

  factory Result.error([String message = 'Generic Error']) {
    return Result(true, message, null);
  }
}
