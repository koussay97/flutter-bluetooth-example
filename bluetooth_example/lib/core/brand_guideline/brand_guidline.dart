/// colors, themes , fonts etc

import'package:flutter/material.dart';

abstract class Brand {
/// tool for sampling [link](https://imagecolorpicker.com/en)
  static const mainBackground = Color.fromRGBO(234,248,248,1);

  static const darkBlue = Color.fromRGBO(5,52,147,1);

  static const darkGreyBlue = Color.fromRGBO(7,112,165,1);
  static const brightGreyBlue = Color.fromRGBO(121,176,224,1);
  static const paleGreyBlue = Color.fromRGBO(98,159,188,1);

  static const darkTeal = Color.fromRGBO(10,175,183,1);
  static const brightTeal = Color.fromRGBO(31,220,199,1);
  //static const paleTeal = Color.fromRGBO(234,248,248,1);

  static const darkGery = Color.fromRGBO(140,148,156,1);
  static const lightGrey = Color.fromRGBO(180,188,188,1);
  static const blackGrey = Color.fromRGBO(26, 26, 26, 1.0);


  static double appPadding({required BuildContext context})=>MediaQuery.of(context).size.width*0.1;
  static double appBorderRadius({required BuildContext context})=>MediaQuery.of(context).size.width*0.06;

  static double h1Size(BuildContext context)=> MediaQuery.of(context).size.width* 0.0853; //(32px/375) weight 700 Gotham
  static FontWeight h1Weight= FontWeight.w700; //(16/375) weight 500 Gotham

  // this text is used for the hero title the ones in mainAccent color

  static double h2Size(BuildContext context)=> MediaQuery.of(context).size.width* 0.0533; // (20px/375) weight 500 Gotham
  static FontWeight h2Weight= FontWeight.w500; //(16/375) weight 500 Gotham

  // this text is used for the secondary big titles the ones in primary color

  static double h3Size(BuildContext context)=> MediaQuery.of(context).size.width* 0.0426; //(16/375) weight 500 Gotham
  static FontWeight h3Weight= FontWeight.w500; //(16/375) weight 500 Gotham

  // this text is used for the btn titles the ones in primary color


  static double h4Size(BuildContext context)=> MediaQuery.of(context).size.width* 0.0373; //(14/375) weight 700 Gotham
  static FontWeight h4Weight= FontWeight.w700; //(16/375) weight 500 Gotham

  // this text is used for the clickable text in bold the ones in grey 400

  static double textSize(BuildContext context)=> MediaQuery.of(context).size.width* 0.0373; //(14/375) weight 400 Gotham
  static FontWeight textWeight= FontWeight.w400; //(16/375) weight 500 Gotham

  // this text is used for all of the text content in the app the ones in grey400

  static double textInputSize(BuildContext context)=> MediaQuery.of(context).size.width* 0.0373; //(14/375) weight 400 Gotham
  static FontWeight inputWeight= FontWeight.w500; //(16/375) weight 500 Gotham

// this text is used for any text input the ones in grey500


}