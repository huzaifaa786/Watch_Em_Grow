class Availability {
  bool? Monday;
  bool? Tuesday;
  bool? Wednesday;
  bool? Thursday;
  bool? Friday;
  bool? Saturday;
  bool? Sunday;
  int? duration;
  int? startHour;
  int? endHour;
  List? unavailableDays = [''];
  List? unavailableSlots = [''];

  Availability(
      {this.Monday,
      this.Tuesday,
      this.Wednesday,
      this.Thursday,
      this.Friday,
      this.Saturday,
      this.Sunday,
      this.duration,
      this.startHour,
      this.endHour,
      this.unavailableDays,
      this.unavailableSlots
      });

  Availability.fromJson(Map<String, dynamic> json) {
    Monday = json['Monday'] as bool;
    Tuesday = json['Tuesday'] as bool;
    Wednesday = json['Wednesday'] as bool;
    Thursday = json['Thursday'] as bool;
    Friday = json['Friday'] as bool;
    Saturday = json['Saturday'] as bool;
    Sunday = json['Sunday'] as bool;
    duration = json['duration'] as int;
    startHour = json['startHour'] as int;
    endHour = json['endHour'] as int;
    unavailableDays = json['unavailableDays'] as List?;
    unavailableSlots = json['unavailableSlots'] as List?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Monday'] = Monday;
    data['Tuesday'] = Tuesday;
    data['Wednesday'] = Wednesday;
    data['Thursday'] = Thursday;
    data['Friday'] = Friday;
    data['Saturday'] = Saturday;
    data['Sunday'] = Sunday;
    data['duration'] = duration;
    data['startHour'] = startHour;
    data['endHour'] = endHour;
    data['unavailableDays'] = unavailableDays;
    data['unavailableSlots'] = unavailableSlots;
    return data;
  }
}
