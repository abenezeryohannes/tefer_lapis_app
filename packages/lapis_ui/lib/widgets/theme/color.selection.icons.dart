import 'dart:developer';

import 'package:flutter/material.dart';
import 'color.selection.icon.dart';

class ColorSelectionIcons extends StatefulWidget {
  const ColorSelectionIcons({ Key? key, required this.themes, required this.onTapDown }) : super(key: key);

  @override
  _ColorSelectionIconsState createState() => _ColorSelectionIconsState();

  final List<ThemeData> themes;
  final void Function(ThemeData, TapDownDetails) onTapDown;
}

class _ColorSelectionIconsState extends State<ColorSelectionIcons> {
  
  @override
  void initState() { 
    super.initState();

    _pageController.addListener(() {
      setState(() {
        _scrollAmount = _pageController.page!;
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController, 
      itemCount: widget.themes.length,
      itemBuilder: (context, index) => _buildPage(index, _scrollAmount, widget.themes[index]),
    );
  }

  Widget _buildPage(int index, double scrollAmount, ThemeData theme){ return Center(child: ColorSelectionIcon(index: index, scrollAmount: scrollAmount, themeData: theme, onTapDown: widget.onTapDown,)); }


  double _scrollAmount = 0.0;
  final PageController _pageController = PageController(viewportFraction: 1/3);

}