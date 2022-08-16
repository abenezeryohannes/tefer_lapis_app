import 'dart:convert';
import 'package:domain/models/user.model.dart';
import 'package:domain/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSP extends ChangeObserver{

  final String key = "user";
  late SharedPreferences prefs;

  loadPreference() async{ prefs =  await SharedPreferences.getInstance(); }


  void saveUser(UserModel user) async{
    Map<String, dynamic> jsonMap = user.toJson();
    prefs.setString(key, jsonEncode(jsonMap));
    onChange();
  }

  Future<UserModel> getUser() async{
    String? jsonString = prefs.getString(key);
    if(jsonString == null)return UserModel.fresh();
    Map<String, dynamic> json = jsonDecode(jsonString);
    return UserModel.fromJson(json);
  }

}
