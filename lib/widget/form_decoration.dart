import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';

InputDecoration boxFormDecoration(Size size) => InputDecoration(
    labelText: '',
    labelStyle: TextStyle(
        color: Colors.grey,
        fontSize: size.width*.04,
        fontWeight: FontWeight.w400,
    ),
    border: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.grey,
            width: 0.5
        )
    ),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.grey,
            width: 0.5
        )
    ),
    disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.grey,
            width: 0.5
        )
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.grey,
            width: 0.5
        )
    ),
);
