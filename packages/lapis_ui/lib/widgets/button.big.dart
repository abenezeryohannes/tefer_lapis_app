import 'package:flutter/material.dart';

class ButtonBig extends StatelessWidget {
  final ThemeData theme;
  final Widget child;
  final Function onClick;
  final String width;

  const ButtonBig(
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
          minimumSize: width=="min"? const Size(0, 20): Size(MediaQuery.of(context).size.width * 3 / 4, 40),
          shape: const StadiumBorder()
        ),
        onPressed: () => { onClick() },
        child: child
    );
  }
}
