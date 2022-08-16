import 'dart:convert';
import 'package:domain/models/user.model.dart';
import 'package:domain/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/activity.model.dart';
import '../models/post.model.dart';

class PostsSP extends ChangeObserver{

  final String key = "posts";
  late SharedPreferences prefs;

  loadPreference() async{ prefs =  await SharedPreferences.getInstance(); }

  void savePosts(List<PostModel> Posts) async{
    String jsonString = json.encode(Posts);
    prefs.setString(key, jsonString);
    onChange();
  }

  Future<List<PostModel>> getPosts() async{
    String? jsonString = prefs.getString(key);


    if(jsonString == null) return [];

    return (json.decode(jsonString) as List).map (
            (i) => PostModel.fromJson(i)
    ).toList();

    // List<ActivityModel> Posts = [];
    // return Posts;

    // Map<String, dynamic> json = jsonDecode(jsonString);
    // return ActivityModel.fromJson(json);
  }

}
