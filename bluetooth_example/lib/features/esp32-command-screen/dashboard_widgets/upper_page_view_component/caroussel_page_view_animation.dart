import 'package:bluetooth_example/features/esp32-command-screen/dashboard_widgets/dashboard_widgets.dart';
import 'package:bluetooth_example/features/esp32-command-screen/page_scroll_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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