import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/widgets/bottom.sheet.menu.dart';
import 'package:lapis_ui/widgets/donation.Items.dart';
import 'package:util/Utility.dart';

import '../widgets/button.big.dart';
import '../widgets/button.outline.big.dart';

class PaymentPageIntro extends StatefulWidget {
  const PaymentPageIntro(
      {Key? key,required this.donation, required this.fundraiser, required this.theme, required this.tr, required this.user})
      : super(key: key);
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final UserModel user;
  final FundraiserModel fundraiser;
  final DonationModel donation;

  @override
  State<PaymentPageIntro> createState() => _PaymentPageIntroState();
}

class _PaymentPageIntroState extends State<PaymentPageIntro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomSheet: _showBottomSheet(),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: SafeArea(
            child: Row(
              children: [
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: widget.theme.colorScheme.onBackground,
                        onPressed: () {

                        } ),
                    ],
                )
              ],
            ),
          )),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Hero(
                    tag: 'kid',
                    child: Material(
                        elevation: 8.0,
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.asset("assets/img/lapis.png"),
                          radius: 48,
                        )),
                  ),

                  const SizedBox(height: 40,),

                  Text(widget.tr("payment_code"), style: TextStyle( fontSize: 16, color: widget.theme.colorScheme.secondary )),

                  const SizedBox( height: 20,),

                  Text(("${widget.donation.payment_code}"), style: TextStyle( fontSize: 32, color: widget.theme.colorScheme.onBackground)),

                  const SizedBox(height: 20,),

                  //
                  // icons list built
                  // fundraiser title
                  // row inside row for stationary and school
                  //

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
                    child: Text(widget.tr(widget.fundraiser.description??""), textAlign: TextAlign.center, style: widget.theme.textTheme.bodyText2),
                  ),

                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: ButtonOutlineBig( theme: widget.theme, child: Text( widget.tr("choose delivery mechanism"), style: widget.theme.textTheme.button), onClick: () => {
                  setState(() { _bottomSheet = true; })
                  },  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: ButtonBig( theme: widget.theme, child: Text( widget.tr("continue"), style: widget.theme.textTheme.button), onClick: () => {
                    //TODO
                  }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool _bottomSheet = false;
  Widget? _showBottomSheet(){
    if(!_bottomSheet) return null;
    double distanceFromSchoolToStationary = Utility.calculateDistance(widget.fundraiser.getUser().getLocation().latitude, widget.fundraiser.getUser().getLocation().longitude,
        widget.donation.getStationary().getLocation().latitude, widget.donation.getStationary().getLocation().longitude );
    return BottomSheetMenu(
      theme: widget.theme,
      child: Column(
        children: [
          (widget.donation.delivery_id==null || ((widget.donation.getDeliveries()[0].user_id??-1) != widget.user.id) )?
              //user
              Text('${widget.user.full_name}', style: widget.theme.textTheme.bodyText1,)
              :  Container(height: 10,color: Colors.red,),
          ((widget.donation.delivery_id==null || ((widget.donation.getDeliveries()[0].user_id??-1) != widget.fundraiser.getUser().id) )
                && ((widget.fundraiser.getUser().getSchool().minimum_distance??0) > distanceFromSchoolToStationary))?
              //school
              Text('${widget.fundraiser.getUser().full_name}', style: widget.theme.textTheme.bodyText1,)
              :  Container(height: 10,color: Colors.blue,),
          ((widget.donation.delivery_id==null || ((widget.donation.getDeliveries()[0].user_id??-1) != widget.donation.getStationary().id) )
                && ((widget.donation.getStationary().getSchool().minimum_distance??0) > distanceFromSchoolToStationary))?
              //stationary
              Text('${widget.donation.getStationary().full_name}', style: widget.theme.textTheme.bodyText1,)
              :  Container(height: 10,color: Colors.green,),
        ],
      ),
    );
  }
}
