import 'dart:convert';
import 'package:domain/models/model.dart';
import 'package:domain/models/stationary.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/activity.model.dart';

class StationariesSP extends ChangeObserver{

  final String key = "stationaries";
  late SharedPreferences prefs;

  loadPreference() async{ prefs =  await SharedPreferences.getInstance(); }


  void saveStationaries(List<UserModel> Stationaries) async{
    String jsonString = json.encode(Stationaries);
    prefs.setString(key, jsonString);
    onChange();
  }

  Future<List<UserModel>> getStationaries() async{
    String? jsonString = prefs.getString(key);

    if(jsonString == null) return [];

    return (json.decode(jsonString) as List).map (
            (i) => UserModel.fromJson(i)
    ).toList();

    // List<ActivityModel> Stationaries = [];
    // return Stationaries;

    // Map<String, dynamic> json = jsonDecode(jsonString);
    // return ActivityModel.fromJson(json);
  }

}
