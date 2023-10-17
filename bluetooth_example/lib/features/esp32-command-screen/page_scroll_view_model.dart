import 'package:flutter/cupertino.dart';

class PageScrollViewModel extends ChangeNotifier{
  late double scrollOffset;
  void init(){
    scrollOffset =0.0;
    notifyListeners();
  }
  void scrollHorizontal({double? scroll}){
    scrollOffset = scroll??0.0;
    notifyListeners();
  }

}