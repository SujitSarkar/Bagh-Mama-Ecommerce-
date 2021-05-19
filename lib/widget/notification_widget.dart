import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void showSnackBar(BuildContext context,String message,ThemeProvider themeProvider){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Container(
      alignment: Alignment.center,
      height: 50,
      decoration: BoxDecoration(
        color: themeProvider.toggleSnackBgColor(),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Text(message,style: TextStyle(color: Colors.white),),
    ),
   backgroundColor: Colors.transparent,
    elevation: 0.0,
    duration: Duration(milliseconds: 4000),
  ));
}

void showLoadingDialog(String status)=> EasyLoading.show(status: status);

void closeLoadingDialog()=> EasyLoading.dismiss();

void showSuccessMgs(String status)=> EasyLoading.showSuccess(status);

void showErrorMgs(String status)=> EasyLoading.showError(status);

void showToast(String status)=> EasyLoading.showToast(status);

void showInfo(String status)=> EasyLoading.showInfo(status);