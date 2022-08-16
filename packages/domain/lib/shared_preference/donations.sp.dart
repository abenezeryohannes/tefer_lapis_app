import 'dart:convert';
import 'package:domain/models/user.model.dart';
import 'package:domain/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/donation.model.dart';

class DonationSP extends ChangeObserver{

  final String key = "donations";
  late SharedPreferences prefs;

  loadPreference() async{ prefs =  await SharedPreferences.getInstance(); }


  void saveDonations(List<DonationModel> donations) async{
    String jsonString = json.encode(donations);
    prefs.setString(key, jsonString);
    onChange();
  }

  Future<List<DonationModel>> getDonations() async{
    String? jsonString = prefs.getString(key);


    if(jsonString == null) return [];

    return (json.decode(jsonString) as List).map (
            (i) => DonationModel.fromJson(i)
    ).toList();

    // List<DonationModel> donations = [];
    // return donations;

    // Map<String, dynamic> json = jsonDecode(jsonString);
    // return DonationModel.fromJson(json);
  }

}
