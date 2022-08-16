import 'dart:async';

import 'package:authentication/widget/animations/delayed.animation.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'config/app.theme.dart';
import 'widget/animations/animate.dart';
import 'widget/animations/getstarted/button.size.animation.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key, required this.slideTo, required this.theme, required this.locale, required this.locales, required this.setLang, required this.tr }) : super(key: key);
  final ThemeData theme;
  final Locale locale;
  final List<Locale> locales;
  final Function(Slide) slideTo;
  final void Function(Locale?) setLang;
  final String Function(String) tr;

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  int delayedAmount = 500;
  late StreamController<Animate> buttonController ;

  @override
  void initState() {
    super.initState(); 
  }

  @override
  Widget build(BuildContext context) {
    buttonController = StreamController<Animate>.broadcast();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: <Widget>[

            SizedBox(height: MediaQuery.of(context).size.height * 1 / 5 + 40),
            
            DelayedAnimation(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Text(widget.tr("lapis"), style: widget.theme.textTheme.headline2),
                ),
              ),
              delay: delayedAmount + 300,
            ),

            DelayedAnimation(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Text(
                    widget.tr("get_started_desc"),
                    style: widget.theme.textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              delay: delayedAmount + 600,
            ),
 
             
            Padding(
              padding: const EdgeInsets.symmetric(vertical:10.0),
              child: DropdownButton<Locale>(
                value: widget.locale,

                icon: Padding(
                  padding: const EdgeInsets.fromLTRB(3.0, 0, 0, 0),
                  child: Icon(Icons.arrow_downward, color: widget.theme.dividerColor,),
                ),
                underline: const SizedBox(height:0),
                elevation: 16,
                items: widget.locales.map<DropdownMenuItem<Locale>>((Locale loc) {
                            return DropdownMenuItem<Locale>( value: loc, child: Text(widget.tr(loc.languageCode)) );
                          }).toList(),
                onChanged: (Locale? newValue) {
                  widget.setLang(newValue);
                },
              ),
            ),

          ],
        ),
 
 
        Column(
          children: [

            Center(
              child: ButtonSizeAnimation(
                delay: delayedAmount + 1500,
                milli: 1000,
                controller: buttonController,
                begin: 0,
                end: 1,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: (widget.theme.primaryColor),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 12),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 3 / 4, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: ()=>{widget.slideTo(Slide.signup)},
                    child: Text(
                      widget.tr("get_started"),
                      style: const TextStyle( fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
                    )),
              ),
            ),

            const SizedBox(height: 16),
            
            DelayedAnimation(
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("---------------------- " + widget.tr("or") + " -------------------------",
                    style: TextStyle(color: widget.theme.dividerColor.withOpacity(0.6)) )
                ],
              )),
              delay: delayedAmount + 1200,
            ),

            DelayedAnimation(
              child: TextButton(
                  onPressed: () => {widget.slideTo(Slide.login)},
                  child: Text(widget.tr("already_have_account"),
                      style: widget.theme.textTheme.subtitle1)),
              delay: delayedAmount + 900,
            ),

            const SizedBox(height: 14),

          ],
        )


      ],
    );
  }
}
