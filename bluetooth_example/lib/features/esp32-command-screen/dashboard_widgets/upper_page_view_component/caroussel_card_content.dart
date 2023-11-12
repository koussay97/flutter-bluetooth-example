import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PageContent extends StatefulWidget {
  final bool expandable;

  const PageContent({Key? key, required this.expandable}) : super(key: key);

  @override
  State<PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<PageContent>
    with SingleTickerProviderStateMixin {
  late bool cardOpened;
  static Duration duration = const Duration(milliseconds: 400);

  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    cardOpened = false;
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation = Tween<double>(begin: 0.0, end: 1.1)
        .animate(CurvedAnimation(parent: controller, curve: Curves.decelerate));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onPanUpdate: (details) {
        if (widget.expandable) {
          if (details.delta.dy < 0) {
            setState(() {
              cardOpened = false;
            });
            controller.reverse();
          } else {
            setState(() {
              cardOpened = true;
            });
            controller.forward();
          }
        }
      },
      onTap: () {
        if (widget.expandable) {
          setState(() {
            cardOpened = !cardOpened;
          });
          if (cardOpened) {
            controller.forward();
          } else {
            controller.reverse();
          }
        }
      },
      child: Container(
        width: deviceWidth * 0.6,
        //color: Colors.blue.withOpacity(0.3),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: duration,
              top: cardOpened ? deviceWidth * 0.06 : 0,
              width: deviceWidth * 0.5,
              height: deviceWidth * 0.8,
              child: AnimatedBuilder(
                  animation: scaleAnimation,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 5),
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          Brand.appPadding(context: context)),
                      color: Brand.darkTeal,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: scaleAnimation.value, //cardOpened?1.1:0.5,
                      origin: Offset.zero,
                      child: child!,
                    );
                  }),
            ),
            Positioned(
              width: deviceWidth * 0.5,
              height: deviceWidth * 0.8,
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(Brand.appPadding(context: context)),
                  color: Colors.white,
                ),
                child: ScatterChart(ScatterChartData(
                    maxX: 5,
                    maxY: 5,
                    minX: 0,
                    minY: 0,
                    scatterSpots: [
                      ScatterSpot(1, 1),
                      ScatterSpot(1.5, 2),
                      ScatterSpot(2, 3),
                      ScatterSpot(3.5, 1)
                    ])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
