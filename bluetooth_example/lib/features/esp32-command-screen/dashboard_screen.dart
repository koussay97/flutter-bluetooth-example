import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/features/esp32-command-screen/page_scroll_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageScroll =
        context.select<PageScrollViewModel, double>((val) => val.scrollOffset);
    //print('scroll from provider ::: $pageScroll');
    final device =
        ModalRoute.of(context)?.settings.arguments as BluetoothDevice;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Brand.darkTeal,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            'welcome to ${device.name} dashboards',
            maxLines: 2,
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: Brand.h3Size(context),
                fontWeight: Brand.h3Weight),
          )),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dy < 0) {
                print('should scroll downwards ');
              }
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              clipBehavior: Clip.none,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: deviceWidth,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            child: Container(
                              //color: Colors.grey,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 400,
                                    width: deviceWidth,
                                    //color: Colors.redAccent,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment:
                                            Alignment((pageScroll) * 0.0005, 0),
                                        fit: BoxFit.cover,
                                        opacity: 0.9,
                                        image: const NetworkImage(
                                            'https://d3mxt5v3yxgcsr.cloudfront.net/courses/10688/course_10688_image.jpg'),
                                      ),
                                      //color: Colors.blue
                                    ),
                                    child: Container(
                                      height: 200,
                                      decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                            Colors.white,
                                            Colors.transparent
                                          ],
                                              stops: [
                                            0,
                                            0.6
                                          ])),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: deviceWidth * 0.06,
                            left: Brand.appPadding(context: context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Charts',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: Brand.h2Size(context),
                                      fontWeight: Brand.h1Weight),
                                ),
                                SizedBox(height: deviceWidth * 0.01),
                                Text(
                                  'Swipe or click to expand the chart panel',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: Brand.h4Size(context),
                                      fontWeight: Brand.h4Weight),
                                ),
                              ],
                            )),
                        Positioned(
                          right: 0,
                          top: deviceWidth * 0.25,
                          child: DataStream(
                            listHeight: deviceWidth * 0.95,
                            listWidth: deviceWidth,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Brand.appPadding(context: context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: deviceWidth * 0.2,
                        ),
                        Text(
                          'Real Time Data',
                          style: GoogleFonts.poppins(
                              color: Brand.blackGrey,
                              fontSize: Brand.h2Size(context),
                              fontWeight: Brand.h1Weight),
                        ),
                        SizedBox(height: deviceWidth * 0.02),
                        RealTimeDataCard(
                          width: deviceWidth,
                          height: deviceWidth * 0.2,
                          title: 'Temperature',
                          chartTitle: '22°C',
                          chartValue: 66,
                          leadingIcon: FontAwesome.temperature_high,
                        ),
                        SizedBox(
                          height: deviceWidth * 0.05,
                        ),
                        RealTimeDataCard(
                          width: deviceWidth,
                          height: deviceWidth * 0.2,
                          title: 'Humidity',
                          chartTitle: '20%',
                          chartValue: 20.0,
                          leadingIcon: FontAwesome.cloud_showers_water,
                        ),
                        SizedBox(
                          height: deviceWidth * 0.05,
                        ),
                        RealTimeDataCard(
                          width: deviceWidth,
                          height: deviceWidth * 0.2,
                          title: 'PH,hPa',
                          chartTitle: '1100 hpa',
                          chartValue: 85,
                          leadingIcon: FontAwesome.face_tired,
                        ),
                        SizedBox(
                          height: deviceWidth * 0.2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              width: deviceWidth,
              child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        constraints: BoxConstraints(
                            minWidth: deviceWidth,
                            minHeight: deviceWidth * 0.1,
                            maxWidth: deviceWidth,
                            maxHeight: deviceWidth),
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.all(
                                Brand.appPadding(context: context)),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.grey,
                                  height: 20,
                                  width: deviceWidth,
                                )
                              ],
                            ),
                          );
                        });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Brand.darkTeal,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(
                                Brand.appPadding(context: context) * 4),
                            topLeft: Radius.circular(
                                Brand.appPadding(context: context) * 4))),
                    height: deviceWidth * 0.1,
                    width: deviceWidth,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.arrow_circle_up_outlined,
                            color: Colors.white,
                          ),
                          Text(
                            'Send Data',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: Brand.h4Size(context),
                                fontWeight: Brand.h4Weight),
                          )
                        ],
                      ),
                      /* AnimatedIcon(
                     progress: Tween<double>(begin: 0.0,end :1.0).animate(),
                     icon: AnimatedIcons.arrow_menu,
                   ),
                  */
                    ),
                  ))),
        ],
      ),
    );
  }
}

class RealTimeDataCard extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final String chartTitle;
  final double chartValue;
  final double height;
  final double width;

  const RealTimeDataCard({
    Key? key,
    required this.title,
    required this.chartTitle,
    required this.chartValue,
    required this.leadingIcon,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: Brand.paleGreyBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
                Brand.appPadding(context: context) * 0.5)),
        padding: EdgeInsets.symmetric(
            horizontal: Brand.appPadding(context: context) * 0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              leadingIcon,
              size: Brand.textSize(context) * 2,
              color: chartValue < 85
                  ? chartValue > 65
                      ? Colors.orangeAccent
                      : Brand.darkTeal
                  : Colors.redAccent,
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                  color: Brand.blackGrey,
                  fontSize: Brand.h3Size(context),
                  fontWeight: Brand.h3Weight),
            ),
            SizedBox(
              height: height,
              width: height,
              child: PieChart(
                PieChartData(
                    startDegreeOffset: -90.0,
                    borderData: FlBorderData(
                        border: const Border.symmetric(
                            horizontal: BorderSide(
                          color: Colors.white,
                          width: 1,
                        )),
                        show: true),
                    centerSpaceColor: Brand.brightGreyBlue,
                    pieTouchData: PieTouchData(
                        enabled: true,
                        longPressDuration: const Duration(milliseconds: 200)),
                    sections: [
                      PieChartSectionData(
                          color: chartValue < 85
                              ? chartValue > 65
                                  ? Colors.orangeAccent
                                  : Brand.darkGreyBlue
                              : Colors.redAccent,
                          value: chartValue,
                          title: chartTitle,
                          titleStyle: TextStyle(
                              color: Colors.white,
                              fontSize: Brand.textSize(context) * 0.8)),
                      PieChartSectionData(
                          showTitle: false,
                          color: Brand.darkTeal,
                          value: 100 - chartValue),
                    ]),
              ),
            ),
          ],
        ));
  }
}

