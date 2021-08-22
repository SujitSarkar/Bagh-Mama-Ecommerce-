import 'dart:convert';

InitNagadModel initNagadModelFromJson(String str) => InitNagadModel.fromJson(json.decode(str));

String initNagadModelToJson(InitNagadModel data) => json.encode(data.toJson());

class InitNagadModel {
  InitNagadModel({
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

  factory InitNagadModel.fromJson(Map<String, dynamic> json) => InitNagadModel(
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
    this.error,
    this.paymentRefId,
    this.redirectUrl,
  });

  dynamic error;
  String paymentRefId;
  String redirectUrl;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    error: json["error"],
    paymentRefId: json["paymentRefId"],
    redirectUrl: json["redirectUrl"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "paymentRefId": paymentRefId,
    "redirectUrl": redirectUrl,
  };
}
