import 'dart:async';

import 'package:flutter/material.dart';

import 'animate.dart';

class KidSizeAnimation extends StatefulWidget {
  KidSizeAnimation(
      {Key? key, required this.child, required this.delay, required this.milli, required this.begin, required this.end, required this.controller})
      : super(key: key);

  final Widget child;
  final int delay;
  final int milli;
  final double begin;
  final double end;
  final StreamController<Animate> controller;

  @override
  _KidSizeAnimationState createState() => _KidSizeAnimationState();
}
 

class _KidSizeAnimationState extends State<KidSizeAnimation>
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

    _controllerSubscriber = widget.controller.stream.asBroadcastStream().listen((event) {
      if (event == Animate.forward) {
        //print('event forward ' + event.toString());
        _controller.forward();
      } else if(event == Animate.reverse){
        //print('event reverse ' + event.toString());
        _controller.reverse();
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
    return ScaleTransition(
      scale: Tween<double>(
        begin: widget.begin,
        end: widget.end,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      )), 
      child: widget.child,
    );
  }
}
