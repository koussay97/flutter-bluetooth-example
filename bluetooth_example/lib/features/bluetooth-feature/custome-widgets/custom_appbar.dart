
import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget {

  final double deviceWidth;
  const CustomAppBar({Key? key, required this.deviceWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        actions: [
          GestureDetector(
            onTap: (){
              // refresh list of devices
            },
            child: Container(
              height: deviceWidth*0.15,
              width: deviceWidth*0.15,
              color: Brand.darkGreyBlue,
              child: Icon(Icons.refresh,
                  color: Colors.white, size: deviceWidth * 0.06),
            ),
          ),
        ],

        leading: GestureDetector(
          onTap: (){

            if(Navigator.canPop(context)){
              Navigator.of(context).pop();
            }
            else{
              SystemNavigator.pop();
            }
          },
          child: Container(
              width: deviceWidth*0.15,
              height:deviceWidth*0.15 ,
              color: Brand.darkGreyBlue,
              child: Icon(Icons.chevron_left,
                  color: Colors.white, size: deviceWidth * 0.06)),
        ),
        centerTitle: true,
        backgroundColor: Brand.darkTeal,
        title: Text(
          'Pick a device',
          style: GoogleFonts.titanOne(
            color: Colors.white,
          ),
        ));
  }
}