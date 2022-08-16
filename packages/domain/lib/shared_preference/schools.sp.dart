import 'dart:convert';
import 'package:domain/models/user.model.dart';
import 'package:domain/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/activity.model.dart';
import '../models/school.model.dart';

class SchoolsSp extends ChangeObserver{

  final String key = "schools";
  late SharedPreferences prefs;

  loadPreference() async{ prefs =  await SharedPreferences.getInstance(); }


  void saveSchools(List<UserModel> Schools) async{
    String jsonString = json.encode(Schools);
    prefs.setString(key, jsonString);
    onChange();
  }

  Future<List<UserModel>> getSchools() async{
    String? jsonString = prefs.getString(key);


    if(jsonString == null) return [];

    return (json.decode(jsonString) as List).map (
            (i) => UserModel.fromJson(i)
    ).toList();

    // List<ActivityModel> Schools = [];
    // return Schools;

    // Map<String, dynamic> json = jsonDecode(jsonString);
    // return ActivityModel.fromJson(json);
  }

}
