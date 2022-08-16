import 'package:flutter/material.dart';

class ButtonOutlineBig extends StatelessWidget {
  final ThemeData theme;
  final Widget child;
  final Function onClick;
  final String width;

  const ButtonOutlineBig(
      { Key? key,
        required this.theme,
        required this.child,
        this.width = "max",
        required this.onClick })
        : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: width=="min"? const Size(0, 20): Size(MediaQuery.of(context).size.width * 3 / 4, 40),
          shape: const StadiumBorder(),
          side: BorderSide(width: 1, color: theme.colorScheme.secondary)
        ),
        onPressed: () => { onClick() },
        child: child
    );
  }
}
