import 'package:flutter/material.dart';

void showSnackBar(BuildContext context,String message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Container(
      alignment: Alignment.center,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Text(message,style: TextStyle(color: Colors.white),),
    ),
   backgroundColor: Colors.transparent,
    elevation: 0.0,
    duration: Duration(milliseconds: 4000),
  ));
}