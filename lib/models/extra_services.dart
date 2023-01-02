class ExtraServices {
  String? name;
  String? price;

  ExtraServices({this.name, this.price});

  ExtraServices.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String;
    price = json['price'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}
