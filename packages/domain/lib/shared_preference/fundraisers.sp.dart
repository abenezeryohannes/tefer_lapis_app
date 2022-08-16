import 'dart:convert';
import 'package:domain/models/user.model.dart';
import 'package:domain/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/fundraiser.model.dart';

class FundraiserSP extends ChangeObserver{

  final String key = "fundraisers";
  late SharedPreferences prefs;

  loadPreference() async{ prefs =  await SharedPreferences.getInstance(); }


  void saveFundraisers(List<FundraiserModel> fundraisers) async{
    String jsonString = json.encode(fundraisers);
    prefs.setString(key, jsonString);
    onChange();
  }

  Future<List<FundraiserModel>> getFundraisers() async{
    String? jsonString = prefs.getString(key);


    if(jsonString == null) return [];

    return (json.decode(jsonString) as List).map (
            (i) => FundraiserModel.fromJson(i)
    ).toList();

    // List<FundraiserModel> fundraisers = [];
    // return fundraisers;

    // Map<String, dynamic> json = jsonDecode(jsonString);
    // return FundraiserModel.fromJson(json);
  }

}
