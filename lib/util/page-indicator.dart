import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int pageCount;
  final double height;
  final double gutter;
  PageIndicator({this.currentIndex, this.pageCount, this.height, this.gutter});

  _indicator(bool isActive) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: gutter ?? 4.0),
        child: Container(
          height: height ?? 7.0,
          decoration: BoxDecoration(
              color: isActive ? Color(0xFF1B9CFC) : Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: new Border.all(color: Color(0xFF1B9CFC))),
        ),
      ),
    );
  }

  _buildPageIndicators() {
    List<Widget> indicatorList = [];
    for (int i = 0; i < pageCount; i++) {
      indicatorList
          .add(i <= currentIndex ? _indicator(true) : _indicator(false));
    }
    return indicatorList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildPageIndicators(),
    );
  }
}
