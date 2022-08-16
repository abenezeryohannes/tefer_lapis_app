import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/pages/school.page.dart';
import 'package:lapis_ui/pages/stationary.page.dart';
import 'package:lapis_ui/widgets/cards/school.stationary.distance.dart';
import 'package:map/map.screen.dart';
import 'package:util/RequestHandler.dart';
import 'package:util/Utility.dart';

import '../widgets/bottom.sheet.menu.dart';

class DriverDonationDirectionPage extends StatefulWidget {
  const DriverDonationDirectionPage(
      {Key? key,required this.donation, required this.school,  required this.fundraiser,
        required this.stationary, required this.theme, required this.tr, required this.user})
      : super(key: key);
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final UserModel user;
  final UserModel school;
  final FundraiserModel fundraiser;
  final UserModel stationary;
  final DonationModel donation;

  @override
  State<DriverDonationDirectionPage> createState() => _DriverDonationDirectionPageState();
}

class _DriverDonationDirectionPageState extends State<DriverDonationDirectionPage> {

  String current_direction = "stationary_to_school";
  late List<double> _origin;
  late List<double> _destination;
  @override
  void initState() {
     _destination = [widget.school.getLocation().latitude??0, widget.school.getLocation().longitude??0];
     _origin = [widget.stationary.getLocation().latitude??0, widget.stationary.getLocation().longitude??0];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _computeDistance();
    return Scaffold(
      backgroundColor: widget.theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: widget.theme.colorScheme.onBackground,
                          onPressed: () { Navigator.maybePop(context); } ),
                      const SizedBox(width: 6,),
                      Text(widget.tr('direction'), style: widget.theme.textTheme.bodyText1)
                    ],
                  )
                ],
              ),
            ),
          )),
      body: SafeArea(
        child: InkWell(
          onTap: () { setState(() {
            if(_bottomSheet) _bottomSheet = false;
          }); },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SchoolStationaryDistanceCard(
                      stationary: widget.stationary,
                      school: widget.school,
                      theme: widget.theme,
                      tr: widget.tr
                  ),
                ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MapScreen(
                    origin: _origin,
                    destination: _destination,
                    users: const [],
                    onMarkerClicked: _onMarkerClicked,
                    // markers: snapshot.data.data.map((e) =>
                    // [e.getLocations().latitude, e.getLocation().longitude]),
                    setPath: (org, dest){ },
                    startPosition: [widget.school.getLocation().latitude??0, widget.school.getLocation().longitude??0],),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      (widget.donation.delivery_id!=null)?(
                          (widget.donation.getDeliveries()[0].getUser().type == 'donor')?
                            widget.tr('will_be_delivered_by_', args: [widget.user.full_name??widget.tr('donor')])
                          : (widget.donation.getDeliveries()[0].getUser().type == 'school')?
                            widget.tr('will_be_delivered_by_', args: [widget.donation.getFundraiser().getUser().full_name??widget.tr('school')])
                              :
                            widget.tr('will_be_delivered_by_', args: [widget.donation.getStationary().full_name??widget.tr('stationary')])
                      ): "",
                      style: widget.theme.textTheme.subtitle2),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(!current_direction.endsWith("stationary_direction"))
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(onPressed: () {
                        setState(() {
                          current_direction = "stationary_direction";
                          _origin = [
                            widget.user.getLocation().latitude??9.0205,
                            widget.user.getLocation().longitude??38.8024
                          ];
                          _destination= [widget.stationary.getLocation().latitude??0, widget.stationary.getLocation().longitude??0];

                        });
                      },
                          child: Flexible(
                            child: Text(widget.tr('stationary_direction'),
                                style: widget.theme.textTheme.bodyText2),
                          )),
                    ),

                    if(!current_direction.endsWith("school_direction"))
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(onPressed: () {
                        setState(() {
                          current_direction = "school_direction";
                          _origin = [
                            widget.user.getLocation().latitude??9.0205,
                            widget.user.getLocation().longitude??38.8024
                          ];
                          _destination= [widget.school.getLocation().latitude??0, widget.school.getLocation().longitude??0];

                        });
                      },
                          child: Flexible(
                            child: Text(widget.tr('school_direction'),
                                style: widget.theme.textTheme.bodyText2),
                          )),
                    ),

                    if(!current_direction.endsWith("stationary_to_school"))
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(onPressed: () {
                        setState(() {
                          current_direction = "stationary_to_school";
                          _origin = [widget.stationary.getLocation().latitude??0, widget.stationary.getLocation().longitude??0];
                          _destination= [widget.school.getLocation().latitude??0, widget.school.getLocation().longitude??0];
                        });
                      },
                          child: Flexible(
                            child: Text(widget.tr('stationary_to_school'),
                                style: widget.theme.textTheme.bodyText2),
                          )),
                    )
                  ],
                )


                ],
              ),
            ],
          ),
        )
      )
    );
  }


  bool _bottomSheet = false;
  double distanceFromSchoolToStationary = 0;

  void _computeDistance(){
    distanceFromSchoolToStationary = Utility.calculateDistance(
        widget.donation.getFundraiser().getUser().getLocation().latitude,
        widget.donation.getFundraiser().getUser().getLocation().longitude,
        widget.donation.getStationary().getLocation().latitude,
        widget.donation.getStationary().getLocation().longitude );
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

}
