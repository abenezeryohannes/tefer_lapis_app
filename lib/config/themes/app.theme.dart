// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'app.theme.data.dart'; 
part 'app.theme.g.dart';

@JsonSerializable()
class AppTheme extends ChangeNotifier{

  AppThemeData selectedThemeData = AppThemeData.Fresh();
  List<AppThemeData> themeDatas = [];  
  
  AppTheme.Fresh();

  AppTheme({required this.selectedThemeData, required this.themeDatas});
 
  ThemeData getThemeData() { return selectedThemeData.getThemeData(); }
 
  void setCurrentTheme(int index) {
    selectedThemeData = themeDatas[index];
    notifyListeners();
  }
 
  Future<List<ThemeData>> loadThemeDatas() async {
    //if(themeDatas.isEmpty){
      final String pelete1 = await rootBundle.loadString('assets/themes/palette1.json');
      final String pelete2 = await rootBundle.loadString('assets/themes/palette2.json');
      final String pelete3 = await rootBundle.loadString('assets/themes/palette3.json');
      final String pelete4 = await rootBundle.loadString('assets/themes/palette4.json');
      
      Map<String, dynamic> data1 = await json.decode(pelete1);
      Map<String, dynamic> data2 = await json.decode(pelete2);
      Map<String, dynamic> data3 = await json.decode(pelete3);
      Map<String, dynamic> data4 = await json.decode(pelete4); 

      themeDatas = [
              AppThemeData.fromJson(data1), 
              AppThemeData.fromJson(data2), 
              AppThemeData.fromJson(data3),
              AppThemeData.fromJson(data4)  ];
      //}    
    return themeDatas.map((e) => e.getThemeData()).toList();
  }

  List<ThemeData> getThemeDatas() {
    return themeDatas.map((e) => e.getThemeData()).toList();
  }


  factory AppTheme.fromJson(Map<String, dynamic> json) => _$AppThemeFromJson(json);
  Map<String, dynamic> toJson() => _$AppThemeToJson(this);

  List<AppThemeData> getAppThemeDatas() { return themeDatas;}

}
//