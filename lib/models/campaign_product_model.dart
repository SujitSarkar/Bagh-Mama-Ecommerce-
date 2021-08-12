import 'dart:convert';

CampaignProductModel campaignProductModelFromJson(String str) => CampaignProductModel.fromJson(json.decode(str));

String campaignProductModelToJson(CampaignProductModel data) => json.encode(data.toJson());

class CampaignProductModel {
  CampaignProductModel({
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

  factory CampaignProductModel.fromJson(Map<String, dynamic> json) => CampaignProductModel(
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
    this.id,
    this.name,
    this.categoryId,
    this.brand,
    this.priceStockChart,
    this.sizes,
    this.colors,
    this.views,
    this.discount,
    this.addedDate,
    this.thumbnailImage,
    this.status,
  });

  int id;
  String name;
  int categoryId;
  String brand;
  List<PriceStockChart> priceStockChart;
  List<String> sizes;
  List<String> colors;
  int views;
  int discount;
  DateTime addedDate;
  String thumbnailImage;
  int status;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"],
    name: json["name"],
    categoryId: json["category_id"],
    brand: json["brand"],
    priceStockChart: List<PriceStockChart>.from(json["price_stock_chart"].map((x) => PriceStockChart.fromJson(x))),
    sizes: List<String>.from(json["sizes"].map((x) => x)),
    colors: List<String>.from(json["colors"].map((x) => x)),
    views: json["views"],
    discount: json["discount"],
    addedDate: DateTime.parse(json["added_date"]),
    thumbnailImage: json["thumbnail_image"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category_id": categoryId,
    "brand": brand,
    "price_stock_chart": List<dynamic>.from(priceStockChart.map((x) => x.toJson())),
    "sizes": List<dynamic>.from(sizes.map((x) => x)),
    "colors": List<dynamic>.from(colors.map((x) => x)),
    "views": views,
    "discount": discount,
    "added_date": addedDate.toIso8601String(),
    "thumbnail_image": thumbnailImage,
    "status": status,
  };
}

class PriceStockChart {
  PriceStockChart({
    this.iS,
    this.iC,
    this.sP,
    this.sA,
  });

  String iS;
  String iC;
  String sP;
  String sA;

  factory PriceStockChart.fromJson(Map<String, dynamic> json) => PriceStockChart(
    iS: json["i_s"],
    iC: json["i_c"],
    sP: json["s_p"],
    sA: json["s_a"],
  );

  Map<String, dynamic> toJson() => {
    "i_s": iS,
    "i_c": iC,
    "s_p": sP,
    "s_a": sA,
  };
}