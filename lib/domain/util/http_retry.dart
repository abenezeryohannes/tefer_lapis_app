// import 'dart:io';
//
// import 'package:http/http.dart' as http;
// import 'package:connectivity_plus/connectivity_plus.dart';
//
//
// class HttpRetry{
//     static const String baseUrl = "http://localhost:3000/api/v1";
//     static const String releaseBaseUrl = "https://lapis.tefer.com/";
//     static const String termsBaseUrl = "https://lapis.tefer.com/";
//
//
//
//     static bool debugMode = true;
//     // static final String baseUrl = "http://192.168.137.1/ShimmerWeb/public/api/";
//     static const int totalRetry = 5;
//     static const int timeOut = 5;
//     int retry = 0;
//
//     HttpRetry() {
//
//       retry  = 0;}
//
//      Future<http.Response?> get(String path) async{
//           http.Response? response;
//
//           retry = 0;
//           for(;retry<=totalRetry;){
//                     if(retry>1) {
//                       var connectivityResult = await (Connectivity().checkConnectivity());
//                       if (connectivityResult == ConnectivityResult.none&& !debugMode) {
//                           sleep(const Duration(seconds: 5));
//                           continue;
//                       }
//                     }
//                     response = await http.get(Uri.parse(path)).then((onValue){
//                                             return onValue;
//                                       }).catchError((onError){
//                                           if(retry<=totalRetry) return null;
//                                           print(path + " error: "+onError+"\n retrying ("+retry.toString()+" out of "+totalRetry.toString()+")... ");
//                                       }).timeout(const Duration(seconds: timeOut), onTimeout: (){
//                                           if(retry<=totalRetry)
//                                           print(path + " timeout \n retrying ("+retry.toString()+" out of "+totalRetry.toString()+")... ");
//                                           return null;
//                                       });
//                         retry++;
//                         if(response == null) {continue;}
//                         if( response.statusCode == 200) break;
//                     }
//           return response;
//     }
//
//      Future<http.Response?> post(String path, {Map<String, String> body, headers}) async{
//          http.Response? response;
//          retry = 0;
//         for(;retry<=totalRetry;){
//           if(retry>1) {
//             var connectivityResult = await (Connectivity().checkConnectivity());
//             if (connectivityResult == ConnectivityResult.none && !debugMode) {
//                 sleep(const Duration(seconds: 5));
//                 continue;
//             }
//           }
//           response = await http.post( Uri.parse(path), body:body, headers:headers).then((onValue){
//                                   return onValue;
//                             }).catchError((onError){
//                                 if(retry<=totalRetry) return;
//                                 print(path + " body: "+body.toString()+ " error: "+onError+"\n retrying ("+retry.toString()+" out of "+totalRetry.toString()+")... ");
//                             }).timeout(const Duration(seconds: timeOut), onTimeout: (){
//                                 if(retry<=totalRetry)
//                                 print(path + " body: "+body.toString()+ " timeout \n retrying ("+retry.toString()+" out of "+totalRetry.toString()+")... ");
//                                 return null;
//                             });
//               retry++;
//               if(response == null) {continue;}
//               if( response.statusCode == 200) break;
//           }
//           return response;
//     }
//
// }