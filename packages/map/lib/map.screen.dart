import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/map.requests.dart';
import 'package:domain/models/user.model.dart';

import 'models/directions.model.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({Key? key,
    required this.origin,
    required this.destination,
    required this.setPath,
    required this.users,
    required this.onMarkerClicked,
    required this.startPosition,
  }) : super(key: key);

  final List<double> origin;
  final List<double> startPosition;
  final List<double> destination;
  final List<UserModel> users;
  final Function(List<double>, List<double>) setPath;
  final Function(UserModel) onMarkerClicked;

  @override
  State<MapScreen> createState() => _GlobePageState();
}

class _GlobePageState extends State<MapScreen> {

  late GoogleMapController _googleMapController;
  Marker? _origin = null;
  Marker? _destination = null;
   Directions? _info;
  Set<Marker> _markers = {};

  static var _initialCameraPosition = const CameraPosition(
      target: LatLng(37.773972, -122.431293),
      zoom: 1.5
  );

  @override
  void initState() {
    _initialCameraPosition = CameraPosition(
        target: (widget.startPosition.length==2)?
        LatLng(
            widget.startPosition[0],
            widget.startPosition[1]):
        const LatLng(37.773972, -122.431297),
        zoom: 11.5,
    );

    _setDirectionIfAny();
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print("info ${(_info?.polylinePoints)}");
    if((_origin==null&&widget.origin.length==2)||(_destination==null&&widget.destination.length==2) ||
        (_origin!=null&&widget.origin.length==2&&(_origin?.position.latitude!=widget.origin[0]||_origin?.position.longitude!=widget.origin[1])) ||
        (_destination!=null&&widget.destination.length==2&&(_destination?.position.latitude!=widget.destination[0]||_destination?.position.longitude!=widget.destination[1]))
    ){ _setDirectionIfAny(); }

    if(widget.users.isNotEmpty){
      _markers.clear();
      widget.users.forEach((user) {
        _markers.add(Marker(
            markerId: MarkerId((user.full_name??'')),
            infoWindow: InfoWindow(title: user.full_name??''),
            icon: BitmapDescriptor.defaultMarkerWithHue((user.type=='school')
                    ?BitmapDescriptor.hueBlue:BitmapDescriptor.hueViolet),
            position: LatLng( user.getLocation().latitude??0,  user.getLocation().longitude??0 ),
          onTap: (){
              widget.onMarkerClicked(user);
          }
        ));
      });
    }
    return Stack(
      alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: (_markers.isEmpty)?{
              if (_origin!=null) _origin!,
              if (_destination!=null) _destination!,
            }: _markers,
            onTap: _onTap,
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points:  (_info?.polylinePoints)!
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            onLongPress: _addMarker,
          ),


          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  '${_info?.totalDistance}, ${_info?.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

           Align(
             alignment: Alignment.bottomRight,
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.black,
                onPressed: (){
                  _googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(_initialCameraPosition),
                  );
                },
                child: const Icon(Icons.center_focus_strong),
          ),
             ),
           ),
        ],
      );
  }

  _onTap(LatLng pos){ }

  _addMarker(LatLng pos) async{
      if(_origin == null || (_origin!=null && _destination != null)){
        setState(() {
          _origin =
              Marker(
                  markerId: MarkerId('origin'),
                  infoWindow: const InfoWindow(title: 'Origin'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                  position: pos
              );
          _destination = null;
          _info = null;
        });

      }else {
        setState(() {
          _destination =
              Marker(
                  markerId: const MarkerId('destination'),
                  infoWindow: const InfoWindow(title: 'Destination'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                  position: pos
              );
        });
        //
        // widget.setPath(
        //     (_origin != null) ? [
        //       _origin!.position.latitude,
        //       _origin!.position.longitude
        //     ] : [],
        //     (_destination != null) ? [
        //       _destination!.position.latitude,
        //       _destination!.position.longitude
        //     ] : []);

        if (_origin != null && _destination != null) {
          final directions = await MapRequests(UserModel.fresh())
              .getDirections(
              origin: (_origin?.position)!,
              destination: (_destination?.position)!);
          setState(() => _info = directions);
        }
      }

  }


  _setDirectionIfAny() async{
    if (widget.origin.length == 2) {
      if(mounted) {
        setState(() {
        _origin = Marker(
            markerId: const MarkerId('origin'),
            infoWindow: const InfoWindow(title: 'Origin'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            position: LatLng( widget.origin[0], widget.origin[1] )
        );

        // Reset info
        _info = null;
        _destination = null;
      });
      }
    }
    if ( widget.destination.length == 2 ) {
      if(mounted) {
        setState(() {
          _destination = Marker(
              markerId: const MarkerId('destination'),
              infoWindow: const InfoWindow(title: 'Destination'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              position: LatLng(widget.destination[0], widget.destination[1])
          );
        });
      }
        if(_origin!=null && _destination!=null) {
          final directions = await MapRequests(UserModel.fresh())
              .getDirections( origin: (_origin?.position)!, destination: (_destination?.position)! );
          //if(_info!=null) print("polylines: ${_info?.polylinePoints}");
          setState(() => _info = directions);
        }
      }
    }

}

  


