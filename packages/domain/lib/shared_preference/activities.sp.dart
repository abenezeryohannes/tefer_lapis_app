import 'dart:convert';
import 'package:domain/models/user.model.dart';
import 'package:domain/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/activity.model.dart';

class ActivitySP extends ChangeObserver{

  final String key = "activities";
  late SharedPreferences prefs;

  loadPreference() async{ prefs =  await SharedPreferences.getInstance(); }


  void saveActivities(List<ActivityModel> activities) async{
    String jsonString = json.encode(activities);
    prefs.setString(key, jsonString);
    onChange();
  }

  Future<List<ActivityModel>> getActivities() async{
    String? jsonString = prefs.getString(key);


    if(jsonString == null) return [];

    return (json.decode(jsonString) as List).map (
            (i) => ActivityModel.fromJson(i)
    ).toList();

    // List<ActivityModel> activities = [];
    // return activities;

    // Map<String, dynamic> json = jsonDecode(jsonString);
    // return ActivityModel.fromJson(json);
  }

}
