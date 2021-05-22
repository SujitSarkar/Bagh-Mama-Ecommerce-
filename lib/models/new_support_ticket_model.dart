// To parse this JSON data, do
//
//     final newSupportTicketModel = newSupportTicketModelFromJson(jsonString);

import 'dart:convert';

NewSupportTicketModel newSupportTicketModelFromJson(String str) => NewSupportTicketModel.fromJson(json.decode(str));

String newSupportTicketModelToJson(NewSupportTicketModel data) => json.encode(data.toJson());

class NewSupportTicketModel {
  NewSupportTicketModel({
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

  factory NewSupportTicketModel.fromJson(Map<String, dynamic> json) => NewSupportTicketModel(
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
  });

  String success;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
  };
}
