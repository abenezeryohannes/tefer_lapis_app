import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:authentication/auth.dart';
import 'package:authentication/widget/background.dart';
import 'package:dio/dio.dart';
import 'package:domain/controllers/user.request.dart';
import 'package:domain/models/current.user.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:domain/shared_preference/user.sp.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lapis_ui/intro/introduction.dart';
import 'package:lapis_ui/pages/school.page.dart';
import 'package:lapis_ui/pages/profile.page.dart';
import 'package:lapis_ui/theme.change.dart';
import 'package:myapp/config/themes/app.theme.dart';
import 'package:myapp/domain/shared_preference/setting.sp.dart';
import 'package:myapp/driver/nav.driver.page.dart';
import 'package:myapp/pages/navbar.dart';
import 'package:provider/provider.dart';
import 'package:util/Utility.dart';
import 'package:walkthrough/walkthrough.dart';

import '../config/config.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}
 
class _MainPageState extends State<MainPage> {

  String? error;
  late BuildContext _context;
  // late UserModel userModel;
  late AppTheme appTheme;
  final BackgroundController _backgroundController = BackgroundController();

  Future<UserModel> onSetLang(Locale? val, userModel) async{
    if(val==null)return userModel;
    if(!_context.supportedLocales.contains(val))return userModel;
    _context.setLocale(val);
    SettingSP settingSP = SettingSP();
    await settingSP.loadPreference();
    settingSP.saveLocale(val);

    if(userModel.locale != _context.locale.languageCode){
      UserModel newUser = userModel;
      newUser.locale = _context.locale.languageCode;
      saveUser(newUser);
    }
    return userModel;
  }


  onThemeChange(int index) async{
    SettingSP settingSP = SettingSP();
    await settingSP.loadPreference();
    settingSP.saveTheme( Provider.of<AppTheme>(_context, listen: false) );
  }


  Future<UserModel?> onLogin(String user, Function onLoginDoThis, Function onSignupDoThis) async{
    Map<String, dynamic> request = jsonDecode(user);
    bool isLogin = request['isLogin'] as bool;
    try {
      Wrapper wrapper = Wrapper.fresh();
      if (isLogin) {
        wrapper = await UserRequest(UserModel.fresh()).loginUser(request['uid'] as String);
      } else {
        wrapper = await UserRequest(UserModel.fresh()).signupUser(request);
      }
      if(wrapper.success??false){

        UserModel userModel = wrapper.data;

        UserSP userSp = UserSP();
        await userSp.loadPreference();
        if(userModel.id!=null) userSp.saveUser(userModel);

        if(isLogin){ onLoginDoThis();
        }else onSignupDoThis();

        return userModel;
        // return userModel.id!=null ? ( (userModel.newUser??false) ? 2 : 2 ) : -1;
      }else{
        setState(() { error = wrapper.message; });
        return null;
      }

    }on DioError catch(e){
      print("Login error from main: $e");
      setState(() { error = Utility.formatError(e, tr: tr); });
      return null;
    }
  }

  void updateUserForTest() async{
    Wrapper wrapper = Wrapper.fresh();
    wrapper = await UserRequest(UserModel.fresh()).getUser(2);
    UserModel userModel = wrapper.data;
    print("downloaded_user");
    UserSP userSp = UserSP();
    await userSp.loadPreference();
    if(userModel.id!=null) userSp.saveUser(userModel);
    Provider.of<CurrentUserModel>(context, listen: false).User = userModel;
  }


  Future<UserModel> onAuthEnd(BuildContext context) async{
    UserSP userSP = UserSP();
    await userSP.loadPreference();
    UserModel userX = await userSP.getUser();
    userX.newUser = false;
    userSP.saveUser(userX);
    return userX;
    // if(userModel.walkthrough) {

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) =>
      //       Walkthrough(walkThroughItems: Config.walkThroughItems,
      //         tr: tr, theme: appTheme.getThemeData(),
      //         onEnd: onWalkThroughEnd,)),
      //  );

