// To parse this JSON data, do
//
//     final orderInfoModel = orderInfoModelFromJson(jsonString);

import 'dart:convert';

OrderInfoModel orderInfoModelFromJson(String str) => OrderInfoModel.fromJson(json.decode(str));

String orderInfoModelToJson(OrderInfoModel data) => json.encode(data.toJson());

class OrderInfoModel {
  OrderInfoModel({
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

  factory OrderInfoModel.fromJson(Map<String, dynamic> json) => OrderInfoModel(
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
    this.orderNo,
    this.orderDate,
    this.customerName,
    this.customerPhone,
    this.customerUsername,
    this.customerAddress,
    this.deliveryLocation,
    this.shippingInfo,
    this.paymentInfo,
    this.couponInfo,
    this.products,
    this.orderStatus,
    this.orderSummery,
  });

  int orderNo;
  DateTime orderDate;
  String customerName;
  String customerPhone;
  String customerUsername;
  String customerAddress;
  String deliveryLocation;
  ShippingInfo shippingInfo;
  PaymentInfo paymentInfo;
  CouponInfo couponInfo;
  List<Product> products;
  OrderStatus orderStatus;
  OrderSummery orderSummery;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    orderNo: json["order_no"],
    orderDate: DateTime.parse(json["order_date"]),
    customerName: json["customer_name"],
    customerPhone: json["customer_phone"],
    customerUsername: json["customer_username"],
    customerAddress: json["customer_address"],
    deliveryLocation: json["delivery_location"],
    shippingInfo: ShippingInfo.fromJson(json["shipping_info"]),
    paymentInfo: PaymentInfo.fromJson(json["payment_info"]),
    couponInfo: CouponInfo.fromJson(json["coupon_info"]),
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    orderStatus: OrderStatus.fromJson(json["order_status"]),
    orderSummery: OrderSummery.fromJson(json["order_summery"]),
  );

  Map<String, dynamic> toJson() => {
    "order_no": orderNo,
    "order_date": orderDate.toIso8601String(),
    "customer_name": customerName,
    "customer_phone": customerPhone,
    "customer_username": customerUsername,
    "customer_address": customerAddress,
    "delivery_location": deliveryLocation,
    "shipping_info": shippingInfo.toJson(),
    "payment_info": paymentInfo.toJson(),
    "coupon_info": couponInfo.toJson(),
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "order_status": orderStatus.toJson(),
    "order_summery": orderSummery.toJson(),
  };
}

class CouponInfo {
  CouponInfo({
    this.couponId,
    this.couponCode,
    this.discount,
  });

  dynamic couponId;
  dynamic couponCode;
  int discount;

  factory CouponInfo.fromJson(Map<String, dynamic> json) => CouponInfo(
    couponId: json["coupon_id"],
    couponCode: json["coupon_code"],
    discount: json["discount"],
  );

  Map<String, dynamic> toJson() => {
    "coupon_id": couponId,
    "coupon_code": couponCode,
    "discount": discount,
  };
}

class OrderStatus {
  OrderStatus({
    this.status,
    this.description,
  });

  String status;
  String description;

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
    status: json["status"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "description": description,
  };
}

class OrderSummery {
  OrderSummery({
    this.totalCostWithoutDiscount,
    this.discountTotal,
    this.deliveryCost,
    this.couponDiscount,
  });

  int totalCostWithoutDiscount;
  int discountTotal;
  int deliveryCost;
  int couponDiscount;

  factory OrderSummery.fromJson(Map<String, dynamic> json) => OrderSummery(
    totalCostWithoutDiscount: json["total_cost_without_discount"],
    discountTotal: json["discount_total"],
    deliveryCost: json["delivery_cost"],
    couponDiscount: json["coupon_discount"],
  );

  Map<String, dynamic> toJson() => {
    "total_cost_without_discount": totalCostWithoutDiscount,
    "discount_total": discountTotal,
    "delivery_cost": deliveryCost,
    "coupon_discount": couponDiscount,
  };
}

class PaymentInfo {
  PaymentInfo({
    this.paymentType,
    this.paymentTrxnId,
    this.paymentStatus,
  });

  String paymentType;
  String paymentTrxnId;
  String paymentStatus;

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
    paymentType: json["payment_type"],
    paymentTrxnId: json["payment_trxn_id"],
    paymentStatus: json["payment_status"],
  );

  Map<String, dynamic> toJson() => {
    "payment_type": paymentType,
    "payment_trxn_id": paymentTrxnId,
    "payment_status": paymentStatus,
  };
}

class Product {
  Product({
    this.productId,
    this.productName,
    this.productThumb,
    this.productSize,
    this.productColor,
    this.productQuantity,
  });

  String productId;
  String productName;
  String productThumb;
  String productSize;
  String productColor;
  int productQuantity;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productId: json["productId"],
    productName: json["productName"],
    productThumb: json["productThumb"],
    productSize: json["productSize"],
    productColor: json["productColor"],
    productQuantity: json["productQuantity"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "productThumb": productThumb,
    "productSize": productSize,
    "productColor": productColor,
    "productQuantity": productQuantity,
  };
}

class ShippingInfo {
  ShippingInfo({
    this.priority,
    this.shippingName,
    this.shippingPhone,
    this.shippingAddress,
    this.methodId,
    this.deliveryCost,
  });

  String priority;
  String shippingName;
  String shippingPhone;
  String shippingAddress;
  int methodId;
  int deliveryCost;

  factory ShippingInfo.fromJson(Map<String, dynamic> json) => ShippingInfo(
    priority: json["priority"],
    shippingName: json["shipping_name"],
    shippingPhone: json["shipping_phone"],
    shippingAddress: json["shipping_address"],
    methodId: json["method_id"],
    deliveryCost: json["delivery_cost"],
  );

  Map<String, dynamic> toJson() => {
    "priority": priority,
    "shipping_name": shippingName,
    "shipping_phone": shippingPhone,
    "shipping_address": shippingAddress,
    "method_id": methodId,
    "delivery_cost": deliveryCost,
  };
}
