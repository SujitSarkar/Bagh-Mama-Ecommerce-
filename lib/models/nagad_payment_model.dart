// To parse this JSON data, do
//
//     final nagadPaymentModel = nagadPaymentModelFromJson(jsonString);

import 'dart:convert';

NagadPaymentModel nagadPaymentModelFromJson(String str) => NagadPaymentModel.fromJson(json.decode(str));

String nagadPaymentModelToJson(NagadPaymentModel data) => json.encode(data.toJson());

class NagadPaymentModel {
  NagadPaymentModel({
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

  factory NagadPaymentModel.fromJson(Map<String, dynamic> json) => NagadPaymentModel(
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
    this.merchantId,
    this.orderId,
    this.paymentRefId,
    this.amount,
    this.clientMobileNo,
    this.merchantMobileNo,
    this.orderDateTime,
    this.issuerPaymentDateTime,
    this.issuerPaymentRefNo,
    this.additionalMerchantInfo,
    this.status,
    this.statusCode,
    this.cancelIssuerDateTime,
    this.cancelIssuerRefNo,
  });

  String merchantId;
  String orderId;
  String paymentRefId;
  String amount;
  String clientMobileNo;
  String merchantMobileNo;
  DateTime orderDateTime;
  DateTime issuerPaymentDateTime;
  String issuerPaymentRefNo;
  dynamic additionalMerchantInfo;
  String status;
  String statusCode;
  dynamic cancelIssuerDateTime;
  dynamic cancelIssuerRefNo;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    merchantId: json["merchantId"],
    orderId: json["orderId"],
    paymentRefId: json["paymentRefId"],
    amount: json["amount"],
    clientMobileNo: json["clientMobileNo"],
    merchantMobileNo: json["merchantMobileNo"],
    orderDateTime: DateTime.parse(json["orderDateTime"]),
    issuerPaymentDateTime: DateTime.parse(json["issuerPaymentDateTime"]),
    issuerPaymentRefNo: json["issuerPaymentRefNo"],
    additionalMerchantInfo: json["additionalMerchantInfo"],
    status: json["status"],
    statusCode: json["statusCode"],
    cancelIssuerDateTime: json["cancelIssuerDateTime"],
    cancelIssuerRefNo: json["cancelIssuerRefNo"],
  );

  Map<String, dynamic> toJson() => {
    "merchantId": merchantId,
    "orderId": orderId,
    "paymentRefId": paymentRefId,
    "amount": amount,
    "clientMobileNo": clientMobileNo,
    "merchantMobileNo": merchantMobileNo,
    "orderDateTime": orderDateTime.toIso8601String(),
    "issuerPaymentDateTime": issuerPaymentDateTime.toIso8601String(),
    "issuerPaymentRefNo": issuerPaymentRefNo,
    "additionalMerchantInfo": additionalMerchantInfo,
    "status": status,
    "statusCode": statusCode,
    "cancelIssuerDateTime": cancelIssuerDateTime,
    "cancelIssuerRefNo": cancelIssuerRefNo,
  };
}