import 'dart:async';

import 'package:flutter/material.dart';

import '../animate.dart';

class ButtonSizeAnimation extends StatefulWidget {
  ButtonSizeAnimation(
      {Key? key,
      required this.child,
      required this.delay,
      required this.milli,
      required this.begin,
      required this.end,
      required this.controller})
      : super(key: key);

  final Widget child;
  final int delay;
  final int milli;
  final double begin;
  final double end;
  final StreamController<Animate> controller;

  @override
  _ButtonSizeAnimationState createState() => _ButtonSizeAnimationState();
}

class _ButtonSizeAnimationState extends State<ButtonSizeAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late StreamSubscription _controllerSubscriber;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.milli),
      vsync: this,
    );

    _controllerSubscriber =
        widget.controller.stream.asBroadcastStream().listen((event) {
      if (event == Animate.forward) {
        print('event forward ' + event.toString());
        _controller.forward();
      } else if (event == Animate.reverse) {
        print('event reverse ' + event.toString());
        _controller.reverse();
      }
    });

    Timer(Duration(milliseconds: widget.delay), () {
        if (mounted) {
          _controller.forward();
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controllerSubscriber.cancel();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: ScaleTransition(
        scale: Tween<double>(
          begin: widget.begin,
          end: widget.end,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.elasticOut,
        )),
        child: widget.child,
      ),
    );
  }
}
