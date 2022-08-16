// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
part 'app.theme.data.g.dart';

@JsonSerializable()
class AppThemeData {
   String name =  'palette 1';
   MaterialColor primarySwatch = MaterialColor( int.parse('0xfffafafa'),
     const <int, Color>{
       50: Color(0xfffafafa ),//10%
       100: Color(0xfff5f5f5),//20%
       200: Color(0xffeeeeee),//30%
       300: Color(0xffe0e0e0),//40%
       400: Color(0xffbdbdbd),//50%
       500: Color(0xff9e9e9e),//60%
       600: Color(0xff757575),//70%
       700: Color(0xff616161),//80%
       800: Color(0xff424242),//90%
       900: Color(0xff212121),//100%
     },
   );
   List<String> BackgroundColors = ['0xFFFFFFFF', '0xFFfafafa'];
   String AccentColor =  '0xFFFDD835';
   String highlightColor =  '0xFFFFF59D';
   String PrimaryColor =  '0xFFFDD835';
   String PrimaryColorDark =  '0xFFFDD835';
   String AccentColorLight = '0xFFFFEB3B';
   String AccentColorDark = '0xFFFFEB3B';
   String ActiveColor = '0xFFFFEB3B';
   String dividerColor = '0xFF9e9e9e';
   String InActiveColor = '0xFF33322F';
   String UnSelectedColor = '0xFF9E9E9E';
   String SelectedColor =  '0xFFFDD835';
   String TextColor = '0xFF333333';
   String ButtonTextColor = '0xFF333333';
   String OnBackground  = '0xFF333333';
   String CardColor  = '0xFFFFFFFF';
   String OnSecondary  = '0xFF000000';
   String canvasColor  = '0xFFFFFFFF';


  AppThemeData.Fresh();

   AppThemeData({
       this.name =  'palette 1',
       this.BackgroundColors = const ['0xFFFFFFFF', '0xFF282725'],
       this.AccentColor =  '0xFFffeb3b',
       this.highlightColor =  '0xFFFFF59D',
       this.PrimaryColor =  '0xFFFDD835',
       this.PrimaryColorDark =  '0xFFFDD835',
       this.AccentColorLight = '0xFFFFEB3B',
       this.AccentColorDark = '0xFFFFEB3B',
       this.ActiveColor = '0xFFFFEB3B',
       this.InActiveColor = '0xFF33322F',
       this.UnSelectedColor = '0xFF9E9E9E',
       this.SelectedColor =  '0xFFFDD835',
       this.TextColor = '0xFFFFFFFF',
       this.ButtonTextColor = '0xFF333333',
       this.OnBackground  = '0xFFFFFFFF',
       this.CardColor  = '0xFF393733',
       this.OnSecondary  = '0xFF333333',
       this.dividerColor = '0xFF9e9e9e'
   });

  ThemeData getThemeData() {

    return ThemeData(
      
      primaryColor: Color(int.parse(PrimaryColor)),
      
      primaryColorDark: Color(int.parse(PrimaryColorDark)),
      
      backgroundColor: Color(int.parse(BackgroundColors[0])),
      
      scaffoldBackgroundColor: Color(int.parse(BackgroundColors[1])),
      
      unselectedWidgetColor: Color(int.parse(UnSelectedColor)),

      cardColor:  Color(int.parse(CardColor)),

      dividerColor:  Color(int.parse(dividerColor)),

      primarySwatch:  primarySwatch,

      // highlightColor:  Color(int.parse(highlightColor)),

      // appBarTheme:  AppBarTheme(
      //   iconTheme: IconThemeData(color: Color(int.parse(OnBackground))),
      //   color:  Colors.transparent,
      //   foregroundColor: Color(int.parse(OnBackground)),
      //   systemOverlayStyle: const SystemUiOverlayStyle( //<-- SEE HERE
      //     // Status bar color
      //     statusBarColor: Colors.transparent,
      //     statusBarIconBrightness: Brightness.dark,
      //     statusBarBrightness: Brightness.dark,
      //     systemNavigationBarColor: Colors.transparent,
      //     systemNavigationBarIconBrightness: Brightness.dark
      //   ),
      // ),

      canvasColor: Color(int.parse(canvasColor)),

      brightness: Brightness.light,
      colorScheme: ColorScheme.dark (
          brightness: Brightness.light,
          secondary: Color(int.parse(AccentColor) ),   
          onBackground: Color(int.parse(OnBackground) ),
          onSecondary: Color(int.parse(OnSecondary)),
      ),


      textTheme: TextTheme(
        
        headline1: TextStyle(fontSize: 34.0, color: Color(int.parse(TextColor)), fontWeight: FontWeight.bold),
        
        headline2: TextStyle(fontSize: 34.0, color: Color(int.parse(AccentColor)), fontWeight: FontWeight.bold),
        
        headline3: TextStyle(fontSize: 26.0, color: Color(int.parse(TextColor)), fontWeight: FontWeight.bold),
        
        headline4: TextStyle(fontSize: 26.0, color: Color(int.parse(AccentColor)), fontWeight: FontWeight.bold),
        
        headline5: TextStyle(fontSize: 24.0, color: Color(int.parse(TextColor)), fontWeight: FontWeight.bold),
        
        headline6: TextStyle(fontSize: 24.0, color: Color(int.parse(AccentColor)), fontWeight: FontWeight.bold),
        
        bodyText1: TextStyle(fontSize: 20.0, color: Color(int.parse(TextColor)), fontWeight: FontWeight.bold),

        bodyText2: TextStyle(fontSize: 14.0, color: Color(int.parse(TextColor)), fontWeight: FontWeight.bold),

        subtitle1: TextStyle(fontSize: 16.0, color: Color(int.parse(TextColor)), fontWeight: FontWeight.normal),
        
        subtitle2: TextStyle(fontSize: 14.0, color: Color(int.parse(TextColor)), fontWeight: FontWeight.w400 ),

        caption: TextStyle(fontSize: 12.0, color: Color(int.parse(TextColor)), fontWeight: FontWeight.normal ),
        
        button: TextStyle(fontSize: 16.0, color: Color(int.parse(ButtonTextColor)), fontWeight: FontWeight.bold),

        overline: TextStyle(fontSize: 12.0, color: Color(int.parse(ButtonTextColor)), fontWeight: FontWeight.bold),

      ),



    );
  }    
  
  factory AppThemeData.fromJson(Map<String, dynamic> json) => _$AppThemeDataFromJson(json);
  Map<String, dynamic> toJson() => _$AppThemeDataToJson(this);
}
//