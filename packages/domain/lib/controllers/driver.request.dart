
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:domain/models/donor.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/stationary.item.model.dart';
import 'package:domain/models/stationary.model.dart';
import 'package:domain/models/subscription.model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:util/RequestHandler.dart';

import '../models/activity.model.dart';
import '../models/delivery.model.dart';
import '../models/donation.model.dart';
import '../models/post.model.dart';
import '../models/user.model.dart';
import '../models/wrapper.dart';

class DriverRequest{

  UserModel user;
  DriverRequest(this.user);

  Future<PaginationModel?> getSubscribedDonations({PaginationModel? pagination, int page=1,String? search,
    int limit = 25 , String? sort_by}) async{
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token,
          path: "api/v1/driver/list_subscribed_donations", query: {
          'search':search, 'page': page, 'limit': limit,
      });
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
      }else { _pagination.data = donations; }
      //print("loaded page: ${_pagination.current_page} ${_pagination}");
      return _pagination;
    }on DioError catch(e){ print("GET subs donations error: ${e.message}"); rethrow; }
  }

  Future<PaginationModel?> getDonations({PaginationModel? pagination, int page=1,String? search,
    int limit = 25 , String? sort_by}) async{
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/driver/donations", query: {
        'search':search, 'page': page, 'limit': limit, 'sort_by': sort_by
      });
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
    }on DioError catch(e){
      print("GET donations error: ${e.message}");
      rethrow;
    }
  }


  Future<PaginationModel?> getDeliveries({PaginationModel? pagination, int page=1,String? search, int limit = 25 }) async{
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/driver/deliveries", query: {
        'search':search, 'page': page, 'limit': limit
      });
      //print("response: $response");

      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      PaginationModel _pagination = PaginationModel.fromJson(jsonMap);

      List<DeliveryModel> deliveries = (_pagination.data as List).map((e)=> DeliveryModel.fromJson(e)).toList();

      //print("$page ${pagination==null?1:pagination.current_page}, ${deliveries.length}");
      if((pagination!=null?pagination.current_page??1:1) < page) {
        List<DeliveryModel> _deliveries = pagination != null ? pagination
            .data ?? <DeliveryModel>[]:<DeliveryModel>[];
        _deliveries.addAll(deliveries);
        _pagination.data = _deliveries;
      }else {
        _pagination.data = deliveries;
      }
      //print("loaded page: ${_pagination.current_page} ${_pagination}");
      return _pagination;
    }on DioError catch(e){
      print("GET deliveries error: ${e.message}");
      rethrow;
    }
  }

  Future<Wrapper> assignDriver({required int id}) async{
      try{
        Response<dynamic>? response = await RequestHandler.post(
            auth: user.getToken().token, path: "api/v1/driver/assign_deliverer", request: { "id" : id }
        );
        Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
        Wrapper wrapper = Wrapper.fromJson(jsonMap);
        if(wrapper.success??false){
          print("checking: ${wrapper.data}");
          jsonMap = json.decode(jsonEncode(wrapper.data));
          wrapper.data = DonationModel.fromJson(jsonMap);
        }else if (wrapper.success = false){
          // handle error here
          throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/driver/assign_deliverer"),
              type: DioErrorType.response, error: wrapper.message );
        }
        print("wrapper $wrapper");
        return wrapper;
      }on DioError catch(e){
        print("POST assign driver error: ${e.message}");
        rethrow;
      }
  }

  Future<Wrapper> stat() async{
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/driver/stat");
      Map<String, dynamic> jsonMap = (response?.data);
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      print("wrapper stat $wrapper");
      //Map<dynamic,dynamic> json = jsonDecode(wrapper.data);
      //wrapper.data = json;
    if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/driver/assign_deliverer"),
        type: DioErrorType.response, error: wrapper.message );
      }
      return wrapper;
    }catch(e){
      print("error: ${e.toString()}");
      return Wrapper.fresh(success: false, message: e.toString());
    }
  }


  Future<Wrapper?> getDonation(int id) async{
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/driver/donation/$id");
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if(wrapper.success??false){
        print("checking: ${wrapper.data}");
        jsonMap = json.decode(jsonEncode(wrapper.data));
        wrapper.data = DonationModel.fromJson(jsonMap);
      } else if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/driver/donation"),
            type: DioErrorType.response, error: wrapper.message );
      }
      return wrapper;
    }on DioError catch(e){
      print("GET donation error: ${e.message}");
      rethrow;
    }
  }


  Future<Wrapper> updateDelivery({required DeliveryModel delivery}) async{
    print("donationItems: $delivery");
    try{
      Response<dynamic>? response = await RequestHandler.post(auth: user.getToken().token, path: "api/v1/driver/update_delivery/${delivery.id}",
          request: jsonEncode(delivery) );

      Map<String, dynamic> jsonMap = (response?.data);
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if (wrapper.success==null || wrapper.success == false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/driver/update_delivery/${delivery.id}"),
            type: DioErrorType.response, error: wrapper.message );
      }
      return wrapper;
    }on DioError catch(e){
      print("POST error: ${e.message}");
      rethrow;
      // return Wrapper.fresh(success: false, message: e.message);
    }
  }




















  Future<SubscriptionModel?> subscribe({required int user_id, required int school_id}) async{
    try{
      Response<dynamic>? response = await RequestHandler.post(auth: user.getToken().token, path: "api/v1/driver/subscribe",
          request: { 'school_id':school_id}
      );
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);

      if(wrapper.success??false){
        jsonMap = json.decode(jsonEncode(wrapper.data));
        return SubscriptionModel.fromJson(jsonMap);
      }else if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/driver/subscribe"),
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
      Response<dynamic>? response = await RequestHandler.post(auth: user.getToken().token, path: "api/v1/driver/unsubscribe",
          request: { 'school_id':school_id}
      );
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);

      print("unsubscribe wrapper $wrapper");
      if(wrapper.success??false){
        return true;
      }else if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/driver/subscribe"),
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
      Response<dynamic>? response = await RequestHandler.post(auth: user.getToken().token, path: "api/v1/driver/is_subscribed",
          request: {'school_id':school_id}
      );
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);

      print("wrapper: $wrapper");
      if(wrapper.success??false){
        return wrapper.data as bool;
      }else if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/driver/is_subscribed"),
            type: DioErrorType.response, error: wrapper.message );
      }
      return null;
    }on DioError catch(e){
      print("POST is_subscribed error: ${e.message}");
      rethrow;
    }
  }
}