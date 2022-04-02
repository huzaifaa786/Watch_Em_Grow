class NotificationModel {
  String? userId;
  String? title;
  String? body;
  String? image;
  String? id;
  String? read;
  String? time;
  String? sound;
  String? orderID;

  NotificationModel(
      {this.id,
      this.title,
      this.body,
      this.image,
      this.userId,
      this.sound,
      this.read,
      this.time,
      this.orderID});

  NotificationModel.fromMap(Map map) {
    userId = map['userId'].toString();
    title = map['title'] != null ? map['title'].toString() : "";
    body = map['body'].toString();
    image = map['image'].toString();
    id = map['id'].toString();
    read = map['read'].toString();
    time = map['time'].toString();
    sound = map['sound'].toString();
    orderID = map['orderID'].toString();
  }
}
