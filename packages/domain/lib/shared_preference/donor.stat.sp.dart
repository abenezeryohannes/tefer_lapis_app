import 'dart:convert';
import 'package:domain/models/user.model.dart';
import 'package:domain/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/donor.stat.dart';

class DonorStatSP extends ChangeObserver{

  final String key = "donor_stat";

  late SharedPreferences prefs;

  loadPreference() async{ prefs =  await SharedPreferences.getInstance(); }

  void saveDonorStat(DonorStat user) async{
    Map<String, dynamic> jsonMap = user.toJson();
    prefs.setString(key, jsonEncode(jsonMap));
    onChange();
  }

  Future<DonorStat> getDonorStat() async{
    String? jsonString = prefs.getString(key);
    if(jsonString == null)return DonorStat.fresh();
    Map<String, dynamic> json = jsonDecode(jsonString);
    return DonorStat.fromJson(json);
  }

}
