import 'package:flutter/material.dart';

import 'ripple.widget.dart';

class Background extends StatefulWidget {
  const Background({ Key? key, required this.initialColor, required this.child, required this.controller }) : super(key: key);



  final BackgroundController controller;
  final List<Color> initialColor;
  final Widget child;
 
  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(update);

  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
              gradient: _initialGradient()
              ), 
        ),

        _buildRipples(),
        widget.child
      ],
    );
  }

  Widget _buildRipples(){
    return Stack(children: widget.controller.widgets,);
  }

  LinearGradient _initialGradient(){
    return LinearGradient(
      colors: widget.initialColor,
      stops: const <double>[0.0, 0.7],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,

    );

  }

  void update(){
    setState(() {
      
    });
  }

  @override
  void dispose(){
    widget.controller.removeListener(update);
    super.dispose();
  }

 
}
  

class BackgroundController extends ChangeNotifier {
  void doPulse(final List<Color> color, final Offset from) {
    void onEndCallback(final Widget widget) {
      if(widgets.last == widget)
        return;
      
      widgets.remove(widget);
    }

    final Ripple ripple = Ripple(color: color, center: from, onEnd: onEndCallback);
    widgets.add(ripple);

    notifyListeners();
  }
  

  List<Widget> widgets = <Widget>[];
}