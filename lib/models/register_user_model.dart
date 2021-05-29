// To parse this JSON data, do
//
//     final registerUserModel = registerUserModelFromJson(jsonString);

import 'dart:convert';

RegisterUserModel registerUserModelFromJson(String str) => RegisterUserModel.fromJson(json.decode(str));

String registerUserModelToJson(RegisterUserModel data) => json.encode(data.toJson());

class RegisterUserModel {
  RegisterUserModel({
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

  factory RegisterUserModel.fromJson(Map<String, dynamic> json) => RegisterUserModel(
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
    this.errordesc,
  });

  bool success;
  String errordesc;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    success: json["success"],
    errordesc: json["errordesc"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "errordesc": errordesc,
  };
}
