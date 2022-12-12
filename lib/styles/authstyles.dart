import 'package:flutter/material.dart';

class AuthStyle{
  InputDecoration textInput({String? text}){
    return InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        hintText: text,
        hintStyle: TextStyle(
          fontSize: 21.0,
          color: Colors.grey[500]
        ),
        filled: true,
        fillColor: Colors.grey[100],
        focusColor: Colors.blueAccent,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
                width: 2.0,
                color: Colors.blue,
                style: BorderStyle.solid
            )
        )
    );
  }

  TextStyle textStyle(){
    return const TextStyle(
      fontSize: 23.0,
    );
  }
}