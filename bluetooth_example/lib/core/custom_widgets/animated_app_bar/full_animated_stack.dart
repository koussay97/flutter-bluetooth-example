import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/core/custom_widgets/animated_app_bar/custum_clipper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedAppBar extends StatefulWidget {
  const AnimatedAppBar({Key? key}) : super(key: key);

  @override
  State<AnimatedAppBar> createState() => _AnimatedAppBarState();
}

class _AnimatedAppBarState extends State<AnimatedAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  //late final Animation<double> _zeroCurveAnimation;
  late final Animation<double> _firstCurveAnimation;
  late final Animation<double> _secondCurveAnimation;
  late final Animation<double> _thirdCurveAnimation;

  void controllerListener() {
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )
      ..repeat(reverse: true)
      ..addListener(controllerListener);
    startAnimations();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.removeListener(controllerListener);
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    final deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, a) {
          return Stack(
            alignment: Alignment.center,
            children: [

              CustomCurveBox(
                  height: deviceWidth * 0.5,
                  width: deviceWidth,
                  colorsList: [
                    Brand.brightTeal.withOpacity(0.4),
                    Brand.darkTeal.withOpacity(0.4),
                    Brand.brightGreyBlue.withOpacity(0.4),
                    Brand.paleGreyBlue.withOpacity(0.4),
                    Brand.darkGreyBlue.withOpacity(0.4)
                  ],
                  movingFactor2: _secondCurveAnimation.value,
                  movingFactor1: _firstCurveAnimation.value),
              CustomCurveBox(
                height: deviceWidth * 0.5,
                width: deviceWidth,
                colorsList: [
                  //Brand.brightTeal,
                  Brand.darkTeal.withOpacity(0.4),
                  Brand.brightGreyBlue.withOpacity(0.4),
                  Brand.paleGreyBlue.withOpacity(0.4),
                  Brand.darkGreyBlue.withOpacity(0.4),
                  Brand.darkBlue.withOpacity(0.4),
                ],
                movingFactor1: _secondCurveAnimation.value,
                movingFactor2: _thirdCurveAnimation.value,

              ),
              CustomCurveBox(
                height: deviceWidth * 0.5,
                width: deviceWidth,
                colorsList: [
                  Brand.darkGreyBlue.withOpacity(0.2),
                  Brand.paleGreyBlue.withOpacity(0.2),
                  Brand.brightGreyBlue.withOpacity(0.2),
                  Brand.darkTeal.withOpacity(0.2),
                  Brand.brightTeal.withOpacity(0.2),
                ],
                movingFactor1: _thirdCurveAnimation.value,
                movingFactor2: _secondCurveAnimation.value,
              ),
              Positioned(
                width: deviceWidth * 0.8,

                child: Text(
                    textAlign: TextAlign.center,
                    'Welcome To Hayat Technology',
                    style: GoogleFonts.titanOne(
                      color: Brand.mainBackground,
                      fontSize: deviceWidth * 0.05,
                      fontWeight: FontWeight.w400,
                    )
                ),
              ),
            /*  Transform.scale(
                  origin: Offset.zero,
                  scaleY: _zeroCurveAnimation.value,
                  child: Container(
                    height: 0,
                    width: deviceWidth,
                    color: Colors.yellow,
                  )
              ),*/
            ],
          );
        });
  }

  void startAnimations() {
 /*   _zeroCurveAnimation =  Tween(begin: double.infinity, end: 0.0).animate(
        CurvedAnimation(parent: _animationController, curve: const Interval(
            0.0, 0.5, curve: Curves.bounceInOut
        )));
*/
    _firstCurveAnimation = Tween(begin: 0.0, end: 40.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.2,
          0.9,
          curve: Curves.easeInOut,
        ))
    );

    _secondCurveAnimation =
        Tween(begin: 0.0, end: -20.0).animate(CurvedAnimation(
            parent: _animationController,
            curve: const Interval(
              0.3,
              1.0,
              curve: Curves.easeInOut,
            )
        ));
    _thirdCurveAnimation = Tween(begin: 0.0, end: 70.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.3,
          0.7,
          curve: Curves.easeInOut,
        )));
  }
}

class CustomCurveBox extends StatelessWidget {
  final List<Color> colorsList;
  double? movingFactor1;
  double? movingFactor2;
  final double height;
  final double width;

  CustomCurveBox({Key? key,
    required this.height,
    required this.width,
    required this.colorsList,
    this.movingFactor1,
    this.movingFactor2,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: AnimatedClipper(
          move2: movingFactor2 ?? 0.0, move1: movingFactor1 ?? 0.0),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: colorsList, stops: const [
              0,
              0.1,
              0.3,
              0.6,
              0.9,
            ])),
      ),
    );
  }
}