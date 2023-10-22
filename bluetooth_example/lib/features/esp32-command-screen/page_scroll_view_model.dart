import 'package:flutter/cupertino.dart';

class PageScrollViewModel extends ChangeNotifier{
  late int currentIndex;
  late double scrollOffset;

  void init(){
    currentIndex = 0;
    scrollOffset = 0.0;
    notifyListeners();
  }

  void scrollHorizontal({double? scroll}){
    scrollOffset = scroll??0.0;
    notifyListeners();
  }

  void setCurrentIndex({required int index}){
    currentIndex = index;
    notifyListeners();
  }
}