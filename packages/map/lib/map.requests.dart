
import 'package:domain/models/user.model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/config/config.dart';
import 'package:util/RequestHandler.dart';

import 'models/directions.model.dart';

class MapRequests{
  UserModel user;
  MapRequests(this.user);

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await RequestHandler.getRaw(
      path: RequestHandler.mapBaseUrl,
      auth: null,
      query: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': Config.AndroidMAPAPI,
      },
    );

    //print('response ${response}');

    // Check if response is successful
    if (response!=null&&response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }


  Future<List<String>> getDistanceAndDuration({
    required List<double> origin,
    required List<double> destination,
  }) async {
    print("request: $origin, $destination");
    final response = await RequestHandler.getRaw(
      path: RequestHandler.mapBaseUrl,
      auth: null,
      query: {
        'origin': '${origin[0]},${origin[1]}',
        'destination': '${destination[0]},${destination[1]}',
        'key': Config.AndroidMAPAPI,
      },
    );

    print('response ${response}');
    Directions directions;
    // Check if response is successful
    if (response!=null&&response.statusCode == 200) {
       directions = Directions.fromMap(response.data);
       return [directions.totalDistance, directions.totalDuration];
    }
    return ["unknown_distance", "unknown_duration"];
  }

}