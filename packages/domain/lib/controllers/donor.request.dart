
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:domain/models/donor.model.dart';
import 'package:domain/models/donor.stat.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/stationary.item.model.dart';
import 'package:domain/models/stationary.model.dart';
import 'package:domain/models/subscription.model.dart';
import 'package:domain/shared_preference/donations.sp.dart';
import 'package:domain/shared_preference/fundraisers.sp.dart';
import 'package:domain/shared_preference/posts.sp.dart';
import 'package:domain/shared_preference/schools.sp.dart';
import 'package:domain/shared_preference/stationaries.sp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:util/RequestHandler.dart';

import '../models/activity.model.dart';
import '../models/donation.model.dart';
import '../models/post.model.dart';
import '../models/school.model.dart';
import '../models/user.model.dart';
import '../models/wrapper.dart';
import '../shared_preference/activities.sp.dart';
import '../shared_preference/donor.stat.sp.dart';

class DonorRequest{

  UserModel user;
  DonorRequest(this.user);

  Future<Wrapper?> getDonation(int id) async{
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/donor/donation/$id");
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if(wrapper.message==null&&wrapper.data!=null){
        print("checking: ${wrapper.data}");
        jsonMap = json.decode(jsonEncode(wrapper.data));
        wrapper.data = DonationModel.fromJson(jsonMap);
      }else if (wrapper.success == false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/donor/donation/$id"),
            type: DioErrorType.response, error: wrapper.message );
      }
      return wrapper;
    }on DioError catch(e){
      print("GET donation error: ${e.message}");
      rethrow;
    }
  }


  Future<Wrapper?> getPost(int id) async{
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token,
          path: "api/v1/donor/post/$id");
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if(wrapper.message==null&&wrapper.data!=null){
        print("checking: ${wrapper.data}");
        jsonMap = json.decode(jsonEncode(wrapper.data));
        wrapper.data = PostModel.fromJson(jsonMap);
      }else if (wrapper.success == false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/donor/post/$id"),
            type: DioErrorType.response, error: wrapper.message );
      }
      return wrapper;
    }on DioError catch(e){
      print("GET donation error: ${e.message}");
      rethrow;
    }
  }



  Future<Wrapper?> assignDriver({ required int deliverer_id,  required int donation_id}) async{
    try{
      Response<dynamic>? response = await RequestHandler.post(auth: user.getToken().token, path: "api/v1/donor/assign_driver",
        request: {"deliverer_id": deliverer_id, "donation_id": donation_id}
      );
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if(wrapper.success??false){
        print("checking: ${wrapper.data}");
        jsonMap = json.decode(jsonEncode(wrapper.data));
        wrapper.data = DonationModel.fromJson(jsonMap);
      }else if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/donor/assign_driver"),
            type: DioErrorType.response, error: wrapper.message );
      }
      return wrapper;
    }on DioError catch(e){
      print("POST: Assign Driver deliverer_id: $deliverer_id donation_id: $donation_id error: ${e.message}");
      rethrow;
    }
  }

  Future<PaginationModel?> getDonations({PaginationModel? pagination, int page=1, int limit = 25 }) async{
    DonationSP donationSP = DonationSP();
    await donationSP.loadPreference();
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/donor/donations");
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
      donationSP.saveDonations(_pagination.data);

      //print("loaded page: ${_pagination.current_page} ${_pagination}");
      return _pagination;
    }on DioError catch(e){
      print("Get Donations error: ${e.message}");
      List<DonationModel> donations = await donationSP.getDonations();
      if(donations.isNotEmpty&&page==1) {
        PaginationModel paginationModel = PaginationModel.fresh(
            total_items: donations.length,
            limit: donations.length,
            current_page: 1,
            data: donations
        );
        return paginationModel;
      }
      rethrow;
    }
  }



  Future<PaginationModel?> getFundraisers({PaginationModel? pagination = null,
    String? sort, String? search, int page=1, int limit = 25 }) async{
    FundraiserSP fundraiserSP = FundraiserSP();
    await fundraiserSP.loadPreference();
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token,
          path: "api/v1/donor/fundraisers", query: {'page': page, 'limit': 10,
        'search':search, 'sort_by': sort});
      print("response get fundraiser: ${response}");

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
       fundraiserSP.saveFundraisers(_pagination.data);
      //print("loaded page: ${_pagination.current_page} ${_pagination}");
      return _pagination;
    }on DioError catch(e) {
      print("GET fundraiser error: ${e.message}");
      //load from local
      List<FundraiserModel> fundraisers = await fundraiserSP.getFundraisers();
      if(fundraisers.isNotEmpty&&page==1) {
        PaginationModel paginationModel = PaginationModel.fresh(
            total_items: fundraisers.length,
            limit: fundraisers.length,
            current_page: 1,
            data: fundraisers
        );
        return paginationModel;
      }
      rethrow;
    }
  }

  Future<FundraiserModel?> getFundraiser( { required int id } ) async{
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/donor/fundraiser/$id");
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);

      if(wrapper.success??false){
        jsonMap = json.decode(jsonEncode(wrapper.data));
        return FundraiserModel.fromJson(jsonMap);
      }else if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/donor/fundraiser/$id"),
            type: DioErrorType.response, error: wrapper.message );
      }
      print("response: $response");
      return null;
    }on DioError catch(e){
      print("GET fundraiser error: ${e.message}");
      rethrow;
    }
  }

  Future<PaginationModel> getStationaries({PaginationModel? pagination,String? search, int page=1, int limit = 25 }) async{
    StationariesSP stationariesSP = StationariesSP();
    await stationariesSP.loadPreference();
    try{

      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/donor/stationaries", query: {
        'search':search, 'page': page, 'limit': limit
      });
      //print("page: $page");

      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      PaginationModel _pagination = PaginationModel.fromJson(jsonMap);

      //dynamic dynamicMap = json.decode(jsonEncode(pagination.data));
      List<UserModel> userModels = (_pagination.data as List).map((e)=> UserModel.fromJson(e)).toList();

      print("$page ${pagination==null?1:pagination.current_page}, ${userModels.length}");
      if((pagination!=null?pagination.current_page??1:1) < page) {
        List<UserModel> _userModels = pagination != null ? pagination
            .data ?? <UserModel>[]:<UserModel>[];
        _userModels.addAll(userModels);
        _pagination.data = _userModels;
      }else {
        _pagination.data = userModels;
      }
      print("loaded page: ${_pagination.current_page} $_pagination");
      stationariesSP.saveStationaries(_pagination.data);
      return _pagination;
    }on DioError catch(e){
      print("GET Stationaries error: ${e.message}");
      //load from local
      List<UserModel> stationaries = await stationariesSP.getStationaries();
      if(stationaries.isNotEmpty&&page==1) {
        PaginationModel paginationModel = PaginationModel.fresh(
            total_items: stationaries.length,
            limit: stationaries.length,
            current_page: 1,
            data: stationaries
        );
        return paginationModel;
      }
      rethrow;
    }
  }


  Future<PaginationModel> getDonationStationaries({required int id, PaginationModel? pagination, int page=1, int limit = 25 }) async{
    try{
      // print("stationary donations of: $id");
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/donor/stationaries_for_donation/$id",
          query: {'page': page, 'limit': limit});
      //print("page: $page");

      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      PaginationModel _pagination = PaginationModel.fromJson(jsonMap);

      //dynamic dynamicMap = json.decode(jsonEncode(pagination.data));
      List<UserModel> userModels = (_pagination.data as List).map((e)=> UserModel.fromJson(e)).toList();

      print("$page ${pagination==null?1:pagination.current_page}, ${userModels.length}");
      if((pagination!=null?pagination.current_page??1:1) < page) {
        List<UserModel> _userModels = pagination != null ? pagination
            .data ?? <UserModel>[]:<UserModel>[];
        _userModels.addAll(userModels);
        _pagination.data = _userModels;
      }else {
        _pagination.data = userModels;
      }
      print("loaded page: ${_pagination.current_page} $_pagination");
      return _pagination;
    }on DioError catch(e){
      print("Get Donation_Stationaries id: $id error: ${e.message}");
      rethrow;
    }
  }

  Future<PaginationModel?> getSchools({PaginationModel? pagination, int page=1,String? search, int limit = 25 }) async{
    SchoolsSp schoolsSP = SchoolsSp();
    await schoolsSP.loadPreference();
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/donor/schools", query: {
        'search':search, 'page': page, 'limit': limit
      });
      //print("response: $response");

      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      PaginationModel _pagination = PaginationModel.fromJson(jsonMap);

      List<UserModel> schools = (_pagination.data as List).map((e)=> UserModel.fromJson(e)).toList();

      //print("$page ${pagination==null?1:pagination.current_page}, ${schools.length}");
      if((pagination!=null?pagination.current_page??1:1) < page) {
        List<UserModel> _schools = pagination != null ? pagination
            .data ?? <UserModel>[]:<UserModel>[];
        _schools.addAll(schools);
        _pagination.data = _schools;
      }else {
        _pagination.data = schools;
      }
      //print("loaded page: ${_pagination.current_page} ${_pagination}");
      schoolsSP.saveSchools(_pagination.data);
      return _pagination;
    }on DioError catch(e){
      print("GET School error: ${e.message}");
      //load from local
      List<UserModel> schools = await schoolsSP.getSchools();
      if(schools.isNotEmpty&&page==1) {
        PaginationModel paginationModel = PaginationModel.fresh(
            total_items: schools.length,
            limit: schools.length,
            current_page: 1,
            data: schools
        );
        return paginationModel;
      }
      rethrow;
    }
  }

  Future<PaginationModel?> getPosts({PaginationModel? pagination, int page=1,String? search, int limit = 25 }) async{
    PostsSP postsSP = PostsSP();
    await postsSP.loadPreference();
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/donor/posts", query: {
        'search':search, 'page': page, 'limit': limit
      });
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
      postsSP.savePosts(_pagination.data);
      return _pagination;
    }on DioError catch(e){
      print("GET Posts error: ${e.message}");
      //load from local
      List<PostModel> posts = await postsSP.getPosts();
      if(posts.isNotEmpty&&page==1) {
        PaginationModel paginationModel = PaginationModel.fresh(
            total_items: posts.length,
            limit: posts.length,
            current_page: 1,
            data: posts
        );
        return paginationModel;
      }
      rethrow;
    }
  }

  Future<PaginationModel?> getActivities({PaginationModel? pagination, int page=1, int limit = 25 }) async{
    ActivitySP activitySP = ActivitySP();
    await activitySP.loadPreference();
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/donor/activities");
      //print("response: $response");

      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      PaginationModel _pagination = PaginationModel.fromJson(jsonMap);

      print("pp: $_pagination");
      List<ActivityModel> activities = (_pagination.data as List).map((e)=> ActivityModel.fromJson(e)).toList();

      //print("$page ${pagination==null?1:pagination.current_page}, ${activities.length}");
      if((pagination!=null?pagination.current_page??1:1) < page) {
        List<ActivityModel> _activities = pagination != null ? pagination
            .data ?? <ActivityModel>[]:<ActivityModel>[];
        _activities.addAll(activities);
        _pagination.data = _activities;
      }else {
        _pagination.data = activities;
      }

      activitySP.saveActivities(_pagination.data);
      //print("loaded page: ${_pagination.current_page} ${_pagination}");
      return _pagination;
    }on DioError catch(e){
      print("Get Activities error: ${e.message}");
      List<ActivityModel> activities = await activitySP.getActivities();
      if(activities.isNotEmpty&&page==1) {
        PaginationModel paginationModel = PaginationModel.fresh(
            total_items: activities.length,
            limit: activities.length,
            current_page: 1,
            data: activities
        );
        return paginationModel;
      }
      rethrow;
    }
  }

 Future<SubscriptionModel?> subscribe({required int user_id, required int school_id}) async{
    try{
      Response<dynamic>? response = await RequestHandler.post(auth: user.getToken().token, path: "api/v1/donor/subscribe",
          request: { 'school_id':school_id}
      );
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);

      if(wrapper.success??false){
        jsonMap = json.decode(jsonEncode(wrapper.data));
        return SubscriptionModel.fromJson(jsonMap);
      }else if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/donor/subscribe"),
            type: DioErrorType.response, error: wrapper.message );
      }
      return null;
    }on DioError catch(e){
      print("error: ${e.message}");
      rethrow;
    }
  }


  Future<bool> unSubscribe({required int user_id, required int school_id}) async{
    try{
      Response<dynamic>? response = await RequestHandler.post(auth: user.getToken().token, path: "api/v1/donor/unsubscribe",
          request: { 'school_id':school_id}
      );
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);

      print("unsubscribe wrapper $wrapper");
      if(wrapper.success??false){
        return true;
      }else if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/donor/subscribe"),
            type: DioErrorType.response, error: wrapper.message );
      }
      return false;
    }on DioError catch(e){
      print("POST unsubscribe error: ${e.message}");
      rethrow;
    }
  }


  Future<bool?> isSubscribed({required int user_id, required int school_id}) async{
    try{
      Response<dynamic>? response = await RequestHandler.post(auth: user.getToken().token, path: "api/v1/donor/is_subscribed",
          request: {'school_id':school_id}
      );
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);

      print("wrapper: $wrapper");
      if(wrapper.success??false){
        return wrapper.data as bool;
      }else if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/donor/is_subscribed"),
            type: DioErrorType.response, error: wrapper.message );
      }
      return null;
    }on DioError catch(e){
      print("POST is_subscribed error: ${e.message}");
      rethrow;
    }
  }

  Future<PaginationModel?> getStationaryItems({required int user_id, PaginationModel? pagination, int page=1, int limit = 25 }) async{
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/donor/stationary/items/$user_id");

      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      PaginationModel _pagination = PaginationModel.fromJson(jsonMap);

      List<StationaryItemModel> stationaryItems = (_pagination.data as List).map((e)=> StationaryItemModel.fromJson(e)).toList();

      //print("$page ${pagination==null?1:pagination.current_page}, ${stationaryItems.length}");
      if((pagination!=null?pagination.current_page??1:1) < page) {
        List<StationaryItemModel> _stationaryItems = pagination != null ? pagination
            .data ?? <StationaryItemModel>[]:<StationaryItemModel>[];
        _stationaryItems.addAll(stationaryItems);
        _pagination.data = _stationaryItems;
      }else {
        _pagination.data = stationaryItems;
      }
      //print("loaded page: ${_pagination.current_page} ${_pagination}");
      return _pagination;
    }on DioError catch(e){
      print("GET stationary_items error: ${e.message}");
      rethrow;
    }
  }

  Future<Wrapper> donate({required DonationModel donation}) async{
    print("donationItems: ${donation.getDonationItems()}");
    try{
      Response<dynamic>? response = await RequestHandler.post(auth: user.getToken().token, path: "api/v1/donor/donate",
          request: { 'fundraiser_id': donation.fundraiser_id, "stationary_user_id": donation.stationary_user_id,
            'DonationItems': json.encode(donation.getDonationItems()) }
      );
      Map<String, dynamic> jsonMap = (response?.data);
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if (wrapper.success==null || wrapper.success == false){
          // handle error here
          throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/donor/donate"),
          type: DioErrorType.response, error: wrapper.message );
      }
      return wrapper;
      // print("wrapper: $wrapper");
      // if(wrapper.success??false){
      //   jsonMap = json.decode(jsonEncode(wrapper.data));
      //   return DonationModel.fromJson(jsonMap);
      // }
      // return null;
    }on DioError catch(e){
      print("POST error: ${e.message}");
       return Wrapper.fresh(success: false, message: e.message);
    }
  }

  Future<Wrapper> editDonation({required DonationModel donation}) async{
    print("donationItems: ${donation.getDonationItems()}");
    try{
      Response<dynamic>? response = await RequestHandler.post(auth: user.getToken().token, path: "api/v1/donor/edit_donation/${donation.id}",
          request: jsonEncode(donation) );

      Map<String, dynamic> jsonMap = (response?.data);
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if (wrapper.success==null || wrapper.success == false){
          // handle error here
          throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/donor/donate"),
          type: DioErrorType.response, error: wrapper.message );
      }
      return wrapper;
      // print("wrapper: $wrapper");
      // if(wrapper.success??false){
      //   jsonMap = json.decode(jsonEncode(wrapper.data));
      //   return DonationModel.fromJson(jsonMap);
      // }
      // return null;
    }on DioError catch(e){
      print("POST error: ${e.message}");
      rethrow;
       // return Wrapper.fresh(success: false, message: e.message);
    }
  }


  Future<Wrapper> assignStationary({required int donation_id, required int stationary_id}) async{
    try{
      Response<dynamic>? response = await RequestHandler.post(auth: user.getToken().token, path: "api/v1/donor/assign_stationary",
          request: { 'donation_id': donation_id,'stationary_id': stationary_id }
      );
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/donor/assign_stationary"),
        type: DioErrorType.response, error: wrapper.message );
      }
      return wrapper;
      // print("wrapper: $wrapper");
      // if(wrapper.success??false){
      //   jsonMap = json.decode(jsonEncode(wrapper.data));
      //   return DonationModel.fromJson(jsonMap);
      // }
      // return null;
    }on DioError catch(e){
      print("POST assign_stationary error: ${e.message}");
      return Wrapper.fresh(success: false, message: e.message);
    }
  }


  Future<Wrapper> getDonatableAmount({required int fundraiserId}) async{
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/donor/donatable_amount/$fundraiserId");
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      PaginationModel _pagination = PaginationModel.fromJson(jsonMap);

      // print("check check ${_pagination.data}");
      List<StationaryItemModel> stationaryItems = (_pagination.data as List).map((e)=> StationaryItemModel.fromJson(e)).toList();
      _pagination.data = stationaryItems;

      // return _pagination;
      //print("loaded page: ${_pagination.current_page} ${_pagination}");
      return Wrapper(success: true, data:_pagination.data);
    }on DioError catch(e){
       print("GET get_donatable_amount error: ${e.message}");
       rethrow;
    }
  }

  Future<Wrapper> removeDonation(int id) async{
    try{
      Response<dynamic>? response = await RequestHandler.post(auth: user.getToken().token, path: "api/v1/donor/remove_donation",
          request: { 'donation_id': id }
      );
      Map<String, dynamic> jsonMap = (response?.data);
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/donor/remove_donation"),
        type: DioErrorType.response, error: wrapper.message );
      }
      return wrapper;
    }on DioError catch(e){
      print("POST remove_donation error: ${e.message}");
      return Wrapper.fresh(success: false, message: e.message);
    }
  }

  Future<PaginationModel?> nearBy({PaginationModel? pagination,String? search, int page=1,String? type, required double latitude, required double longitude}) async{
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/donor/near_by",
                query: {'latitude':latitude, 'longitude':longitude, "type": type, 'search':search});
      // print("nearby response: $response");

      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      PaginationModel _pagination = PaginationModel.fromJson(jsonMap);

      List<UserModel> institutions = (_pagination.data as List).map((e)=> UserModel.fromJson(e)).toList();

      //print("$page ${pagination==null?1:pagination.current_page}, ${schools.length}");
      if((pagination!=null?pagination.current_page??1:1) < page) {
        List<UserModel> _institutions = pagination != null ? pagination
            .data ?? <UserModel>[]:<UserModel>[];
        _institutions.addAll(institutions);
        _pagination.data = _institutions;
      }else { _pagination.data = institutions; }
      //print("loaded page: ${_pagination.current_page} ${_pagination}");
      return _pagination;
    }on DioError catch(e){
      print("GET nearby error: ${e.message}");
      rethrow;
    }
  }



  Future<Wrapper> stat() async{
    DonorStatSP donorStatSP = DonorStatSP();
    await donorStatSP.loadPreference();
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/donor/stat");
      Map<String, dynamic> jsonMap = (response?.data);
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/donor/is_subscribed"),
        type: DioErrorType.response, error: wrapper.message );
      }
      wrapper.data = DonorStat.fromJson(wrapper.data);
      //Map<dynamic,dynamic> json = jsonDecode(wrapper.data);
      //wrapper.data = json;
      donorStatSP.saveDonorStat(wrapper.data);
      return wrapper;
    }on DioError catch(e){
      print("GET stat error: ${e.message}");

      DonorStat donorStat = await donorStatSP.getDonorStat();
      if(donorStat.donated!=null) {
        return Wrapper.fresh(success: true, data: donorStat);
      }
      return Wrapper.fresh(success: false, message: e.message);
    }
  }

  Future<PaginationModel?> getNearbyFundraisers({PaginationModel? pagination,String? search, int page=1,required double latitude, required double longitude}) async{
      try{
        Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/donor/near_by_fundraisers",
            query: {'latitude':latitude, 'longitude':longitude,'search':search, 'limit': 10});
        print("response get nearby fundraiser: ${response}");

        Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
        PaginationModel _pagination = PaginationModel.fromJson(jsonMap);

        List<FundraiserModel> institutions = (_pagination.data as List).map((e)=> FundraiserModel.fromJson(e)).toList();

        //print("$page ${pagination==null?1:pagination.current_page}, ${schools.length}");
        if((pagination!=null?pagination.current_page??1:1) < page) {
          List<FundraiserModel> _institutions = pagination != null ? pagination
              .data ?? <FundraiserModel>[]:<FundraiserModel>[];
          _institutions.addAll(institutions);
          _pagination.data = _institutions;
        }else {
          _pagination.data = institutions;
        }
        //print("loaded page: ${_pagination.current_page} ${_pagination}");
        return _pagination;
      }on DioError catch(e){
        print("Get getNearbyFundraisers error: ${e.message}");
        rethrow;
      }
  }


  Future<Wrapper> pay(int id) async{
    try{
      Response<dynamic>? response = await RequestHandler.post(auth: user.getToken().token,
          path: "api/v1/yenepay/pay",
          request: {"id": id}
      );
      // print("$payment_code");
      // print("response: ${response?.extra['location']}");
      // return null;
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if(wrapper.success??false){
        print("checking: ${wrapper.message}");
        Map<String, dynamic> jsonMap = json.decode(jsonEncode(wrapper.data));
        String url = jsonMap['url'];
        wrapper.data = url;
        return wrapper;
      }else if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/yenepay/pay"),
            type: DioErrorType.response, error: wrapper.message );
      }
      return wrapper;
    }on DioError catch(e){
      print("POST: payment  ${e.message}");
      rethrow;
    }
  }





}