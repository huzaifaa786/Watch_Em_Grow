/// Provides extra data to a custom dialog
class CustomDialogData {
  CustomDialogData({
    this.hasTimer = false,
    this.hasRichDescription = false,
    this.richDescription,
    this.richData,
    this.richDescriptionExtra,
    this.isConfirmationDialog = false,
  });

  final bool hasTimer;
  final bool hasRichDescription;
  final String? richDescription;
  final String? richData;
  final String? richDescriptionExtra;
  final bool isConfirmationDialog;
}

class CloudStorageResult {
  CloudStorageResult({
    required this.imageUrl,
    required this.imageFileName,
  });

  final String imageUrl;
  final String imageFileName;
}
