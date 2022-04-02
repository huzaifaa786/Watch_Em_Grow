class StorageApiException implements Exception {
  final String title;
  final String? message;

  StorageApiException({
    required this.title,
    this.message,
  });

  @override
  String toString() {
    return 'StorageApiException: $title ${message != null ? '- $message' : ''}';
  }
}
