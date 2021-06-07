// To parse this JSON data, do
//
//     final shippingLocationsModel = shippingLocationsModelFromJson(jsonString);

import 'dart:convert';

ShippingLocationsModel shippingLocationsModelFromJson(String str) => ShippingLocationsModel.fromJson(json.decode(str));

String shippingLocationsModelToJson(ShippingLocationsModel data) => json.encode(data.toJson());

class ShippingLocationsModel {
  ShippingLocationsModel({
    this.status,
    this.errorno,
    this.error,
    this.description,
    this.content,
  });

  String status;
  String errorno;
  String error;
  String description;
  List<Content> content;

  factory ShippingLocationsModel.fromJson(Map<String, dynamic> json) => ShippingLocationsModel(
    status: json["status"],
    errorno: json["errorno"],
    error: json["error"],
    description: json["description"],
    content: List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorno": errorno,
    "error": error,
    "description": description,
    "content": List<dynamic>.from(content.map((x) => x.toJson())),
  };
}

class Content {
  Content({
    this.id,
    this.location,
    this.city,
    this.status,
  });

  String id;
  String location;
  String city;
  String status;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"],
    location: json["location"],
    city: json["city"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location": location,
    "city": city,
    "status": status,
  };
}
