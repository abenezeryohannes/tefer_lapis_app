import 'package:flutter/material.dart';

class BottomSheetMenu extends StatefulWidget {

  const BottomSheetMenu({Key? key, required this.child, required this.theme}) : super(key: key);
  final Widget child;
  final ThemeData theme;
  @override
  State<BottomSheetMenu> createState() => _BottomSheetMenuState();

}

class _BottomSheetMenuState extends State<BottomSheetMenu> {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        elevation: 10,
        backgroundColor: widget.theme.cardColor,
        onClosing: () {
          // Do something
        },
        builder: (BuildContext ctx) => Container(
          width: double.infinity,
          height: 250,
          alignment: Alignment.center,
          child: widget.child
        ));

  }
}
