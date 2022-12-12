import 'package:flutter/material.dart';

class CommonStyles{
  static Widget CardText(String? text, double fontSize){
    text ??= "";
    return Text(text,
    maxLines: 2,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: fontSize
    ),
    overflow: TextOverflow.fade,
    );
  }

  static Widget AnimeDetailText(String? text, double fontSize){
    text ??= "";
    return Text(text, style: TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontWeight: FontWeight.w500
    ),textAlign: TextAlign.center,);
  }
}