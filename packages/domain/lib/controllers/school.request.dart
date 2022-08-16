
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:domain/models/donor.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:util/RequestHandler.dart';

import '../models/activity.model.dart';
import '../models/donation.model.dart';
import '../models/post.model.dart';
import '../models/user.model.dart';
import '../models/wrapper.dart';

class SchoolRequest{


  UserModel user;
  SchoolRequest(this.user);

  Future<PaginationModel?> getFundraisers({required int id, PaginationModel? pagination, int page=1, int limit = 25 }) async{
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/donor/school/fundraisers/$id",
          query: {'page': page, 'limit': limit});
      //print("page: $page");

      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      PaginationModel _pagination = PaginationModel.fromJson(jsonMap);

      //dynamic dynamicMap = json.decode(jsonEncode(pagination.data));
      List<FundraiserModel> fundraisers = (_pagination.data as List).map((e)=> FundraiserModel.fromJson(e)).toList();

      print("$page ${pagination==null?1:pagination.current_page}, ${fundraisers.length}");
       if((pagination!=null?pagination.current_page??1:1) < page) {
         List<FundraiserModel> _fundraisers = pagination != null ? pagination
            .data ?? <FundraiserModel>[]:<FundraiserModel>[];
        _fundraisers.addAll(fundraisers);
        _pagination.data = _fundraisers;
       }else {
         _pagination.data = fundraisers;
       }
      print("loaded page: ${_pagination.current_page} $_pagination");
      return _pagination;
    }catch(e){
      print("error: ${e.toString()}");
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0
      );
      rethrow;
    }
  }
  Future<PaginationModel?> getPosts({required int id, PaginationModel? pagination, int page=1, int limit = 25 }) async{
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/donor/school/posts/$id");
      //print("response: $response");

      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      PaginationModel _pagination = PaginationModel.fromJson(jsonMap);

      List<PostModel> posts = (_pagination.data as List).map((e)=> PostModel.fromJson(e)).toList();

      //print("$page ${pagination==null?1:pagination.current_page}, ${posts.length}");
      if((pagination!=null?pagination.current_page??1:1) < page) {
        List<PostModel> _posts = pagination != null ? pagination
            .data ?? <PostModel>[]:<PostModel>[];
        _posts.addAll(posts);
        _pagination.data = _posts;
      }else {
        _pagination.data = posts;
      }
      //print("loaded page: ${_pagination.current_page} ${_pagination}");
      return _pagination;
    }catch(e){
      print("error: ${e.toString()}");
    }
  }

  Future<PaginationModel?> getDonations({required int id,
    PaginationModel? pagination, int page=1, int limit = 25 }) async{
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token,
          path: "api/v1/driver/school_donations/$id");
      //print("response: $response");

      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      PaginationModel _pagination = PaginationModel.fromJson(jsonMap);

      List<DonationModel> donations = (_pagination.data as List).map((e)=> DonationModel.fromJson(e)).toList();

      //print("$page ${pagination==null?1:pagination.current_page}, ${donations.length}");
      if((pagination!=null?pagination.current_page??1:1) < page) {
        List<DonationModel> _donations = pagination != null ? pagination
            .data ?? <DonationModel>[]:<DonationModel>[];
        _donations.addAll(donations);
        _pagination.data = _donations;
      }else {
        _pagination.data = donations;
      }
      //print("loaded page: ${_pagination.current_page} ${_pagination}");
      return _pagination;
    }catch(e){
      print("error: ${e.toString()}");
    }
  }
}