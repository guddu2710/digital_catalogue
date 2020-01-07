import 'package:flutter/material.dart';
class Common {
  String tokenData;
   // convert color "#AABBCC" to  0xFFAABBCC start
      Color hexToColor(String code) {
        return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
      }
      //  convert color "#AABBCC" to  0xFFAABBCC end





}







