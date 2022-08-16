
import 'package:dio/dio.dart';
import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/intro/payment.page.intro.dart';
import 'package:lapis_ui/widgets/donation.Items.dart';
import 'package:rive/rive.dart';
import 'package:util/RequestHandler.dart';
import 'package:util/Utility.dart';

import '../pages/donation.page.dart';
import '../widgets/button.big.dart';
import '../widgets/error.handler.ui.dart';

class DonationPageIntro extends StatefulWidget {
  const DonationPageIntro(
      {Key? key, required this.donation, required this.onEnd,
        required this.fundraiser, required this.theme,
        required this.tr, required this.user})
      : super(key: key);

  final ThemeData theme;
  final void Function() onEnd;
  final String Function(String, {List<String> args}) tr;
  final UserModel user;
  final FundraiserModel fundraiser;
  final DonationModel donation;

  @override
  State<DonationPageIntro> createState() => _DonationPageIntroState();
}

class _DonationPageIntroState extends State<DonationPageIntro> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //show pop up and prepare to remove the donation or leave it
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
          title: Text(widget .tr("do_you_want_to_discard_this_donation?")),
          content: Text(widget .tr("discarding_donation_description")),
          actionsOverflowButtonSpacing: 20,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if(Navigator.canPop(context)) { Navigator.of(context).pop(); }
                  if(Navigator.canPop(context)) { Navigator.of(context).pop(); }
                },
                child: Text(widget.tr("save"))),
            TextButton(
                onPressed: () async{
                  try{
                  Wrapper wrapper = await DonorRequest(widget.user).removeDonation(widget.donation.id??0);
                  if(wrapper.success??false||(wrapper.message==null&&wrapper.data!=null)) {
                    Navigator.of(context).pop();
                    if(Navigator.canPop(context)) { Navigator.of(context).pop(); }
                    if(Navigator.canPop(context)) { Navigator.of(context).pop(); }
                  } else {
                          ErrorHandlerUi().showErrorDialog(context: context,
                            title: "error",
                            description: wrapper.message??'',
                            theme: widget.theme,
                          tr: widget.tr);
                      }
                  }on DioError catch(e){
                      ErrorHandlerUi().showErrorDialog(context: context,
                        title: "error", description: e.message,
                        theme: widget.theme,tr: widget.tr);
                  }
                },
                child: Text(widget.tr("discard"))),
          ],
          backgroundColor: widget.theme.cardColor,
          shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(20))),
          );});
        return false;
      },
      child: Scaffold(
        backgroundColor: widget.theme.scaffoldBackgroundColor,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const Hero(
                      tag: 'kid',
                      child: Material(
                          elevation: 8.0,
                          color: Colors.transparent,
                          shape: CircleBorder(),
                          child: //FlareActor("assets/anim/lapis.flr", alignment:Alignment.center, fit:BoxFit.contain, animation:"idle")
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: RiveAnimation.asset('assets/anim/lapis.riv',
                                alignment:Alignment.center,
                                fit:BoxFit.contain,
                                stateMachines: ['State Machine Idle'],
                                artboard: 'New Artboard',
                                animations: ['idle'],
                            ),// FlareActor("assets/anim/lapis.riv", alignment:Alignment.center, fit:BoxFit.contain, animation:"idle"), //Image.asset("assets/img/lapis.png"),
                            radius: 48,
                          )
                      ),
                    ),

                    const SizedBox(height: 20,),

                    Text(widget.tr("add_donation"), style: TextStyle( fontSize: 16, color: widget.theme.colorScheme.secondary )),

                    const SizedBox( height: 10,),

                    Text(("${widget.donation.amount} ETB"), style: TextStyle(fontSize: 32, color: widget.theme.colorScheme.onBackground, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 20,),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DonationItems(fundraiserItems: widget.donation.getDonationItems(), theme: widget.theme, tr: widget.tr),
                    ),

                    const SizedBox(height: 20,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox( width: MediaQuery.of(context).size.width,
                          child: Text(widget.fundraiser.title??"",
                              textAlign: TextAlign.center,
                              style: widget.theme.textTheme.bodyText1
                          )
                      ),
                    ),


                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: Text(widget.tr(widget.fundraiser.description??""), textAlign: TextAlign.center, style: widget.theme.textTheme.subtitle2),
                    ),

                    const SizedBox(height: 20,),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Divider( color: widget.theme.dividerColor, ),
                    ),

                    const SizedBox( height: 20,),

                    if(widget.donation.getStationary().id!=null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                //Utility.shorten(text: widget.donation.getSchool().full_name, max: 16),
                                widget.fundraiser.getUser().full_name??"",
                                style: widget.theme.textTheme.bodyText2,
                                softWrap: false,
                                overflow: TextOverflow.fade,
                              ),
                              const SizedBox( height: 8 ),
                              Row(
                                children: [
                                  Icon(Icons.add_location, size:16, color: widget.theme.dividerColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    // Utility.shorten(text: widget.donation.getSchool().getLocation().address ?? "", max: 14),
                                    widget.fundraiser.getUser().getLocation().address ?? "",
                                    style: widget.theme.textTheme.caption,
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),

                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                    //   child: Wrap(
                    //     direction: Axis.horizontal,
                    //     alignment: WrapAlignment.spaceAround,
                    //     spacing: 24,
                    //     runSpacing: 14,
                    //     children: [
                    //
                    //       Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Image.asset("assets/icons/school.png", width: 24, height: 24, fit: BoxFit.cover,),
                    //           const SizedBox(width: 5,),
                    //           Text(widget.fundraiser.getUser().full_name??"", style: widget.theme.textTheme.subtitle1 ),
                    //         ],
                    //       ),
                    //
                    //       Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Image.asset("assets/icons/stationary.png", width: 24, height: 24, fit: BoxFit.cover,),
                    //           const SizedBox(width: 5,),
                    //           Text(widget.donation.getStationary().full_name??"", style: widget.theme.textTheme.subtitle1 ),
                    //         ],
                    //       ),
                    //
                    //     ],
                    //   ),
                    // ),



                    //
                    // icons list built
                    // fundraiser title
                    // row inside row for stationary and school
                    //



                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: ButtonBig( theme: widget.theme, child: Text( widget.tr("continue"),
                    style: widget.theme.textTheme.button), onClick: () async{

                  try {
                    Wrapper donated = await DonorRequest(widget.user).donate(
                        donation: widget.donation);
                    if (donated.success ?? false ||
                        (donated.message == null && donated.data != null)) {
                      DonationModel donation = DonationModel.fromJson(
                          donated.data);
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) =>
                          DonationPage(tr: widget.tr,
                            theme: widget.theme,isNew: true,
                            fundraiser: widget.fundraiser,
                            onEnd: widget.onEnd,
                            user: widget.user,
                            donation: donation,))
                      );
                    } else {
                      ErrorHandlerUi().showErrorDialog(context: context,
                          title: "error",
                          description: donated.message??'',
                          theme: widget.theme,
                          tr: widget.tr);
                    }
                  }on DioError catch(e){
                    ErrorHandlerUi().showErrorDialog(context: context,
                        title: "error",
                        description: Utility.formatError(e, tr: widget.tr),
                        theme: widget.theme,tr: widget.tr);
                  }


                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
