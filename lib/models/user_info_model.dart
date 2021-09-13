// To parse this JSON data, do
//
//     final userInfoModel = userInfoModelFromJson(jsonString);

import 'dart:convert';

UserInfoModel userInfoModelFromJson(String str) => UserInfoModel.fromJson(json.decode(str));

String userInfoModelToJson(UserInfoModel data) => json.encode(data.toJson());

class UserInfoModel {
  UserInfoModel({
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

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
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
    this.id,
    this.joined,
    this.username,
    this.password,
    this.token,
    this.firstName,
    this.lastName,
    this.email,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalcode,
    this.mobileNumber,
    this.profilePic,
    this.wishlists,
    this.customerOrders
  });

  String id;
  DateTime joined;
  String username;
  String password;
  String token;
  String firstName;
  String lastName;
  String email;
  String address;
  String city;
  String state;
  String country;
  String postalcode;
  String mobileNumber;
  String profilePic;
  List<String> wishlists;
  List<CustomerOrder> customerOrders;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"],
    joined: DateTime.parse(json["joined"]),
    username: json["username"],
    password: json["password"],
    token: json["token"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    postalcode: json["postalcode"],
    mobileNumber: json["mobile_number"],
    profilePic: json["profile_pic"],
    wishlists: List<String>.from(json["wishlists"].map((x) => x)),
    customerOrders: List<CustomerOrder>.from(json["customer_orders"].map((x) => CustomerOrder.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "joined": joined.toIso8601String(),
    "username": username,
    "password": password,
    "token": token,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "postalcode": postalcode,
    "mobile_number": mobileNumber,
    "profile_pic": profilePic,
    "wishlists": List<dynamic>.from(wishlists.map((x) => x)),
    "customer_orders": List<dynamic>.from(customerOrders.map((x) => x.toJson())),
  };
}

class CustomerOrder {
  CustomerOrder({
    this.orderNo,
    this.date,
    this.products,
    this.pstatus,
    this.usedCoupon,
  });

  String orderNo;
  DateTime date;
  List<Product> products;
  String pstatus;
  dynamic usedCoupon;

  factory CustomerOrder.fromJson(Map<String, dynamic> json) => CustomerOrder(
    orderNo: json["order_no"],
    date: DateTime.parse(json["date"]),
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    pstatus: json["pstatus"],
    usedCoupon: json["usedCoupon"],
  );

  Map<String, dynamic> toJson() => {
    "order_no": orderNo,
    "date": date.toIso8601String(),
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "pstatus": pstatus,
    "usedCoupon": usedCoupon,
  };
}

class Product {
  Product({
    this.productImage,
    this.productName,
    this.productPrice,
  });

  String productImage;
  String productName;
  int productPrice;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productImage: json["productImage"],
    productName: json["productName"],
    productPrice: json["productPrice"],
  );

  Map<String, dynamic> toJson() => {
    "productImage": productImage,
    "productName": productName,
    "productPrice": productPrice,
  };
}




class WishListModel{
  String pId;
  String pName;
  String pPrice;
  String pImageLink;

  WishListModel({this.pId, this.pName, this.pPrice, this.pImageLink});
}

class Notifications{
  String notificationType;
  String notificationText;
  String link;
  String status;

  Notifications({
      this.notificationType, this.notificationText, this.link, this.status});
}