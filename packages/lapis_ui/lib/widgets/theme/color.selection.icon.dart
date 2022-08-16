import 'dart:ui';

import 'package:flutter/material.dart';


class ColorSelectionIcon extends StatefulWidget {
  const ColorSelectionIcon({ Key? key, required this.index, required this.themeData, required this.scrollAmount, required this.onTapDown}) : super(key: key);

  @override
  _ColorSelectionIconState createState() => _ColorSelectionIconState();

  final int index;
  final double scrollAmount;
  final ThemeData themeData;
  final void Function(ThemeData, TapDownDetails) onTapDown;

}

class _ColorSelectionIconState extends State<ColorSelectionIcon> {
  @override
  Widget build(BuildContext context) {
    
    
    final double clampedDifference = (widget.scrollAmount - widget.index ).clamp(-1, 1);

    final Offset offset = Offset(0.0, 128.0 * clampedDifference);

    final double scale = lerpDouble(1.0, 0.8, clampedDifference.abs())!;


    return Transform.translate(
      offset: offset,
      child: Transform.scale(
        scale: scale,
        child: GestureDetector(
          onTapDown: (TapDownDetails){
              widget.onTapDown(widget.themeData, TapDownDetails);
              //print("clicked button");
          },
          child: _buildIcon())
      )
    );
  }

  Widget _buildIcon(){

    const double diameter = 100.0;

    return Container(
          width: diameter, height: diameter, 
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [widget.themeData.scaffoldBackgroundColor, widget.themeData.backgroundColor], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            border: Border.all(color: Colors.white, width: 4),
            borderRadius: BorderRadius.circular(3000.0)
          )
        );
  }
}