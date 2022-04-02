class AuthApiException implements Exception {
  final String title;
  final String? message;

  AuthApiException({
    required this.title,
    this.message,
  });

  @override
  String toString() {
    return 'AuthApiException: $title ${message != null ? '- $message' : ''}';
  }
}
