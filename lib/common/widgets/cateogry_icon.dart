
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@immutable
class CategoryIcon extends StatelessWidget {

  final dynamic bgColor;
  final IconData iconData;

  CategoryIcon({this.bgColor, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size:30,
          // color: Colors.white
      )
    );
  }
}
