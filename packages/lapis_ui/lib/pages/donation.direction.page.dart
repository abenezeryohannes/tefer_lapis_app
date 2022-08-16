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

class DonationDirectionPage extends StatefulWidget {
  const DonationDirectionPage(
      {Key? key,required this.donation, required this.school,required this.stationary,
        required this.theme, required this.tr, required this.user,required this.onDonationChanged})
      : super(key: key);
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final void Function(DonationModel) onDonationChanged;
  final UserModel user;
  final UserModel school;
  final UserModel stationary;
  final DonationModel donation;

  @override
  State<DonationDirectionPage> createState() => _DonationDirectionPageState();
}

class _DonationDirectionPageState extends State<DonationDirectionPage> {
  late DonationModel _donation;
  @override
  void initState() {
    _donation = widget.donation;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _computeDistance();
    print("donation after: ${_donation.toString()}");
    return Scaffold(
      backgroundColor: widget.theme.scaffoldBackgroundColor,
      bottomSheet: _showBottomSheet(),
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
                    destination: [widget.school.getLocation().latitude??0, widget.school.getLocation().longitude??0],
                    origin: [widget.stationary.getLocation().latitude??0, widget.stationary.getLocation().longitude??0],
                    users: const [],
                    onMarkerClicked: _onMarkerClicked,
                    // markers: snapshot.data.data.map((e) =>
                    // [e.getLocations().latitude, e.getLocation().longitude]),
                    setPath: (org, dest){ },
                    startPosition: [widget.school.getLocation().latitude??0, widget.school.getLocation().longitude??0],),
                ),
              ),
              Column(
                children: [
                  Text(
                      (_donation.delivery_id!=null)?(
                          (_donation.getDeliveries()[0].getUser().type == 'donor')?
                            widget.tr('will_be_delivered_by_', args: [widget.user.full_name??widget.tr('donor')])
                          :
                          (_donation.getDeliveries()[0].getUser().type == 'school')?
                            widget.tr('will_be_delivered_by_', args: [_donation.getFundraiser().getUser().full_name??widget.tr('school')])
                              :
                            widget.tr('will_be_delivered_by_', args: [_donation.getStationary().full_name??widget.tr('stationary')])
                      ): "",
                      style: widget.theme.textTheme.subtitle2),


                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(onPressed: () {
                    setState(() {_bottomSheet = true;});
                  },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 2),
                        child: Text(
                            (_donation.delivery_id!=null)? widget.tr('change_who_will_deliver')
                            : widget.tr('set_delivery_person'),
                            style: widget.theme.textTheme.bodyText2),
                      )),
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
  Widget? _showBottomSheet(){
    if(!_bottomSheet) return null;
    // print("distanc: $distanceFromSchoolToStationary");
    return BottomSheetMenu(
      theme: widget.theme,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 8,
                    child: Text(widget.tr('who_would_u_like_to_deliver'),
                      style: TextStyle(color: widget.theme.colorScheme.onBackground, fontSize: 18, fontWeight: FontWeight.bold),)),
                Flexible( flex: 2,
                  child: Image.asset( 'assets/icons/delivery.png',
                    fit: BoxFit.fill, height: 26,),
                ),

              ],
            ),
            const SizedBox(width: 10,),
            //user
            if(_donation.delivery_id==null || ((_donation.getDeliveries()[0].user_id??-1) != widget.user.id) )
            InkWell(
              onTap: () { _confirm(context, _assignDriver, widget.user.id??0);},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16.0,
                      backgroundImage: NetworkImage( RequestHandler.baseImageUrl+(widget.user.avatar??'')),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(width: 10,),
                    Flexible(
                        child: Text('${widget.user.full_name}',
                          style: widget.theme.textTheme.subtitle2,)
                    ),
                  ],
                ),
              ),
            ),
            //school
            if (_checkIfSchoolCanPick()) InkWell(
              onTap: () { _confirm(context, _assignDriver, _donation.getFundraiser().getUser().id??0);},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 16.0,
                      backgroundImage: NetworkImage( RequestHandler.baseImageUrl+(widget.school.avatar??'')),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(width: 10,),

                    Flexible(
                      child: Text(widget.tr('let_school_pick_it_up', args: ['${_donation.getFundraiser().getUser().full_name}']),
                        style: widget.theme.textTheme.subtitle2,),
                    ),
                  ],
                ),
              ),
            )  ,
            //stationary
            if (_checkIfStationaryCanPick()) InkWell(
              onTap: () { _confirm(context, _assignDriver, _donation.getStationary().id??0);},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 16.0,
                      backgroundImage: NetworkImage( RequestHandler.baseImageUrl+(widget.stationary.avatar??'')),
                      backgroundColor: Colors.transparent,
                    ),

                    const SizedBox(width: 10,),

                    Flexible(
                      child: Text(widget.tr('let_stationary_deliver', args: ['${_donation.getStationary().full_name}']),
                        style: widget.theme.textTheme.subtitle2,),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

  }


  bool _checkIfSchoolCanPick(){
    return ((_donation.delivery_id==null ||
        ((_donation.getDeliveries()[0].user_id??-1) != _donation.getFundraiser().getUser().id) )
        && ((_donation.getFundraiser().getUser().getSchool().minimum_distance??0) > distanceFromSchoolToStationary));
  }

  bool _checkIfStationaryCanPick(){
    return ((_donation.delivery_id==null ||
        (_donation.getDeliveries().isNotEmpty &&
            _donation.getDeliveries()[0].user_id != _donation.getStationary().id
            ) )
        && ((_donation.getStationary().getSchool().minimum_distance??0) > distanceFromSchoolToStationary));
  }

  void _computeDistance(){
    distanceFromSchoolToStationary = Utility.calculateDistance(
        _donation.getFundraiser().getUser().getLocation().latitude,
        _donation.getFundraiser().getUser().getLocation().longitude,
        _donation.getStationary().getLocation().latitude,
        _donation.getStationary().getLocation().longitude );
  }

  void _confirm(BuildContext context, Function onClick, int id){

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(widget.tr("are_you_sure")),
            content: Text(widget.tr("warning_on_setting_driver")),
            actionsOverflowButtonSpacing: 20,
            actions: [
              TextButton(
                  onPressed: () async{
                    onClick(id);
                    Navigator.of(context).pop();
                  },
                  child: Text(widget.tr("yes"))),
            ],
            backgroundColor: widget.theme.cardColor,
            shape: const RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(20))),
          );
        });
  }

  _assignDriver(int id) async{
      Wrapper? wrapper = await DonorRequest(widget.user).assignDriver(deliverer_id: id, donation_id: _donation.id??0);
      print("after ${wrapper!.data}");
      if(mounted) { setState(() { _bottomSheet = false; }); }
      if(wrapper.data!=null) {
        setState(() {
        _donation = wrapper.data;
      });
        widget.onDonationChanged(wrapper.data);
      }
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
  _indecatorText(){

  }
}
