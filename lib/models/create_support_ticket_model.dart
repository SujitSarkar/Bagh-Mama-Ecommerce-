// To parse this JSON data, do
//
//     final createSupportTokenModel = createSupportTokenModelFromJson(jsonString);

import 'dart:convert';

CreateSupportTokenModel createSupportTokenModelFromJson(String str) => CreateSupportTokenModel.fromJson(json.decode(str));

String createSupportTokenModelToJson(CreateSupportTokenModel data) => json.encode(data.toJson());

class CreateSupportTokenModel {
  CreateSupportTokenModel({
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

  factory CreateSupportTokenModel.fromJson(Map<String, dynamic> json) => CreateSupportTokenModel(
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
    this.tokenNo,
  });

  bool success;
  int tokenNo;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    success: json["success"],
    tokenNo: json["token_no"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "token_no": tokenNo,
  };
}
