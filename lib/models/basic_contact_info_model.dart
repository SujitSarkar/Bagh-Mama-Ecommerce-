// To parse this JSON data, do
//
//     final basicContactInfo = basicContactInfoFromJson(jsonString);

import 'dart:convert';

BasicContactInfo basicContactInfoFromJson(String str) => BasicContactInfo.fromJson(json.decode(str));

String basicContactInfoToJson(BasicContactInfo data) => json.encode(data.toJson());

class BasicContactInfo {
  BasicContactInfo({
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

  factory BasicContactInfo.fromJson(Map<String, dynamic> json) => BasicContactInfo(
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
    this.address,
    this.address2,
    this.mobile1,
    this.mobile2,
    this.mobile3,
    this.phone,
    this.email,
  });

  String address;
  String address2;
  String mobile1;
  String mobile2;
  String mobile3;
  String phone;
  String email;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    address: json["address"],
    address2: json["address2"],
    mobile1: json["mobile1"],
    mobile2: json["mobile2"],
    mobile3: json["mobile3"],
    phone: json["phone"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "address2": address2,
    "mobile1": mobile1,
    "mobile2": mobile2,
    "mobile3": mobile3,
    "phone": phone,
    "email": email,
  };
}
