class Availability {
  bool? Monday;
  bool? Tuesday;
  bool? Wednesday;
  bool? Thursday;
  bool? Friday;
  bool? Saturday;
  bool? Sunday;

  Availability({this.Monday,this.Tuesday,this.Wednesday,this.Thursday,this.Friday,this.Saturday,this.Sunday,});

  Availability.fromJson(Map<String, dynamic> json) {
    Monday = json['Monday'] as bool;
    Tuesday = json['Tuesday'] as bool;
    Wednesday = json['Wednesday'] as bool;
    Thursday = json['Thursday'] as bool;
    Friday = json['Friday'] as bool;
    Saturday = json['Saturday'] as bool;
    Sunday = json['Sunday'] as bool;
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
    return data;
  }
}