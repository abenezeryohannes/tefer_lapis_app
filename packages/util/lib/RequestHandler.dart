import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class RequestHandler{
  //https://tefer-lapis.herokuapp.com
  //http://192.168.40.54:5000/
  static const String baseUrl = "https://tefer-lapis.herokuapp.com/";
  static const String baseImageUrl = "${baseUrl}api/v1/media?path=";
  // static const String releaseBaseUrl = "https://tefer-lapis.herokuapp.com/";
  // static const String termsBaseUrl = "https://tefer-lapis.herokuapp.com/";
  //map
  static const String mapBaseUrl = "https://maps.googleapis.com/maps/api/directions/json?";

  static Future<Response<dynamic>?> get({required path, header, query, required auth}) async {
    try {
      var dio = Dio();
      // Add the interceptor
      if(dio.interceptors.isNotEmpty){ dio.interceptors.removeRange( 0, dio.interceptors.length ); }
      if(dio.interceptors.isEmpty) {
        dio.interceptors.add(RetryInterceptor(
          dio: dio,
          logPrint: print, // specify log function (optional)
          retries: 1, // retry count (optional)
          retryDelays: const [ // set delays between retries (optional)
            Duration(seconds: 3), // wait 1 sec before first retry
            //Duration(seconds: 1), // wait 2 sec before second retry
            // Duration(seconds: 5), // wait 5 sec before third retry
          ],
        ));
      }
      //404
      print("uri: ${Uri.parse(baseUrl + path).toString()} interceptors: ${dio.interceptors.length}");

      dio.options.connectTimeout = 3000;
      dio.options.receiveTimeout = 3000;
      dio.options.sendTimeout = 3000;
      dio.options.headers["Authorization"] = "$auth";
      // dio.options.headers["authorization"] = "$auth";

      return await dio.get(Uri.parse(baseUrl + path).toString(),
          queryParameters: query, options: Options(
            headers: {"accept" : "application/json","content-type" : "application/json;charset=UTF-8"},
          receiveTimeout: 3000,
          // sendTimeout: 5000,
      ));
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response!.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print("type: ${e.type}");
        print("error: ${e.error}");
        print("message; ${e.message}");
      }
      rethrow;
    }
  }
  static Future<Response<dynamic>?> getRaw({required path, header, query, required auth}) async {
    try {
      var dio = Dio();
      // Add the interceptor
      if (dio.interceptors.length > 1) {
        dio.interceptors.removeRange(0, dio.interceptors.length);
      }
      else if (dio.interceptors.isEmpty) {
        dio.interceptors.add(
            RetryInterceptor(
                dio: dio,
                logPrint: print, // specify log function (optional)
                retries: 1, // retry count (optional)
                retryDelays: const [ // set delays between retries (optional)
                   Duration(seconds: 1), // wait 1 sec before first retry
              ], )
        );
      }
      //404
      print("uri: ${Uri.parse(path).toString()}");

      dio.options.headers["Authorization"] = "$auth";
      dio.options.headers["authorization"] = "$auth";
      return await dio.get(Uri.parse(path).toString(), queryParameters: query, options: Options(
        receiveTimeout: 5000
      ));
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response!.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
      ;
    }
  }




  static Future<Response<dynamic>?> post({required path, header, request, required auth}) async {
    try {
      var dio = Dio();
      // Add the interceptor
      if(dio.interceptors.length>1){ dio.interceptors.removeRange( 0, dio.interceptors.length ); }
      else if(dio.interceptors.isEmpty) {
        dio.interceptors.add(RetryInterceptor(
          dio: dio,
          logPrint: print, // specify log function (optional)
          retries: 1, // retry count (optional)
          retryDelays: const [ // set delays between retries (optional)
            Duration(seconds: 3), // wait 1 sec before first retry
            //Duration(seconds: 1), // wait 2 sec before second retry
            //Duration(seconds: 1), // wait 5 sec before third retry
          ],
        ));
      }
      //404
      //print("dio: request ${request}");

      dio.options.headers["Authorization"] = "$auth";
      dio.options.headers["authorization"] = "$auth";
      dio.options.followRedirects = true;
      dio.options.connectTimeout = 3000;
      dio.options.receiveTimeout = 3000;
      dio.options.sendTimeout = 3000;
      return await dio.post(Uri.parse(baseUrl + path).toString(),
        data: request, );
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        rethrow;
        //print(e.response!.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.requestOptions);
        print('error: ${e.message}');
        rethrow;
      }
    }
  }
}