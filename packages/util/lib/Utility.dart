import 'dart:math' as Math;
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class Utility{

  static calculateDistance(double? lat1 ,double? lon1,double? lat2,double? lon2, {unit = "k"})
  {
      var R = 6371;
      double dLat = toRad((lat2??0)-(lat1??0));
      double dLon = toRad((lon2??0)-(lon1??0));
      lat1 = toRad((lat1??0));
      lat2 = toRad((lat2??0));

      var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
      Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos((lat1??0)) * Math.cos((lat2??0));
      var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
      var d = R * c;
      switch(unit.toLowerCase()){
        case "k": return d;
        case "m": return d/1000;
    }
  }

  static String formatError(DioError e, {required Function(String, {List<String> args}) tr}){
    if(e.type == DioErrorType.receiveTimeout || e.type == DioErrorType.connectTimeout || e.type == DioErrorType.sendTimeout){
      return tr('connection_error');
    }else if(e.type == DioErrorType.response){
        return (e.response!=null)?e.response?.data['message']:e.message;
    }else if(e.type == DioErrorType.other){
      if(e.error!=null&&e.error.message.toString().contains("host lookup")){
        return tr('connection_error');
      }else {
        return tr(e.error!=null?e.error.message:'something_went_wrong_try_again_letter');
      }
    }else {
        return tr('something_went_wrong_try_again_letter');
    }
  }



  static String format(String numberString, bool allowZero) {
    final oCcy = NumberFormat("#,##0.00", "en_US");
    double number = double.tryParse(numberString)??0;
    if(number==0&&!allowZero) return '-';
    // String resp = n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
    return oCcy.format(number);
  }


  // Converts numeric degrees to radians
  static toRad(double? Value) { return (Value??0) * Math.pi / 180; }

  static calculateDriveMinute(double? latitude, double? longitude, double? latitude2, double? longitude2) { return 30; }

  static shorten({String? text, int max = 12}){
    if(text!=null){
      return '${text.substring(0, text.length>max? max : text.length)} ${text.length>max?'...':''}' ;
    } return '';
  }

  static String getTimesLeft({required Function(String, {List<String> args}) tr,
              required DateTime time_start, required DateTime against}){
      int hours = 1;int minutes =-1; int days = -1;
      days = time_start.difference(against).inDays;
      hours = time_start.difference(against).inHours;
      minutes = time_start.difference(against).inMinutes;

      if(minutes<0){ return '';
      }else{
        if(days>0){
          return tr('day_hour_minute', args: [days.toString(), (hours%(days*24)).toString(), (minutes%(hours*60)).toString()]);
        }else if(hours > 0){
          return tr('hour_minute', args: [ hours.toString(), (minutes%(hours*60)).toString()]);
        }else{ return tr('minute_only', args: [minutes.toString()]); }
      }
    }



  static String showDateSmall({required Function(String, {List<String> args}) tr,
    required DateTime time}){
    int hours = 1;int minutes =-1; int days = -1;
    days = time.difference(DateTime.now()).inDays;
    hours = time.difference(DateTime.now()).inHours;
    minutes = time.difference(DateTime.now()).inMinutes;
    days = (days<0)?days*-1:days;
    minutes = (minutes<0)?minutes*-1:minutes;
    hours = (hours<0)?hours*-1:hours;
    String format = "yyyy-MM-dd";
    if(days > 365){
      format = "yyyy-MM-dd";
    }else if (days > 30){
      format = "mm-dd";
    }else if(days > 7){
      format = "dd HH-mm";
    }else {
      format = "HH-mm-ss";
    }
    final DateFormat formatter = DateFormat(format);
    final String formatted = formatter.format(time);
    return formatted;
  }

}