    // }else{
    //   Provider.of<UserModel>(context).copy(userX);
    // }
  }

  Future<UserModel> onWalkThroughEnd(userModel) async{
    setState(() { });
    userModel.walkthrough = false;
    saveUser(userModel);
    return userModel;
    // Provider.of<CurrentUserModel>(_context, listen: true).getUser().walkthrough = false;
  }

  Future<UserModel> onIntroEnd(userModel) async{
    // print("Intro Ended");
    // setState(() {  });
    userModel.introduction = false;
    saveUser(userModel);
    return userModel;
  }

  Future<UserModel> saveUser(UserModel newUser) async{
        UserSP userSp = UserSP();
        await userSp.loadPreference();
        userSp.saveUser(newUser);
        //setState(() {  userModel = newUser;});
        if(Provider.of<AppTheme>(context, listen: false).selectedThemeData.name!=newUser.getTheme()) {
          int index = AppTheme.Fresh().getAppThemeDatas().indexWhere((
              element) => element.name == newUser.getTheme());
          onThemeChange(index);
        }
        if(newUser.locale != _context.locale.languageCode){
          String? locale = newUser.locale;
          if(locale == "en") {
            locale = "en-US";
          } else if(locale == "am") {
            locale = "am-ET";
          }
          if(locale == "en-US"|| locale == "am-ET") {
            newUser = await onSetLang(Locale(locale!), newUser);
          } else {
            newUser = await onSetLang(const Locale("en-US"), newUser);
          }

        }
        return newUser;
        //print("saved User: ${userSp.getUser()}");
  }

  late DateTime dt1;
  late DateTime dt2;
  @override
  void initState() {
    dt1 = DateTime.now();
    dt2 = DateTime.now();
    //updateUserForTest();
    super.initState();
  }

  updateLocation(CurrentUserModel currentUserModel) async{
    if(dt1!=null&&dt1.difference(dt2).inMinutes % 60 < 3){
      dt1 = DateTime.now();
      return;
    }
    Position currentLoc = await _determinePosition();
    //print("current_position: ${currentLoc.latitude} ${currentLoc.longitude}");
    UserSP userSp = UserSP();
    await userSp.loadPreference();
    UserModel user = await userSp.getUser();
    if(user.getLocation().latitude == currentLoc.latitude &&
        user.getLocation().longitude == currentLoc.longitude)return;
    user.getLocation().latitude = currentLoc.latitude;
    user.getLocation().longitude = currentLoc.longitude;
    saveUser(user);
    setState(() { currentUserModel.setUser(user); });
    //print("user_position: ${user.getLocation().latitude} ${user.getLocation().longitude}");
  }


  _test() async{

    UserSP userSp  = UserSP();
    await userSp.loadPreference();

    userSp.getUser().then((value) =>
        print("logged in user: ${value.toString()}")
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
      return  AnnotatedRegion<SystemUiOverlayStyle>(
        value: ThemeChange.getSystemUIOverlay(context),
        child: Scaffold(
            backgroundColor: AdaptiveTheme.of(context).theme.scaffoldBackgroundColor,
            resizeToAvoidBottomInset: false,
            body:  Background(
                  controller: _backgroundController,
                  initialColor: [  AdaptiveTheme.of(context).theme.scaffoldBackgroundColor,
                                   AdaptiveTheme.of(context).theme.backgroundColor ],
                  child:  Consumer<CurrentUserModel>(
                      builder: (context, currentUser, child) {

                        if(currentUser.getUser().id==null){
                          return Auth(
                              theme: AdaptiveTheme.of(context).theme,
                              themes: Provider.of<AppTheme>(context).getThemeDatas(),
                              locale: context.locale,
                              error: error,
                              onClearError: (){setState(() {
                                error = null;
                              });},
                              locales: context.supportedLocales,
                              tr: tr,
                              onEnd: (_context) async{
                                UserModel user = await onAuthEnd(_context);
                                print("on auth end: User: $user");
                                setState(() {
                                  currentUser.setUser(user);
                                  error = null;
                                });
                              },
                              onLogIn: (userVal) async{
                                setState(() {  error = null;  });
                                print("onLogIN $userVal");
                                UserModel? userModel = await onLogin(userVal,
                                        () {
                                      setState(() {
                                        currentUser.introduction = false;
                                        currentUser.walkthrough = false;
                                      });
                                    }, () {
                                      setState(() {
                                        currentUser.introduction = true;
                                        currentUser.walkthrough = true;
                                      });
                                    });

                                print("user: $userModel");
                                if(userModel != null){
                                  if(userModel.id!=null){
                                    if(userModel.newUser??false){
                                      return 2;
                                    }else {
                                      return 2;
                                    }
                                  }else{
                                    return -1;
                                  }
                                }else{
                                  return -1;
                                }
                                // var resp =  userModel.id!=null ? ( (userModel.newUser??false) ? 2 : 2 ) : -1;
                                // return resp;
                              },
                              setLang: (val) async{
                                UserModel user = await onSetLang(val, currentUser.getUser());
                                setState(() {
                                  currentUser.setUser(user);
                                  error = null;
                                });
                              },
                              onThemeChange: (int index) {
                                setState(() {
                                  Provider.of<AppTheme>(_context).setCurrentTheme(index);
                                   appTheme.setCurrentTheme(index);
                                });
                                onThemeChange(index);
                              }
                          );
                        }
                        else if(currentUser.walkthrough??false){
                          return Walkthrough(walkThroughItems: Config.walkThroughItems, tr: tr,
                              onEnd: () async {
                                UserModel user = await onWalkThroughEnd(currentUser.getUser());
                                //print('test ${currentUser.User.toString()}');
                                setState(() {
                                  // Provider.of<CurrentUserModel>(context).setUser(userModel);
                                  currentUser.getUser().walkthrough = false;
                                  currentUser.walkthrough = false;
                                  currentUser.setUser(user);
                                });
                              }, theme: AdaptiveTheme.of(context).theme
                          );
                        }
                        else if(currentUser.introduction??false){
                          return Introduction(
                            theme: AdaptiveTheme.of(context).theme,
                            tr: tr, onEnd: () async{
                                UserModel user = await onIntroEnd(currentUser.getUser());
                                setState(() {
                                  currentUser.introduction = false;
                                  currentUser.getUser().introduction = false;
                                  currentUser.setUser(user);
         //                         Provider.of<CurrentUserModel>(context).setUser(userModel);
                                });
                          }, user: currentUser.getUser(),
                          );
                        }
                        else if(currentUser.getUser().getToken().type=="driver"){
                          return  NavbarDriver(theme: AdaptiveTheme.of(context).theme,
                            user: currentUser.getUser(),
                            locales: context.supportedLocales,
                            tr: tr, themes: Provider.of<AppTheme>(context).getThemeDatas(),
                            onThemeChange: (int index) {
                              setState(() {
                                if(index == 0) {
                                  AdaptiveTheme.of(context).setLight();
                                }else if(index == 1) {
                                  AdaptiveTheme.of(context).setDark();
                                }else{
                                  AdaptiveTheme.of(context).setSystem();
                                }
                              });
                              onThemeChange(index);
                            },
                            saveUser: (user){
                              saveUser(user);
                              // setState(() {
                                // Provider.of<CurrentUserModel>(context).setUser(user);
                                currentUser.setUser(user);

                                if(user.id==null) {
                                  FirebaseAuth.instance.signOut();
                                }
                              // });
                            },);
                        }
                        return  Navbar(
                          theme:  AdaptiveTheme.of(context).theme,
                          user: currentUser.getUser(), tr: tr, saveUser: (user){
                            saveUser(user);
                            setState(() {
                              // Provider.of<CurrentUserModel>(context, listen: false).setUser(user);
                              currentUser.setUser(user);
                            });
                            if(user.id==null) {
                              FirebaseAuth.instance.signOut();
                            }
                          },
                          themes: Provider.of<AppTheme>(context).getThemeDatas(),
                          onThemeChange: (int index) {
                            setState(() {
                              if(index == 0) {
                                  AdaptiveTheme.of(context).setLight();
                              }else if(index == 1) {
                                  AdaptiveTheme.of(context).setDark();
                              }else{
                                  AdaptiveTheme.of(context).setSystem();
                              }
                            });
                          },
                        );
                      }
                  )
                )
            ),
      );
  }




  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }


  
}