class DataStream extends StatefulWidget {
  final double listHeight;
  final double listWidth;

  const DataStream({
    Key? key,
    required this.listHeight,
    required this.listWidth,
  }) : super(key: key);

  @override
  State<DataStream> createState() => _DataStreamState();
}

class _DataStreamState extends State<DataStream> {
  late final PageController pageController;
  late double _currPageValue;

  @override
  void initState() {
    _currPageValue = 0.0;
    pageController = PageController(initialPage: 0, viewportFraction: 0.7)
      ..addListener(pageControllerListener);
    super.initState();
  }

  void pageControllerListener() {
    setState(() {
      _currPageValue = pageController.page ?? 0.0;
      print(' page scroll from ui ::: $_currPageValue');
      print(' page scroll from ui ::: ${pageController.position.pixels}');
    });
    context
        .read<PageScrollViewModel>()
        .scrollHorizontal(scroll: pageController.position.pixels);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.removeListener(pageControllerListener);
    pageController.dispose();
  }

  _buildPageItem(int index) {
    if (index == _currPageValue.floor()) {
      debugPrint('page swiped from $index');
      return PageSwipeFromElement(
          scaleFactor: 0.8,
          height: widget.listHeight,
          index: index,
          pageScroll: _currPageValue);
    } else if (index == _currPageValue.floor() + 1) {
      debugPrint('page swiped to $index');
      return PageSwipeToElement(
          height: widget.listHeight,
          scaleFactor: 0.8,
          pageScroll: _currPageValue,
          index: index);
    } else if (index == _currPageValue.floor() - 1) {
      debugPrint('page off screen $index');
      return PageOffScreen(
          height: widget.listHeight,
          scaleFactor: 0.8,
          pageScroll: _currPageValue,
          index: index);
    }
    return PageDefaultElement(
      height: widget.listHeight,
      scaleFactor: 0.8,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.listHeight,
        width: widget.listWidth,
        child: PageView.builder(
          controller: pageController,
          physics: const BouncingScrollPhysics(),
          itemCount: 5,
          padEnds: true,
          itemBuilder: (context, position) {
            return Container(
              //width: widget.listWidth,

              //color: Colors.blue.withOpacity(0.3),
              clipBehavior: Clip.none,
              //alignment: Alignment.center,
              padding: EdgeInsets.zero,
              margin: const EdgeInsets.only(right: 1),
              child: Center(child: _buildPageItem(position)),
            );
          },
        ));
  }
}

class PageSwipeFromElement extends StatelessWidget {
  final int index;
  final double scaleFactor;
  final double pageScroll;
  final double height;

  const PageSwipeFromElement(
      {Key? key,
      required this.scaleFactor,
      required this.height,
      required this.index,
      required this.pageScroll})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currScale = 1 - (pageScroll - index) * (1 - scaleFactor);
    var currTrans = height * (1 - currScale) / 2;
    final Matrix4 matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
      ..setTranslationRaw(0, currTrans, -currTrans);

    return Transform(
      alignment: Alignment.center,
      origin: Offset.zero,
      transform: matrix,
      child: const PageContent(expandable: true),
    );
  }
}

class PageSwipeToElement extends StatelessWidget {
  final int index;
  final double scaleFactor;
  final double pageScroll;
  final double height;

  const PageSwipeToElement(
      {Key? key,
      required this.height,
      required this.scaleFactor,
      required this.pageScroll,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currScale = scaleFactor + (pageScroll - index + 1) * (1 - scaleFactor);
    var currTrans = height * (1 - currScale) / 2;
    Matrix4 matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
      ..setTranslationRaw(0, currTrans, 0);
    return Transform(
        alignment: Alignment.center,
        origin: Offset.zero,
        transform: matrix,
        child: const PageContent(
          expandable: false,
        ));
  }
}

class PageOffScreen extends StatelessWidget {
  final int index;
  final double scaleFactor;
  final double pageScroll;
  final double height;

  const PageOffScreen(
      {Key? key,
      required this.height,
      required this.scaleFactor,
      required this.pageScroll,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currScale = 1 - (pageScroll - index) * (1 - scaleFactor);
    var currTrans = height * (1 - currScale) / 2;
    Matrix4 matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
      ..setTranslationRaw(0, currTrans, 0);
    return Transform(
        alignment: Alignment.center,
        origin: Offset.zero,
        transform: matrix,
        child: const PageContent(
          expandable: false,
        ));
  }
}

class PageDefaultElement extends StatelessWidget {
  final double scaleFactor;
  final double height;

  const PageDefaultElement({
    Key? key,
    required this.height,
    required this.scaleFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currScale = 0.8;
    Matrix4 matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
      ..setTranslationRaw(0, height * (1 - scaleFactor) / 2, 0);
    return Transform(
        alignment: Alignment.center,
        origin: Offset.zero,
        transform: matrix,
        child: const PageContent(
          expandable: false,
        ));
  }
}

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
                    child: Row(
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
