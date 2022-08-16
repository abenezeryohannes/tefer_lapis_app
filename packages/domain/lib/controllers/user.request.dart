

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:domain/models/location.model.dart';
import 'package:domain/models/moreinfo.model.dart';
import 'package:domain/models/token.model.dart';
import 'package:util/RequestHandler.dart';

import '../models/user.model.dart';
import '../models/wrapper.dart';
import 'package:http_parser/http_parser.dart';

class UserRequest{

  UserModel user;
  UserRequest(this.user);
  
  Future<Wrapper> getUser(id) async{
    try{
      Response<dynamic>? response = await RequestHandler.get(auth: user.getToken().token, path: "api/v1/user/get");
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));

      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if(wrapper.success??false){
        jsonMap = json.decode(jsonEncode(wrapper.data));
        wrapper.data = UserModel.fromJson(jsonMap);
      }else if (wrapper.success == false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/user/$id"),
            type: DioErrorType.response, error: wrapper.message );
      }
      return wrapper;
    }on DioError catch(e){
      print("GET getUser error: ${e.message}");
      rethrow;
    }
  }

  Future<Wrapper> loginUser(String uuid) async{
    try{
      Response<dynamic>? response = await RequestHandler.post(auth: null, path: "api/v1/user/login",
         request: {"uuid": uuid} );

      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if(wrapper.success??false){
        jsonMap = json.decode(jsonEncode(wrapper.data));
        wrapper.data = UserModel.fromJson(jsonMap);
      }else if (wrapper.success == false){
      // handle error here
      throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/user/login"),
      type: DioErrorType.response, error: wrapper.message );
    }
      return wrapper;
    }on DioError catch(e){
      print("POST Login error: ${e.message}");
      rethrow;
    }
  }

  Future<Wrapper> signupUser(request) async{
    try{
      Response<dynamic>? response = await RequestHandler.post(auth: null, path: "api/v1/user/signup",
          request: {
            "full_name": request["full_name"],
            "phone_number": request["phoneNumber"],
            "email_address": request["email"],
            "type": "donor",
            "uuid": request["uid"],
          } );

      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if(wrapper.success??false){
        jsonMap = json.decode(jsonEncode(wrapper.data));
        wrapper.data = UserModel.fromJson(jsonMap);
      }else if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/user/signup"),
            type: DioErrorType.response, error: wrapper.message );
      }
      return wrapper;
    }on DioError catch(e){
      print("POST signup error: ${e.message}");
      rethrow;
    }
  }

  Future<Wrapper> editUser({required  UserModel user}) async{
    String path = "api/v1/user/edit";
    try{
      Response<dynamic>? response = await RequestHandler.post(auth: user.getToken().token, path: "api/v1/user/edit",
          request: jsonEncode(user) );

      print("response; $response");
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if(wrapper.success??false){
        print("checking: ${wrapper.data}");
        jsonMap = json.decode(jsonEncode(wrapper.data));
        wrapper.data = UserModel.fromJson(jsonMap);
      }else if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ path),
            type: DioErrorType.response, error: wrapper.message );
      }
      return wrapper;
    }on DioError catch(e){
      print("POSt editUser error: ${e.message}");
      rethrow;
    }
  }


  Future<UserModel?> uploadProfileImage(File? file) async {
    String path = RequestHandler.baseUrl + "api/v1/user/edit" ;
    try {
      if(file == null) throw "file is null";

      String fileName = file.path
          .split('/')
          .last;

      FormData data = FormData.fromMap({
        "avatar": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          //contentType: MediaType("image", (fileName.contains("png"))?"png":"jpeg"),
        ),
        //"type": "image/jpg"
      });

      Dio dio = Dio();
      dio.options.headers["Authorization"] = "${user.getToken().token}";
      dio.options.headers["authorization"] = "${user.getToken().token}";
      Response response = await dio.post(path, data: data,
          options: Options(
              headers: {
                "accept": "*/*",
                "Authorization": "${user.getToken().token}"
              }
          ));

      //

      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if(wrapper.success??false){
        jsonMap = json.decode(jsonEncode(wrapper.data));
        wrapper.data = UserModel.fromJson(jsonMap);
        return wrapper.data;
      }else if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: path),
                type: DioErrorType.response, error: wrapper.message );
      }
      return null;
      // .then((response) => print(response))
      // .catchError((error) => print(error));
    }on DioError catch(e){
      print("uploading error: ${e.toString()}");
      rethrow;
    }
  }

  Future<bool?> logOutUser() async{
    try{
      Response<dynamic>? response = await RequestHandler.post(auth: null, path: "api/v1/user/logout",
          request: {"token": user.getToken().token} );

      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if(wrapper.success??false){
        return true;
      }else if (wrapper.success == false){
        return true;
        // handle error here
        // throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ "api/v1/user/login"),
        //     type: DioErrorType.response, error: wrapper.message );
      }
      return true;
    }on DioError catch(e){
      print("POST Login error: ${e.message}");
      rethrow;
    }
  }

  Future<Wrapper> updateDeviceToken(String? device_token) async{
    String path = "api/v1/user/edit";
    if(user.Token!=null){
      user.Token!.device_token = device_token;
    }
    try{
      Response<dynamic>? response = await RequestHandler.post(auth: user.getToken().token, path: "api/v1/user/edit",
          request: jsonEncode(user) );

      print("response; $response");
      Map<String, dynamic> jsonMap = json.decode(jsonEncode(response?.data));
      Wrapper wrapper = Wrapper.fromJson(jsonMap);
      if(wrapper.success??false){
        print("checking: ${wrapper.data}");
        jsonMap = json.decode(jsonEncode(wrapper.data));
        wrapper.data = UserModel.fromJson(jsonMap);
      }else if (wrapper.success = false){
        // handle error here
        throw DioError( requestOptions: RequestOptions(path: RequestHandler.baseUrl+ path),
            type: DioErrorType.response, error: wrapper.message );
      }
      return wrapper;
    }on DioError catch(e){
      print("POSt editUser error: ${e.message}");
      rethrow;
    }
  }

}