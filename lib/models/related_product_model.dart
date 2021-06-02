// To parse this JSON data, do
//
//     final relatedProductModel = relatedProductModelFromJson(jsonString);

import 'dart:convert';

RelatedProductModel relatedProductModelFromJson(String str) => RelatedProductModel.fromJson(json.decode(str));

String relatedProductModelToJson(RelatedProductModel data) => json.encode(data.toJson());

class RelatedProductModel {
  RelatedProductModel({
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

  factory RelatedProductModel.fromJson(Map<String, dynamic> json) => RelatedProductModel(
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
  List<Color> colors;
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
    colors: List<Color>.from(json["colors"].map((x) => colorValues.map[x])),
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
    "colors": List<dynamic>.from(colors.map((x) => colorValues.reverse[x])),
    "views": views,
    "discount": discount,
    "added_date": addedDate.toIso8601String(),
    "thumbnail_image": thumbnailImage,
    "status": status,
  };
}

enum Color { EMPTY, NO, BLUE }

final colorValues = EnumValues({
  "blue": Color.BLUE,
  "": Color.EMPTY,
  "no": Color.NO
});

class PriceStockChart {
  PriceStockChart({
    this.iS,
    this.iC,
    this.sP,
    this.sA,
  });

  String iS;
  Color iC;
  String sP;
  String sA;

  factory PriceStockChart.fromJson(Map<String, dynamic> json) => PriceStockChart(
    iS: json["i_s"],
    iC: colorValues.map[json["i_c"]],
    sP: json["s_p"],
    sA: json["s_a"],
  );

  Map<String, dynamic> toJson() => {
    "i_s": iS,
    "i_c": colorValues.reverse[iC],
    "s_p": sP,
    "s_a": sA,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}