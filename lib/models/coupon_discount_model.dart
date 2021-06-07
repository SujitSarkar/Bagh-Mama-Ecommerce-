
import 'dart:convert';

CouponDiscountModel couponDiscountModelFromJson(String str) => CouponDiscountModel.fromJson(json.decode(str));

String couponDiscountModelToJson(CouponDiscountModel data) => json.encode(data.toJson());

class CouponDiscountModel {
  CouponDiscountModel({
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

  factory CouponDiscountModel.fromJson(Map<String, dynamic> json) => CouponDiscountModel(
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
    this.valid,
    this.type,
    this.discount,
  });

  bool valid;
  int type;
  int discount;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    valid: json["valid"],
    type: json["type"],
    discount: json["discount"],
  );

  Map<String, dynamic> toJson() => {
    "valid": valid,
    "type": type,
    "discount": discount,
  };
}
