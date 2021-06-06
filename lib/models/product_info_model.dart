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
    this.availableSizes,
    this.availableColors,
    this.thumnailImage,
    this.allImages,
    this.totalViews,
    this.rating,
    this.description,
  });

  int productId;
  String productLink;
  String name;
  Category category;
  String brand;
  PriceStock priceStock;
  int discount;
  List<String> availableSizes;
  List<String> availableColors;
  String thumnailImage;
  List<String> allImages;
  int totalViews;
  Rating rating;
  String description;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    productId: json["product_id"],
    productLink: json["product_link"],
    name: json["name"],
    category: Category.fromJson(json["category"]),
    brand: json["brand"],
    priceStock: PriceStock.fromJson(json["price_stock"]),
    discount: json["discount"],
    availableSizes: List<String>.from(json["available_sizes"].map((x) => x)),
    availableColors: List<String>.from(json["available_colors"].map((x) => x)),
    thumnailImage: json["thumnail_image"],
    allImages: List<String>.from(json["all_images"].map((x) => x)),
    totalViews: json["total_views"],
    rating: Rating.fromJson(json["rating"]),
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "product_link": productLink,
    "name": name,
    "category": category.toJson(),
    "brand": brand,
    "price_stock": priceStock.toJson(),
    "discount": discount,
    "available_sizes": List<dynamic>.from(availableSizes.map((x) => x)),
    "available_colors": List<dynamic>.from(availableColors.map((x) => x)),
    "thumnail_image": thumnailImage,
    "all_images": List<dynamic>.from(allImages.map((x) => x)),
    "total_views": totalViews,
    "rating": rating.toJson(),
    "description": description,
  };
}

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
  String iC;
  String sP;
  String sA;

  factory PriceChart.fromJson(Map<String, dynamic> json) => PriceChart(
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

class ProductReviewModel{
  String reviewId;
  String date;
  String username;
  String reviewText;
  String rating;
  String status;

  ProductReviewModel({this.reviewId, this.date, this.username, this.reviewText,
      this.rating, this.status});
}
///ProductQuestion Model
List<ProductQuestionModel> productQuestionModelFromJson(String str) => List<ProductQuestionModel>.from(json.decode(str).map((x) => ProductQuestionModel.fromJson(x)));

String productQuestionModelToJson(List<ProductQuestionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductQuestionModel {
  ProductQuestionModel({
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
  List<ProductQuestionModel> replies;

  factory ProductQuestionModel.fromJson(Map<String, dynamic> json) => ProductQuestionModel(
    qusId: json["qusId"],
    date: DateTime.parse(json["date"]),
    name: json["name"],
    username: json["username"],
    qusText: json["qusText"],
    status: json["status"],
    replies: json["replies"] == null ? null : List<ProductQuestionModel>.from(json["replies"].map((x) => ProductQuestionModel.fromJson(x))),
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









