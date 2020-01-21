class NetworkError {
  final int statusCode;
  final String message;

  const NetworkError([this.statusCode = 0, this.message = 'Unknown Error']);

  factory NetworkError.notFound([String message = 'Not Found']) => NetworkError(404, message);

  factory NetworkError.serverError([String message = 'Server Error']) => NetworkError(500, message);

  factory NetworkError.conflict([String message = 'Conflict']) => NetworkError(409, message);

  factory NetworkError.unauthorized([String message = 'Unauthorized']) => NetworkError(401, message);

  factory NetworkError.badRequest([String message = 'Bad Request']) => NetworkError(400, message);

  factory NetworkError.forbidden([String message = 'Forbidden']) => NetworkError(403, message);
}
