//abstract class
import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future showPopup(
    {required BuildContext context,
      required String title,
      required Widget ctaWidget,
      required Widget centerIcon,
      required double innerPadding,
      required String text}) async {
  return showDialog(
      barrierDismissible: true,
      //useSafeArea: true,
      context: context,
      builder: (_) => Dialog(

        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        child: Container(
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Brand.darkBlue,width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Brand.appPadding(context: context),
                vertical: Brand.appPadding(context: context)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                centerIcon,

                SizedBox(
                  height: innerPadding,
                ),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: Brand.h3Size(context),
                    color: Brand.darkBlue,
                    fontWeight: Brand.h3Weight,
                  ),
                ),
                SizedBox(
                  height: innerPadding,
                ),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: Brand.textSize(context),
                    color: Brand.blackGrey,
                    fontWeight: Brand.textWeight,

                  ),
                ),
                SizedBox(
                  height: innerPadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ctaWidget,
                  ],
                ),
              ],
            ),
          ),
        ),
      ));
}