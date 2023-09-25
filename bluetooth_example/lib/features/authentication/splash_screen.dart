import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/core/custom_widgets/animated_app_bar/animated_app_bar_exports.dart';
import 'package:bluetooth_example/core/custom_widgets/logo_widget.dart';
import 'package:bluetooth_example/core/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  String msg = 'syrine';

  //double deviceWidth = MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    /// being rendered at 60FPS

    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          gradient:
              RadialGradient(colors: [Colors.white, Brand.mainBackground])),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AnimatedAppBar(),

            LogoWidget(
                blocSize: deviceWidth * 0.4,
                fileLink:
                    "https://media.istockphoto.com/id/1339054744/vector/blue-seaweed-icon-vector-logo-template.jpg?s=612x612&w=0&k=20&c=L3_gt9uLnBKFRkU0iJxSdXTEypnLwlNanFpaOJaonbg="),
            Column(
              children: [
                MaterialButton(
                  height: deviceWidth*0.1,
                    minWidth: deviceWidth*0.5,
                    color: Brand.paleGreyBlue,
                    onPressed: () {
                    Navigator.of(context).maybePop();
                     Navigator.of(context).pushReplacementNamed(RouteAccessors.bluetoothName);
                    },
                    child: Text(
                      'START',
                      style: GoogleFonts.titanOne(
                        color: Colors.white
                      ),
                    )),
                SizedBox(height: deviceWidth * 0.1),
              ],
            ),

            /// go to bluetooth btn
          ],
        ),
      ),
    ));
  }
}
