// To parse this JSON data, do
//
//     final shippingMethodsModel = shippingMethodsModelFromJson(jsonString);

import 'dart:convert';

ShippingMethodsModel shippingMethodsModelFromJson(String str) => ShippingMethodsModel.fromJson(json.decode(str));

String shippingMethodsModelToJson(ShippingMethodsModel data) => json.encode(data.toJson());

class ShippingMethodsModel {
  ShippingMethodsModel({
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

  factory ShippingMethodsModel.fromJson(Map<String, dynamic> json) => ShippingMethodsModel(
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
    this.methodLogo,
    this.methodName,
    this.location,
    this.cost,
    this.estimateTime,
    this.status,
  });

  String id;
  String methodLogo;
  String methodName;
  String location;
  String cost;
  String estimateTime;
  String status;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"],
    methodLogo: json["method_logo"],
    methodName: json["method_name"],
    location: json["location"],
    cost: json["cost"],
    estimateTime: json["estimate_time"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "method_logo": methodLogo,
    "method_name": methodName,
    "location": location,
    "cost": cost,
    "estimate_time": estimateTime,
    "status": status,
  };
}
