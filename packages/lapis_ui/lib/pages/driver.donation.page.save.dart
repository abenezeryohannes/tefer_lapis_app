import 'package:dio/dio.dart';
import 'package:domain/controllers/donor.request.dart';
import 'package:domain/controllers/driver.request.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/fragments/donation/add.donation.fragment.dart';
import 'package:lapis_ui/fragments/donation/donated.fragment.dart';
import 'package:lapis_ui/fragments/donation/payment.required.fragment.dart';
import 'package:lapis_ui/pages/driver.donation.direction.page.dart';
import 'package:lapis_ui/widgets/button.outline.big.dart';
import 'package:rive/rive.dart';
import 'package:util/Utility.dart';

import '../fragments/donation/driver.donated.fragment.dart';
import '../intro/payment.page.intro.dart';
import '../widgets/button.big.dart';
import '../widgets/error.handler.ui.dart';
import '../widgets/list.view.error.dart';

class DriverDonationPage extends StatefulWidget {
  const DriverDonationPage(
      {Key? key,required this.donation, required this.onChange, required this.fundraiser, required this.theme, required this.tr, required this.user})
      : super(key: key);
  final ThemeData theme;
  final Function() onChange;
  final String Function(String, {List<String> args}) tr;
  final UserModel user;
  final FundraiserModel fundraiser;
  final DonationModel donation;

  @override
  State<DriverDonationPage> createState() => _DriverDonationPageState();
}

class _DriverDonationPageState extends State<DriverDonationPage> {
  bool isLoading = false;

  late Future<dynamic> _donation;
  @override
  void initState() {
    _donation = DriverRequest(widget.user).getDonation(widget.donation.id??0);
    super.initState();
  }

  onDonationChanged(x){
    setState(() {
      if(x==null) {
        _donation = DonorRequest(widget.user).getDonation(widget.donation.id??0);
      } else {
        _donation = x;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.backgroundColor,
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
                        onPressed: () { Navigator.maybePop(context); } ),
                  ],
                )
              ],
            ),
          )),
      body: SafeArea(
          child: FutureBuilder<dynamic>(
              future: _donation,
              builder: (context, snapshot) {
                if (snapshot.hasData ) {
                  //print("snapshot ${snapshot.data}");
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        const Hero(
                          tag: 'kid',
                          child: Material(
                              elevation: 8.0,
                              color: Colors.transparent,
                              shape: CircleBorder(),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: RiveAnimation.asset('assets/anim/lapis.riv',
                                  alignment:Alignment.center,
                                  fit:BoxFit.contain,
                                  stateMachines: ['State Machine Idle'],
                                  artboard: 'New Artboard',
                                  animations: ['idle'],
                                ),
                                radius: 48,
                              )),
                        ), 
                        const SizedBox(height: 20,),
                        DriverDonatedFragment(donation: snapshot.data.data, theme: widget.theme,
                            tr: widget.tr, user: widget.user, onDonationChanged: (x) => onDonationChanged(x),),


                        if( snapshot.data.data.getDeliveries().isEmpty || (snapshot.data.data.getDeliveries().isNotEmpty
                            && snapshot.data.data.getDeliveries()[0].user_id != widget.user.id))
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                          child: ButtonBig( theme: widget.theme,
                              child: Text( widget.tr("want_to_deliver"),
                                  style: widget.theme.textTheme.button), onClick: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(widget.tr("are_you_sure")),
                                        content: Text(widget.tr("are_you_sure_detail_for_to_deliver")),
                                        actionsOverflowButtonSpacing: 20,
                                        actions: [
                                          TextButton(
                                              onPressed: () async{
                                                try{  Wrapper wrapper = await DriverRequest(widget.user).assignDriver(
                                                      id: snapshot.data.data.id??0
                                                  );
                                                  if(wrapper.success??false||(wrapper.message==null&&wrapper.data!=null)){
                                                    widget.onChange();
                                                    setState(() {
                                                      _donation = DriverRequest(widget.user).getDonation(snapshot.data.data.id??0);
                                                    });
                                                    Navigator.of(context).pop();
                                                    Navigator.push(
                                                        context, MaterialPageRoute(builder: (context) =>
                                                        DriverDonationDirectionPage(tr: widget.tr, theme: widget.theme,
                                                          school: snapshot.data.data.getFundraiser().getUser(),
                                                          stationary: snapshot.data.data.getStationary(),
                                                          fundraiser: widget.fundraiser,
                                                          user: widget.user, donation: snapshot.data.data,) ));
                                                  }else{
                                                    ErrorHandlerUi().showErrorDialog(context: context,
                                                        title: "error",
                                                        description: wrapper.message??"-",
                                                        theme: widget.theme,tr: widget.tr);
                                                  }
                                                }on DioError catch(e){
                                                  ErrorHandlerUi().showErrorDialog(context: context,
                                                      title: "error",
                                                      description: Utility.formatError(e, tr: widget.tr),
                                                      theme: widget.theme,tr: widget.tr);
                                                }

                                                },
                                              child: Text(widget.tr("yes"))),
                                        ],
                                        backgroundColor: widget.theme.cardColor,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(20))),
                                      );
                                    });


                          }),
                        ),
                          if(snapshot.data.data.getDeliveries().isNotEmpty
                            && snapshot.data.data.getDeliveries()[0].user_id == widget.user.id)
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                                child: ButtonOutlineBig( theme: widget.theme,
                                    child: Text( widget.tr("Direction"),
                                        style: TextStyle(
                                            color: widget.theme.colorScheme.onBackground),
                                    ), onClick: () {

                                  // print("test: school 1 ${snapshot.data.data.getSchool()}");
                                  // print("test: school ${snapshot.data.data.getFundraiser().getUser()}");
                                  // print("test: stationary ${snapshot.data.data.getStationary()}");
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) =>
                                          DriverDonationDirectionPage(tr: widget.tr, theme: widget.theme,
                                            school: snapshot.data.data.getSchool(),
                                            fundraiser: widget.fundraiser,
                                            stationary: snapshot.data.data.getStationary(),
                                            user: widget.user, donation: snapshot.data.data,) ));
                                    })
                            )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Column(
                    children: [
                      Expanded(
                        child: Text(
                          '${snapshot.error}',
                          style: widget.theme.textTheme.bodyText1,
                        ),
                      ),
                    ],
                  );
                }
                // By default, show a loading spinner.
                return Column(
                  children: const [
                    Expanded(child: Center(child: CircularProgressIndicator())),
                  ],
                );
              }
          )
      ),
    );
  }
}
