import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  textTheme: TextTheme(
    display4: TextStyle(color: Colors.red),
    display3: TextStyle(color: Colors.green),
    display2: TextStyle(color: Colors.blue),
    display1: TextStyle(color: Colors.yellow),
    body2: TextStyle(
        color: Colors.black,
        fontFamily: "Roboto",
        fontSize: 14,
        fontWeight: FontWeight.w400),
    body1: TextStyle(
      color: Colors.black,
      fontFamily: "Roboto",
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    headline: TextStyle(color: Colors.grey),
    title: TextStyle(
      color: Colors.black,
      fontFamily: "Comfortaa",
      fontSize: 30,
    ),
    subhead: TextStyle(color: Colors.black),
    subtitle: TextStyle(color: Colors.purple),
    button: TextStyle(
        color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2.0),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2.0),
    ),
    labelStyle: TextStyle(color: Colors.black),
  ),
);
