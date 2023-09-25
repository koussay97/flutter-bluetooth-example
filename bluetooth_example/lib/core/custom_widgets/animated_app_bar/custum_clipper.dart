
import 'package:flutter/material.dart';
class AnimatedClipper extends CustomClipper<Path> {
  double move1;
  double move2;

  AnimatedClipper({required this.move1, required this.move2});

  @override
  Path getClip(Size size) {

    Path path = Path();
    path.lineTo(0, size.height * 0.8 );

    /// coordinates of the quadratic bezier virtual point
    double x1Center = size.width * 0.5 + move1;
    double x2Center = size.width * 0.5 - move2;
    double y1Center = size.height - move1;
    double y2Center = size.height - move2;
    path.quadraticBezierTo(x1Center, y1Center, size.width, size.height *0.8);
    //path.quadraticBezierTo(x2Center+size.width*0.5, y2Center, size.width, size.height*0.8);

    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
