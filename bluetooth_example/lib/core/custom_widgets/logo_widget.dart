import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:flutter/material.dart';

class LogoWidget extends StatefulWidget {
  final double blocSize;
  final String fileLink;

  LogoWidget({Key? key, required this.blocSize, required this.fileLink})
      : super(key: key);

  @override
  State<LogoWidget> createState() => _LogoWidgetState();
}

class _LogoWidgetState extends State<LogoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scale;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();

    scale = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        child: Image.network(fit: BoxFit.cover, widget.fileLink),
        builder: (context, child) {
          return Transform.scale(
            //alignment: Alignment.bottomCenter,
            origin: Offset.zero,
            scale: scale.value,
            child: Container(
              height: widget.blocSize,
              width: widget.blocSize,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  colors: [Colors.white, Brand.mainBackground],
                  radius: 0.5,
                  stops: [0.0, 0.5],
                ),
                borderRadius: const BorderRadius.all(Radius.circular(200)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 20)
                ],
              ),
              child: child,
            ),
          );
        });
  }
}
