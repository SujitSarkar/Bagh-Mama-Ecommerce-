// To parse this JSON data, do
//
//     final productsModel = productsModelFromJson(jsonString);

import 'dart:convert';

ProductsModel productsModelFromJson(String str) => ProductsModel.fromJson(json.decode(str));

String productsModelToJson(ProductsModel data) => json.encode(data.toJson());

class ProductsModel {
  ProductsModel({
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

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
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
    this.status,
  });

  int id;
  String name;
  int categoryId;
  Brand brand;
  List<PriceStockChart> priceStockChart;
  List<String> sizes;
  List<Color> colors;
  int views;
  int discount;
  DateTime addedDate;
  int status;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"],
    name: json["name"],
    categoryId: json["category_id"],
    brand: brandValues.map[json["brand"]],
    priceStockChart: List<PriceStockChart>.from(json["price_stock_chart"].map((x) => PriceStockChart.fromJson(x))),
    sizes: List<String>.from(json["sizes"].map((x) => x)),
    colors: List<Color>.from(json["colors"].map((x) => colorValues.map[x])),
    views: json["views"],
    discount: json["discount"],
    addedDate: DateTime.parse(json["added_date"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category_id": categoryId,
    "brand": brandValues.reverse[brand],
    "price_stock_chart": List<dynamic>.from(priceStockChart.map((x) => x.toJson())),
    "sizes": List<dynamic>.from(sizes.map((x) => x)),
    "colors": List<dynamic>.from(colors.map((x) => colorValues.reverse[x])),
    "views": views,
    "discount": discount,
    "added_date": addedDate.toIso8601String(),
    "status": status,
  };
}

enum Brand { EMPTY, GPHONE, THE_5_STAR }

final brandValues = EnumValues({
  "": Brand.EMPTY,
  "Gphone": Brand.GPHONE,
  "5 star": Brand.THE_5_STAR
});

enum Color { EMPTY, NO }

final colorValues = EnumValues({
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