// To parse this JSON data, do
//
//     final socialContactInfo = socialContactInfoFromJson(jsonString);

import 'dart:convert';

SocialContactInfo socialContactInfoFromJson(String str) => SocialContactInfo.fromJson(json.decode(str));

String socialContactInfoToJson(SocialContactInfo data) => json.encode(data.toJson());

class SocialContactInfo {
  SocialContactInfo({
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

  factory SocialContactInfo.fromJson(Map<String, dynamic> json) => SocialContactInfo(
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
