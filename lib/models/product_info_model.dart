// To parse this JSON data, do
//
//     final productInfoModel = productInfoModelFromJson(jsonString);

import 'dart:convert';

ProductInfoModel productInfoModelFromJson(String str) => ProductInfoModel.fromJson(json.decode(str));

String productInfoModelToJson(ProductInfoModel data) => json.encode(data.toJson());

class ProductInfoModel {
  ProductInfoModel({
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

  factory ProductInfoModel.fromJson(Map<String, dynamic> json) => ProductInfoModel(
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
    this.productId,
    this.productLink,
    this.name,
    this.category,
    this.brand,
    this.priceStock,
    this.discount,
    this.availableSized,
    this.availableColors,
    this.thumnailImage,
    this.allImages,
    this.totalViews,
    this.rating,
    this.description,
    this.productReviews,
    this.productQuestions,
  });

  int productId;
  String productLink;
  String name;
  Category category;
  String brand;
  PriceStock priceStock;
  int discount;
  List<String> availableSized;
  List<AvailableColor> availableColors;
  String thumnailImage;
  AllImages allImages;
  int totalViews;
  Rating rating;
  String description;
  List<ProductReview> productReviews;
  List<ProductQuestion> productQuestions;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    productId: json["product_id"],
    productLink: json["product_link"],
    name: json["name"],
    category: Category.fromJson(json["category"]),
    brand: json["brand"],
    priceStock: PriceStock.fromJson(json["price_stock"]),
    discount: json["discount"],
    availableSized: List<String>.from(json["available_sized"].map((x) => x)),
    availableColors: List<AvailableColor>.from(json["available_colors"].map((x) => availableColorValues.map[x])),
    thumnailImage: json["thumnail_image"],
    allImages: AllImages.fromJson(json["all_images"]),
    totalViews: json["total_views"],
    rating: Rating.fromJson(json["rating"]),
    description: json["description"],
    productReviews: List<ProductReview>.from(json["product_reviews"].map((x) => ProductReview.fromJson(x))),
    productQuestions: List<ProductQuestion>.from(json["product_questions"].map((x) => ProductQuestion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "product_link": productLink,
    "name": name,
    "category": category.toJson(),
    "brand": brand,
    "price_stock": priceStock.toJson(),
    "discount": discount,
    "available_sized": List<dynamic>.from(availableSized.map((x) => x)),
    "available_colors": List<dynamic>.from(availableColors.map((x) => availableColorValues.reverse[x])),
    "thumnail_image": thumnailImage,
    "all_images": allImages.toJson(),
    "total_views": totalViews,
    "rating": rating.toJson(),
    "description": description,
    "product_reviews": List<dynamic>.from(productReviews.map((x) => x.toJson())),
    "product_questions": List<dynamic>.from(productQuestions.map((x) => x.toJson())),
  };
}

class AllImages {
  AllImages({
    this.black,
    this.blue,
    this.green,
  });

  List<String> black;
  List<String> blue;
  List<String> green;

  factory AllImages.fromJson(Map<String, dynamic> json) => AllImages(
    black:  List<String>.from(json["black"].map((x) => x)),
    blue: List<String>.from(json["blue"].map((x) => x)),
    green: List<String>.from(json["green"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "black": List<dynamic>.from(black.map((x) => x)),
    "blue": List<dynamic>.from(blue.map((x) => x)),
    "green": List<dynamic>.from(green.map((x) => x)),
  };
}

enum AvailableColor { BLACK, BLUE, GREEN }

final availableColorValues = EnumValues({
  "black": AvailableColor.BLACK,
  "blue": AvailableColor.BLUE,
  "green": AvailableColor.GREEN
});

class Category {
  Category({
    this.categoryId,
    this.categoryMain,
    this.categoryHeader,
    this.categorySub,
  });

  int categoryId;
  String categoryMain;
  String categoryHeader;
  String categorySub;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoryId: json["category_id"],
    categoryMain: json["category_main"],
    categoryHeader: json["category_header"],
    categorySub: json["category_sub"],
  );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "category_main": categoryMain,
    "category_header": categoryHeader,
    "category_sub": categorySub,
  };
}

class PriceStock {
  PriceStock({
    this.price,
    this.stock,
    this.priceChart,
  });

  int price;
  int stock;
  List<PriceChart> priceChart;

  factory PriceStock.fromJson(Map<String, dynamic> json) => PriceStock(
    price: json["price"],
    stock: json["stock"],
    priceChart: List<PriceChart>.from(json["price_chart"].map((x) => PriceChart.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "price": price,
    "stock": stock,
    "price_chart": List<dynamic>.from(priceChart.map((x) => x.toJson())),
  };
}

class PriceChart {
  PriceChart({
    this.iS,
    this.iC,
    this.sP,
    this.sA,
  });

  String iS;
  AvailableColor iC;
  String sP;
  String sA;

  factory PriceChart.fromJson(Map<String, dynamic> json) => PriceChart(
    iS: json["i_s"],
    iC: availableColorValues.map[json["i_c"]],
    sP: json["s_p"],
    sA: json["s_a"],
  );

  Map<String, dynamic> toJson() => {
    "i_s": iS,
    "i_c": availableColorValues.reverse[iC],
    "s_p": sP,
    "s_a": sA,
  };
}

class ProductQuestion {
  ProductQuestion({
    this.qusId,
    this.date,
    this.name,
    this.username,
    this.qusText,
    this.status,
    this.replies,
  });

  String qusId;
  DateTime date;
  String name;
  String username;
  String qusText;
  String status;
  List<ProductQuestion> replies;

  factory ProductQuestion.fromJson(Map<String, dynamic> json) => ProductQuestion(
    qusId: json["qusId"],
    date: DateTime.parse(json["date"]),
    name: json["name"],
    username: json["username"],
    qusText: json["qusText"],
    status: json["status"],
    replies: json["replies"] == null ? null : List<ProductQuestion>.from(json["replies"].map((x) => ProductQuestion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "qusId": qusId,
    "date": date.toIso8601String(),
    "name": name,
    "username": username,
    "qusText": qusText,
    "status": status,
    "replies": replies == null ? null : List<dynamic>.from(replies.map((x) => x.toJson())),
  };
}

class ProductReview {
  ProductReview({
    this.reviewId,
    this.date,
    this.username,
    this.reviewText,
    this.rating,
    this.status,
  });

  String reviewId;
  DateTime date;
  String username;
  String reviewText;
  String rating;
  String status;

  factory ProductReview.fromJson(Map<String, dynamic> json) => ProductReview(
    reviewId: json["reviewId"],
    date: DateTime.parse(json["date"]),
    username: json["username"],
    reviewText: json["reviewText"],
    rating: json["rating"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "reviewId": reviewId,
    "date": date.toIso8601String(),
    "username": username,
    "reviewText": reviewText,
    "rating": rating,
    "status": status,
  };
}

class Rating {
  Rating({
    this.totalReviewer,
    this.averageRating,
    this.totalRating5,
    this.totalRating4,
    this.totalRating3,
    this.totalRating2,
    this.totalRating1,
  });

  int totalReviewer;
  int averageRating;
  int totalRating5;
  int totalRating4;
  int totalRating3;
  int totalRating2;
  int totalRating1;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    totalReviewer: json["total_reviewer"],
    averageRating: json["average_rating"],
    totalRating5: json["total_rating_5"],
    totalRating4: json["total_rating_4"],
    totalRating3: json["total_rating_3"],
    totalRating2: json["total_rating_2"],
    totalRating1: json["total_rating_1"],
  );

  Map<String, dynamic> toJson() => {
    "total_reviewer": totalReviewer,
    "average_rating": averageRating,
    "total_rating_5": totalRating5,
    "total_rating_4": totalRating4,
    "total_rating_3": totalRating3,
    "total_rating_2": totalRating2,
    "total_rating_1": totalRating1,
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
