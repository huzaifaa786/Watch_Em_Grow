import 'package:mipromo/models/availability.dart';

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

String intDayToEnglish(int day) {
  if (day % 7 == DateTime.monday % 7) return 'Monday';
  if (day % 7 == DateTime.tuesday % 7) return 'Tuesday';
  if (day % 7 == DateTime.wednesday % 7) return 'Wednesday';
  if (day % 7 == DateTime.thursday % 7) return 'Thursday';
  if (day % 7 == DateTime.friday % 7) return 'Friday';
  if (day % 7 == DateTime.saturday % 7) return 'Saturday';
  if (day % 7 == DateTime.sunday % 7) return 'Sunday';
  throw '🐞 This should never have happened: $day';
}

List<bool> converToArray(Availability availability) {
  return [
    availability.Sunday!,
    availability.Monday!,
    availability.Tuesday!,
    availability.Wednesday!,
    availability.Thursday!,
    availability.Friday!,
    availability.Saturday!,
  ];
}
