import 'dart:convert';
import 'package:domain/shared_preference/change_observer.dart';
import 'package:flutter/material.dart';
import 'package:myapp/config/themes/app.theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingSP extends ChangeObserver{
  
  final String themeKey = "theme"; 
  final String themesKey = "themes";  
  final String langKey = "locale"; 
  late SharedPreferences prefs;

  loadPreference() async{ prefs =  await SharedPreferences.getInstance(); }

  void saveLocale(Locale locale) async{
    String string = locale.languageCode + (locale.countryCode!=null?("-"+locale.countryCode.toString()):"");
    prefs.setString(langKey, string);
    onChange();
  }

  Future<Locale> getLocale() async{
    Locale defaultLocale = const Locale("en", "US");
    String? string = prefs.getString(langKey);  
    return (string == null || string.isEmpty || !string.contains('-'))? 
            defaultLocale:  Locale(string.split("-")[0], string.split("-")[1]);
  }

  void saveTheme(AppTheme theme) async{
    String json = jsonEncode(theme);
    prefs.setString(themeKey, json);
    onChange();
  }

  Future<AppTheme> getTheme() async{
    String? jsonString = prefs.getString(themeKey);
    if(jsonString==null) return AppTheme.Fresh();
    Map<String, dynamic> themeMap = jsonDecode(jsonString);
    AppTheme theme = AppTheme.fromJson(themeMap);
    return theme;
  }  

}
 