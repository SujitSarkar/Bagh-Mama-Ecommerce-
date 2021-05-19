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
    this.wishlists,
    this.customerOrders,
    this.notifications,
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
  String wishlists;
  List<CustomerOrder> customerOrders;
  List<Notification> notifications;

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
    wishlists: json["wishlists"],
    customerOrders: List<CustomerOrder>.from(json["customer_orders"].map((x) => CustomerOrder.fromJson(x))),
    notifications: List<Notification>.from(json["notifications"].map((x) => Notification.fromJson(x))),
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
    "wishlists": wishlists,
    "customer_orders": List<dynamic>.from(customerOrders.map((x) => x.toJson())),
    "notifications": List<dynamic>.from(notifications.map((x) => x.toJson())),
  };
}

class CustomerOrder {
  CustomerOrder({
    this.orderNo,
    this.date,
  });

  String orderNo;
  DateTime date;

  factory CustomerOrder.fromJson(Map<String, dynamic> json) => CustomerOrder(
    orderNo: json["order_no"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "order_no": orderNo,
    "date": date.toIso8601String(),
  };
}

class Notification {
  Notification({
    this.notificationType,
    this.notificationText,
    this.link,
    this.status,
  });

  String notificationType;
  String notificationText;
  String link;
  String status;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    notificationType: json["notificationType"],
    notificationText: json["notificationText"],
    link: json["link"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "notificationType": notificationType,
    "notificationText": notificationText,
    "link": link,
    "status": status,
  };
}
