import 'dart:convert';

SiteSettingModel siteSettingModelFromJson(String str) => SiteSettingModel.fromJson(json.decode(str));

String siteSettingModelToJson(SiteSettingModel data) => json.encode(data.toJson());

class SiteSettingModel {
  SiteSettingModel({
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

  factory SiteSettingModel.fromJson(Map<String, dynamic> json) => SiteSettingModel(
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
    this.websiteTitle,
    this.currencyRate,
    this.colorSet,
  });

  String websiteTitle;
  CurrencyRate currencyRate;
  ColorSet colorSet;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    websiteTitle: json["WebsiteTitle"],
    currencyRate: CurrencyRate.fromJson(json["CurrencyRate"]),
    colorSet: ColorSet.fromJson(json["ColorSet"]),
  );

  Map<String, dynamic> toJson() => {
    "WebsiteTitle": websiteTitle,
    "CurrencyRate": currencyRate.toJson(),
    "ColorSet": colorSet.toJson(),
  };
}

class ColorSet {
  ColorSet({
    this.accent,
    this.accentsec,
    this.secondary,
    this.mainbody,
    this.innerpage,
    this.header,
    this.menubar,
  });

  String accent;
  String accentsec;
  String secondary;
  String mainbody;
  String innerpage;
  String header;
  String menubar;

  factory ColorSet.fromJson(Map<String, dynamic> json) => ColorSet(
    accent: json["accent"],
    accentsec: json["accentsec"],
    secondary: json["secondary"],
    mainbody: json["mainbody"],
    innerpage: json["innerpage"],
    header: json["header"],
    menubar: json["menubar"],
  );

  Map<String, dynamic> toJson() => {
    "accent": accent,
    "accentsec": accentsec,
    "secondary": secondary,
    "mainbody": mainbody,
    "innerpage": innerpage,
    "header": header,
    "menubar": menubar,
  };
}

class CurrencyRate {
  CurrencyRate({
    this.bdt,
    this.gbp,
    this.eur,
    this.myr,
    this.inr,
  });

  String bdt;
  String gbp;
  String eur;
  String myr;
  String inr;

  factory CurrencyRate.fromJson(Map<String, dynamic> json) => CurrencyRate(
    bdt: json["BDT"],
    gbp: json["GBP"],
    eur: json["EUR"],
    myr: json["MYR"],
    inr: json["INR"],
  );

  Map<String, dynamic> toJson() => {
    "BDT": bdt,
    "GBP": gbp,
    "EUR": eur,
    "MYR": myr,
    "INR": inr,
  };
}