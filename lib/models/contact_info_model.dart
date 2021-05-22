// To parse this JSON data, do
//
//     final contactInfoModel = contactInfoModelFromJson(jsonString);

import 'dart:convert';

ContactInfoModel contactInfoModelFromJson(String str) => ContactInfoModel.fromJson(json.decode(str));

String contactInfoModelToJson(ContactInfoModel data) => json.encode(data.toJson());

class ContactInfoModel {
  ContactInfoModel({
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

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) => ContactInfoModel(
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
    this.facebook,
    this.twitter,
    this.instagram,
    this.linkedin,
    this.googleplus,
    this.gmail,
    this.youtube,
    this.yahoo,
    this.skype,
  });

  String address;
  String address2;
  String mobile1;
  String mobile2;
  String mobile3;
  String phone;
  String email;
  String facebook;
  String twitter;
  String instagram;
  String linkedin;
  String googleplus;
  String gmail;
  String youtube;
  String yahoo;
  String skype;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    address: json["address"],
    address2: json["address2"],
    mobile1: json["mobile1"],
    mobile2: json["mobile2"],
    mobile3: json["mobile3"],
    phone: json["phone"],
    email: json["email"],
    facebook: json["facebook"],
    twitter: json["twitter"],
    instagram: json["instagram"],
    linkedin: json["linkedin"],
    googleplus: json["googleplus"],
    gmail: json["gmail"],
    youtube: json["youtube"],
    yahoo: json["yahoo"],
    skype: json["skype"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "address2": address2,
    "mobile1": mobile1,
    "mobile2": mobile2,
    "mobile3": mobile3,
    "phone": phone,
    "email": email,
    "facebook": facebook,
    "twitter": twitter,
    "instagram": instagram,
    "linkedin": linkedin,
    "googleplus": googleplus,
    "gmail": gmail,
    "youtube": youtube,
    "yahoo": yahoo,
    "skype": skype,
  };
}