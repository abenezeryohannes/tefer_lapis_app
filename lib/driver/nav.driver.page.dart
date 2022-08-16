import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:domain/models/user.model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myapp/driver/delivery.driver.page.dart';
import '../pages/search.page.dart';
import 'package:util/Stack.dart' as MyStack;
import '../pages/subscription.dart';
import 'home.driver.page.dart';

class NavbarDriver extends StatefulWidget {
  const NavbarDriver( { Key? key, required this.saveUser, required this.user, required this.onThemeChange,
    required this.theme, required this.themes, required this.tr, required this.locales,
  } ) : super(key: key);

  final UserModel user;
  final ThemeData theme;
  final Function(int) onThemeChange;
  final List<ThemeData> themes;
  final List<Locale> locales;

  final String Function(String, {List<String> args}) tr;
  final void Function(UserModel newUser) saveUser;

  @override
  _NavbarDriverState createState() => _NavbarDriverState();

}

class _NavbarDriverState extends State<NavbarDriver> {

  MyStack.Stack<int> stack = MyStack.Stack<int>();
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() { super.initState();
  _pageController = PageController();

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

                    HomeDriverPage(saveUser: widget.saveUser, themeDatas: widget.themes,
                      onThemeChange: widget.onThemeChange,
                      theme: widget.theme, tr: widget.tr, user: widget.user,),

                    SearchPage(saveUser: widget.saveUser, theme: widget.theme, tr: widget.tr, user: widget.user,),

                    SubscriptionPage(saveUser: widget.saveUser, theme: widget.theme, tr: widget.tr, user: widget.user,),

                    DeliveryDriverPage(saveUser: widget.saveUser,
                      theme: widget.theme, tr: widget.tr, user: widget.user,),

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
              title: Padding( padding: const EdgeInsets.fromLTRB(0.6,0,0,0), child: Text(tr('home'), style: const TextStyle(fontSize: 14.0),), ),
              icon:  Icon(Icons.home_outlined, size: 24,
                  color: (_currentIndex==0)? widget.theme.primaryColorDark : widget.theme.colorScheme.onBackground ),
              activeColor: widget.theme.primaryColorDark,
              inactiveColor: widget.theme.unselectedWidgetColor,
            ),

            BottomNavyBarItem(
              title: Text(tr('search'), style: const TextStyle(fontSize: 14.0),),
              icon:  Icon(Icons.search_rounded, size: 24,
                  color: (_currentIndex==1)? widget.theme.primaryColorDark: widget.theme.colorScheme.onBackground ),
              activeColor: widget.theme.primaryColorDark,
              inactiveColor: widget.theme.dividerColor,
            ),

            BottomNavyBarItem(
              title: Text(tr('feeds'), style: const TextStyle(fontSize: 14.0),),
              icon:  Icon(Icons.notifications_none_rounded, size: 24,
                  color: (_currentIndex==2)? widget.theme.primaryColorDark: widget.theme.colorScheme.onBackground ),
              activeColor: widget.theme.primaryColorDark, inactiveColor: widget.theme.dividerColor,
            ),

            BottomNavyBarItem(
              title: Text(tr('deliveries'), style: const TextStyle(fontSize: 14.0),),
              icon:  Icon(Icons.directions_car, size: 24,
                  color: (_currentIndex==3)? widget.theme.primaryColorDark : widget.theme.colorScheme.onBackground ),
              activeColor: widget.theme.primaryColorDark, inactiveColor: widget.theme.unselectedWidgetColor,
            ),

          ],
        ),
      ),
    );
  }

}
