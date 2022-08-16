import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'dart:core';

import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/intro/donation.page.intro.dart';
import 'package:lapis_ui/widgets/cards/donation.card.dart';
import 'package:lapis_ui/widgets/cards/school.card.dart';
import 'package:map/map.screen.dart';

import '../../pages/school.page.dart';
import '../../pages/stationary.page.dart';
import '../../widgets/lazy.listview.dart';
import '../../widgets/list.view.error.dart';

class MapNavigatorFragment extends StatefulWidget {
  const MapNavigatorFragment({Key? key,
    required this.theme, required this.tr,required this.search, required this.user}) : super(key: key);

  final ThemeData theme;
  final String search;
  final UserModel user;
  final String Function(String, {List<String> args}) tr;
  // final Function(String) onChanged;

  @override
  State<MapNavigatorFragment> createState() => _MapNavigatorFragmentState();
}

class _MapNavigatorFragmentState extends State<MapNavigatorFragment> {

   List<double> origin = [];
   List<double> destination = [];
   late Future<PaginationModel?> _near_by;
   String _search ="";


   @override
  void initState() {
    origin = [widget.user.getLocation().latitude??0, widget.user.getLocation().longitude??0];
    _load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(_search!=widget.search){_search=widget.search; _load();}
    return FutureBuilder<dynamic>(
        future: _near_by,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //print('data: ${snapshot.data.data.map((e) => [e.getLocation().latitude, e.getLocation().longitude])}');
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MapScreen(
                  origin: const [], destination: const [],
                  users: snapshot.data.data,
                  onMarkerClicked: _onMarkerClicked,
                  // markers: snapshot.data.data.map((e) =>
                  // [e.getLocations().latitude, e.getLocation().longitude]),
                  setPath: (org, dest){
                    setState(() {
                      origin = org; destination = dest;
                    });
                  }, startPosition: const [8.9806, 38.7578],),
              ),
            );
          } else if (snapshot.hasError) {
            return ListViewError(tr: widget.tr, error: snapshot.error??{"message": "unknown Error"},
                theme: widget.theme, onRetry: _load);
          }
          // By default, show a loading spinner.
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }
    );
  }

  _onMarkerClicked(UserModel user){
    if(user.type == 'school'){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SchoolPage(
          theme: widget.theme, user: widget.user, tr: widget.tr, school: user
      ) ));
    }else if(user.type == 'stationary'){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => StationaryPage(tr: widget.tr, theme: widget.theme,
        user: widget.user, stationary: user,) ));

    }
  }

   void _load() {
     _near_by = DonorRequest(widget.user).nearBy(
        type: null,
         search: widget.search,
         latitude: widget.user.getLocation().latitude??0,
         longitude: widget.user.getLocation().longitude??0);
   }

}

