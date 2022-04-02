class DatabaseApiException implements Exception {
  final String title;
  final String? message;

  DatabaseApiException({
    required this.title,
    this.message,
  });

  @override
  String toString() {
    return 'DatabaseApiException: $title ${message != null ? '- $message' : ''}';
  }
}
