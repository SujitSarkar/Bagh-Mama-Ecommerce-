// To parse this JSON data, do
//
//     final uploadImageResponseModel = uploadImageResponseModelFromJson(jsonString);

import 'dart:convert';

UploadImageResponseModel uploadImageResponseModelFromJson(String str) => UploadImageResponseModel.fromJson(json.decode(str));

String uploadImageResponseModelToJson(UploadImageResponseModel data) => json.encode(data.toJson());

class UploadImageResponseModel {
  UploadImageResponseModel({
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
  Content content;

  factory UploadImageResponseModel.fromJson(Map<String, dynamic> json) => UploadImageResponseModel(
    status: json["status"],
    errorno: json["errorno"],
    error: json["error"],
    description: json["description"],
    content: Content.fromJson(json["content"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorno": errorno,
    "error": error,
    "description": description,
    "content": content.toJson(),
  };
}

class Content {
  Content({
    this.success,
    this.image,
  });

  bool success;
  String image;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    success: json["success"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "image": image,
  };
}
