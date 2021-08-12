// To parse this JSON data, do
//
//     final campaignsDateModel = campaignsDateModelFromJson(jsonString);

import 'dart:convert';

CampaignsDateModel campaignsDateModelFromJson(String str) => CampaignsDateModel.fromJson(json.decode(str));

String campaignsDateModelToJson(CampaignsDateModel data) => json.encode(data.toJson());

class CampaignsDateModel {
  CampaignsDateModel({
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

  factory CampaignsDateModel.fromJson(Map<String, dynamic> json) => CampaignsDateModel(
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
    this.startFrom,
    this.endIn,
    this.dealId,
    this.campaignTitle,
    this.banner,
  });

  DateTime startFrom;
  DateTime endIn;
  String dealId;
  String campaignTitle;
  String banner;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    startFrom: DateTime.parse(json["start_from"]),
    endIn: DateTime.parse(json["end_in"]),
    dealId: json["deal_id"],
    campaignTitle: json["campaign_title"],
    banner: json["banner"],
  );

  Map<String, dynamic> toJson() => {
    "start_from": startFrom.toIso8601String(),
    "end_in": endIn.toIso8601String(),
    "deal_id": dealId,
    "campaign_title": campaignTitle,
    "banner": banner,
  };
}
