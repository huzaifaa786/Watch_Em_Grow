class ImageSelectorApiException implements Exception {
  final String title;
  final String? message;

  ImageSelectorApiException({
    required this.title,
    this.message,
  });

  @override
  String toString() {
    return 'ImageSelectorApiException: $title ${message != null ? '- $message' : ''}';
  }
}