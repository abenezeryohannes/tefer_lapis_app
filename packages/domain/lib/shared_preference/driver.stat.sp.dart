import 'dart:convert';
import 'package:domain/models/user.model.dart';
import 'package:domain/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/donor.stat.dart';
import '../models/driver.stat.dart';

class DriverStatSP extends ChangeObserver{

  final String key = "driver_stat";

  late SharedPreferences prefs;

  loadPreference() async{ prefs =  await SharedPreferences.getInstance(); }

  void saveDriverStat(UserModel user) async{
    Map<String, dynamic> jsonMap = user.toJson();
    prefs.setString(key, jsonEncode(jsonMap));
    onChange();
  }

  Future<DriverStat> getDriverStat() async{
    String? jsonString = prefs.getString(key);
    if(jsonString == null)return DriverStat.fresh();
    Map<String, dynamic> json = jsonDecode(jsonString);
    return DriverStat.fromJson(json);
  }

}
