import 'package:buscadordegifs/UI/home_page.dart';
import 'package:buscadordegifs/model/api_consummer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
          hintColor: Colors.white,
          cursorColor: Colors.white,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            hintStyle: TextStyle(color: Colors.white),
          )
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
  ));
}



