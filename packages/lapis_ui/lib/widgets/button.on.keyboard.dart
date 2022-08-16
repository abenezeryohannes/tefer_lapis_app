import 'package:flutter/material.dart';

class ButtonOnKeyboard extends StatelessWidget {
  final ThemeData theme;
  final Widget child;
  final Function onClick;
  final String width;

  const ButtonOnKeyboard(
      {Key? key,
      required this.theme, this.width = "max",
      required this.child,
      required this.onClick
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: theme.colorScheme.secondary,
          minimumSize: width=="min"? const Size(30, 30): const Size(40, 40),
          shape: const CircleBorder()
        ),
        onPressed: () => { onClick() },
        child: child
    );
  }
}
