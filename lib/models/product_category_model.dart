// To parse this JSON data, do
//
//     final productCategoriesModel = productCategoriesModelFromJson(jsonString);

import 'dart:convert';

ProductCategoriesModel productCategoriesModelFromJson(String str) => ProductCategoriesModel.fromJson(json.decode(str));

String productCategoriesModelToJson(ProductCategoriesModel data) => json.encode(data.toJson());

class ProductCategoriesModel {
  ProductCategoriesModel({
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

  factory ProductCategoriesModel.fromJson(Map<String, dynamic> json) => ProductCategoriesModel(
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
    this.main,
    this.header,
    this.sub,
    this.position,
    this.categoryIcon,
  });

  String id;
  String main;
  String header;
  String sub;
  String position;
  String categoryIcon;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"],
    main: json["main"],
    header: json["header"],
    sub: json["sub"],
    position: json["position"],
    categoryIcon: json["category_icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "main": main,
    "header": header,
    "sub": sub,
    "position": position,
    "category_icon": categoryIcon,
  };
}
