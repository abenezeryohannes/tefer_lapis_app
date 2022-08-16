 
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:domain/controllers/user.request.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:util/Stack.dart' as MyStack;
import 'package:flutter/services.dart';
import 'package:myapp/config/themes/app.theme.dart';  
import 'package:provider/provider.dart';

import 'donations.page.dart';
import 'home.page.dart';
import 'search.page.dart';
import 'subscription.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key, required this.saveUser, required this.onThemeChange,
    required this.themes, required this.user, required this.theme, required this.tr})
      : super(key: key);

  final UserModel user;
  final ThemeData theme;
  final List<ThemeData> themes;
  final String Function(String, {List<String> args}) tr;
  final void Function(UserModel newUser) saveUser;
  final void Function(int index) onThemeChange;

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
   
  int _currentIndex = 0;
  late PageController _pageController;
  MyStack.Stack<int> stack = MyStack.Stack<int>();

  @override
  void initState() { super.initState();
    _pageController = PageController();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    ).then((NotificationSettings value){ print("FCM PERMISSION : $value"); });

    FirebaseMessaging.instance.getToken().then((value) {
      print("FCM: $value");
      String? device_token = value;
      if(device_token!=widget.user.getToken().device_token) {
        UserRequest(widget.user).updateDeviceToken(device_token).then((Wrapper value){
          print("editUserResponse ${value.data}");
        });
      }
    });
  }


  @override
  void dispose() { _pageController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(stack.isNotEmpty){
          setState(() => _currentIndex = stack.top);
          _pageController.jumpToPage(stack.top);
          stack.pop();
          return Future.value( false );
        }else{ return Future.value( true ); }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: widget.theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) { setState(() => _currentIndex = index); },
                  children: <Widget> [
                      HomePage( themeDatas: widget.themes,
                        saveUser: widget.saveUser, theme: widget.theme, tr: widget.tr, user: widget.user,
                        onThemeChange: (index) { widget.onThemeChange(index); },),
                      SearchPage(saveUser: widget.saveUser, theme: widget.theme, tr: widget.tr, user: widget.user,),
                      SubscriptionPage(saveUser: widget.saveUser, theme: widget.theme, tr: widget.tr, user: widget.user,),
                      DonationsPage(saveUser: widget.saveUser, theme: widget.theme, tr: widget.tr, user: widget.user,),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: widget.theme.scaffoldBackgroundColor,
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            if(stack.isEmpty) {
              stack.push(_currentIndex);
            } else if(stack.top!=_currentIndex) {
              stack.push(_currentIndex);
            }
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              title: Padding( padding: const EdgeInsets.fromLTRB(0.6,0,0,0),
                child: Text(tr('home'), style: const TextStyle(fontSize: 14.0),), ),
              icon:  Icon( Icons.home_outlined,
                    size: 24, color: (_currentIndex==0)?
                  widget.theme.primaryColorDark: widget.theme.colorScheme.onBackground ),
              // (_currentIndex==0)?
              //       Padding( padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //         child: Image.asset("assets/icons/home_selected.png", width: 24, height: 24,), ) :
              //       Image.asset("assets/icons/home_unselected.png", width: 24, height: 24,),
              activeColor: widget.theme.primaryColorDark,
              inactiveColor: widget.theme.dividerColor,
            ),
            BottomNavyBarItem(
              title: Text(tr('search'), style: const TextStyle(fontSize: 14.0),),
              icon:  Icon(Icons.search_rounded,
                  size: 24,
                  color: (_currentIndex==1)? widget.theme.primaryColorDark: widget.theme.colorScheme.onBackground ),
              // icon: (_currentIndex==1)?
              //       Padding( padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //         child: Image.asset("assets/icons/search_selected.png", width: 24, height: 24,), ) :
              //       Image.asset("assets/icons/search_unselected.png", width: 24, height: 24,),
              activeColor: widget.theme.primaryColorDark,
              inactiveColor: widget.theme.dividerColor,
            ),
            BottomNavyBarItem(
              title: Text(tr('feeds'), style: const TextStyle(fontSize: 14.0),),
              icon:  Icon(Icons.notifications_none_rounded,
                  size: 24,
                  color: (_currentIndex==2)? widget.theme.primaryColorDark: widget.theme.colorScheme.onBackground ),
              // icon: (_currentIndex==2)?
              //       Padding( padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //         child: Image.asset("assets/icons/subscription_selected.png", width: 24, height: 24,), ) :
              //       Image.asset("assets/icons/subscription_unselected.png", width: 24, height: 24,),
              activeColor: widget.theme.primaryColorDark,
              inactiveColor: widget.theme.dividerColor,
            ),
            BottomNavyBarItem(
              title: Text(tr('donations'), style: const TextStyle(fontSize: 14.0),),
              icon:  Icon(Icons.money_rounded,
                  size: 24,
                  color: (_currentIndex==3)? widget.theme.primaryColorDark: widget.theme.colorScheme.onBackground ),
              // icon: (_currentIndex==3)?
              //       Padding( padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //         child: Image.asset("assets/icons/donation_selected.png", width: 24, height: 24,), ) :
              //       Image.asset("assets/icons/donation_unselected.png", width: 24, height: 24,),
              activeColor: widget.theme.primaryColorDark,
              inactiveColor: widget.theme.dividerColor,
            ),
          ],
        ),
      ),
    );
  }
}
