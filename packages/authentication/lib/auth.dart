import 'dart:async';

import 'package:authentication/confirm.dart';
import 'package:authentication/domain/firebase.auth.dart';
import 'package:authentication/get.started.dart';
import 'package:authentication/login.dart';
import 'package:authentication/select.theme.dart';
import 'package:authentication/signup.dart';
import 'package:authentication/widget/animations/animate.dart';
import 'package:authentication/widget/animations/kid.position.animation.dart';
import 'package:authentication/widget/animations/kid.size.animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'widget/animations/back.button.animation.dart';
import 'widget/background.dart';
import 'package:rive/rive.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key, required this.themes, required this.theme, 
              required this.onThemeChange, required this.error,
              required this.locale, required this.locales, 
              required this.setLang, required this.tr,
              required this.onLogIn, required this.onEnd,
              required this.onClearError
            }) : super(key: key);
  final ThemeData theme;
  final List<ThemeData> themes;
  final String? error;
  final Locale locale;
  final List<Locale> locales;
  final Function(Locale?) setLang;
  final Function(int) onThemeChange;
  final Function() onClearError;
  final String Function(String) tr;
  final Function(BuildContext) onEnd;
  final Future<int> Function(String) onLogIn;

  @override
  _AuthState createState() => _AuthState();

  static Future<void> INITIALIZEFIREBASE() async{
    await Firebase.initializeApp(
      name: 'lapis-1aed6',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
enum Slide { landing, signup, login, confirm, chooseTheme, end}

class _AuthState extends State<Auth> with TickerProviderStateMixin {
  final BackgroundController _backgroundController = BackgroundController();
  late BuildContext _context;
  PageController controller = PageController(initialPage: 0);

  Slide _currentSlide = Slide.landing;
  int delayedAmount = 500;

  StreamController<Animate> backButtonController =
      StreamController<Animate>.broadcast();
  StreamController<Animate> kidSizeController =
      StreamController<Animate>.broadcast();
  StreamController<Animate> kidPositionController =
      StreamController<Animate>.broadcast();

  void onBackPressed() {
    widget.onClearError();
    switch(_currentSlide){
      case Slide.signup:
        widget.onClearError();
        slideTo(Slide.landing);
        break;
      case Slide.login:
        widget.onClearError();
        slideTo(Slide.landing);
        break;
      case Slide.confirm:
        widget.onClearError();
        if(FireBaseAuth.isLogin){
          slideTo(Slide.login);
        }else{
          slideTo(Slide.signup);
        }
        // controller.previousPage( duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
        // _currentSlide = Slide.values[_currentSlide.index-1];
        break;
      default: return;
    }
  }

  void slideTo(Slide slide){
    widget.onClearError();
    if(mounted) {
      if (slide == Slide.end) {
        widget.onEnd(_context);
        return;
      }
      else if (slide == Slide.landing) {
        _growKid();
      } else if (_currentSlide == Slide.landing) {
        _shrinkKid();
      }
      _currentSlide = slide;
      controller.animateToPage(slide.index,
          duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    }
  }

  bool sizeDelayed = false;

  void _growKid() {
    //print("grow kid");
    sizeDelayed = false;
    if(mounted) {
      setState(() {
        backButtonController.sink.add(Animate.reverse);
        kidSizeController.sink.add(Animate.forward);
        kidPositionController.sink.add(Animate.forward);
      });
    }
  }

  void _shrinkKid() {
    //print("shrink kid");
    sizeDelayed = true;
    if(mounted) {
      setState(() {
        backButtonController.sink.add(Animate.forward);
        kidSizeController.sink.add(Animate.reverse);
        kidPositionController.sink.add(Animate.reverse);
      });
    }
  }

  Future<bool> onLogInExtended(User user, String? name) async{
    int status = await widget.onLogIn(('{"isLogin":${FireBaseAuth.isLogin},"full_name":"'
        '${user.displayName??name}","email":"${user.email}","phoneNumber":"${user.phoneNumber}","uid":"${user.uid}"}'));
    if(status==2) { slideTo(Slide.end);//was slide to theme
    }else if(status == 0) { slideTo(Slide.signup);
    }else if (status ==1){ slideTo(Slide.end); }
     else if (status == -1) { return false; }
    FireBaseAuth.FULLNAME = "";
    return true;
  }



  @override
  void initState() {

    Timer(const Duration(milliseconds: 1000), () {
      if (mounted) { _growKid(); }
    });

    super.initState();
  }

  @override
  void dispose() {
    backButtonController.close();
    kidSizeController.close();
    kidPositionController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return WillPopScope(
      onWillPop: () async {
        if (_currentSlide.index > 0 ){ //&& _currentSlide != Slide.chooseTheme) {
          onBackPressed();
        } else { return true; }
        return false;
      },
      child: Scaffold(
          backgroundColor:  widget.theme.scaffoldBackgroundColor,
          resizeToAvoidBottomInset: false,
          body: Background(
            controller: _backgroundController,
            initialColor: [widget.theme.backgroundColor, widget.theme.scaffoldBackgroundColor],
            child: Stack(children: [

              PageView(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    GetStarted(slideTo: slideTo, theme: widget.theme, locale: widget.locale, locales:widget.locales, setLang: widget.setLang, tr: widget.tr),
                    SignUp(onSignUp: onLogInExtended, slideTo: slideTo, theme: widget.theme, error: widget.error, locale: widget.locale, locales:widget.locales, setLang: widget.setLang, tr: widget.tr),
                    LogIn(onLogIn: onLogInExtended, slideTo: slideTo, theme: widget.theme, error: widget.error, locale: widget.locale, locales:widget.locales, setLang: widget.setLang, tr: widget.tr),
                    Confirm(onConfirm: onLogInExtended, theme: widget.theme, locale: widget.locale, error: widget.error, locales:widget.locales, setLang: widget.setLang, tr: widget.tr),
                    SelectTheme(slideTo: slideTo, themes: widget.themes, tr: widget.tr, onChange: (index) => widget.onThemeChange(index), theme: widget.theme),
                  ]
              ),


              Container(
                margin: const EdgeInsets.fromLTRB(0, 34, 0, 0),
                height: MediaQuery.of(context).size.height * 1 / 5,
                alignment: Alignment.bottomCenter,
                child: KidPositionAnimation(
                  delay: sizeDelayed ? 400 : 0,
                  milli: 400,
                  controller: kidPositionController,
                  begin: const Offset(0, -0.4),
                  end: Offset.zero,
                  child: KidSizeAnimation(
                    delay: sizeDelayed ? 400 : 0,
                    milli: 400,
                    controller: kidPositionController,
                    begin: 0.7,
                    end: 1,
                    child:  Hero(
                      tag: 'kid',
                      child: Material(
                          elevation: 8.0,
                          shadowColor: widget.theme.cardColor,
                          color: Colors.transparent,
                          shape: const CircleBorder(),
                          child: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: RiveAnimation.asset('assets/anim/lapis.riv',
                              alignment:Alignment.center,
                              fit:BoxFit.contain,
                              stateMachines: ['State Machine Idle'],
                              artboard: 'New Artboard',
                              animations: ['idle'],
                            ),
                            radius: 62,
                          )),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 34, 0, 0),
                child: BackButtonAnimation(
                  delay: 0,
                  milli: 600,
                  controller: backButtonController,
                  begin: const Offset(-1.5, 0),
                  end: Offset.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Hero(
                      tag:'cancel',
                      child: IconButton(
                        onPressed: () => {onBackPressed()},
                        color: widget.theme.colorScheme.onBackground,
                        icon: Icon(Icons.arrow_back, size: 28, color: widget.theme.colorScheme.onBackground,),
                      ),
                    ),
                  ),
                ),
              ),

            ]),
          )),
    );
  }
}
