import 'package:dio/dio.dart';
import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/current.user.model.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/fragments/donation/add.donation.fragment.dart';
import 'package:lapis_ui/fragments/donation/donated.fragment.dart';
import 'package:lapis_ui/fragments/donation/payment.required.fragment.dart';
import 'package:rive/rive.dart';
import 'package:util/Utility.dart';

import '../intro/payment.page.intro.dart';
import '../widgets/button.big.dart';
import '../widgets/error.handler.ui.dart';
import '../widgets/list.view.error.dart';
import '../widgets/loading.bar.dart';

class DonationPage extends StatefulWidget {
  const DonationPage(
      {Key? key,required this.donation, required this.onEnd, required this.fundraiser,
        required this.theme, required this.tr, required this.user, this.isNew = false})
      : super(key: key);
  final ThemeData theme;
  final Function() onEnd;
  final String Function(String, {List<String> args}) tr;
  final UserModel user;
  final bool isNew;
  final FundraiserModel fundraiser;
  final DonationModel donation;

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  bool isLoading = false;

  late  Future<dynamic> _donation;
  late String type;
  late String status;
  @override
  void initState() {
    _donation = DonorRequest(widget.user).getDonation(widget.donation.id??0);

    if (widget.donation.id==null){
      type = "new";
    }else if(widget.donation.payment_id!=null){
      type = "donated";
    }else {
      type = "pending";
    }

    if((widget.donation.payment_id!=null&&widget.donation.payment_id! > 0) || (widget.donation.differed!=null&&widget.donation.differed!>0)){
      if(widget.donation.getDeliveries().isNotEmpty&&widget.donation.getDeliveries().first.status == 'delivered') {
        status = "delivered"; } else { status = "donated"; }
    }else{
      if((widget.donation.getFundraiser().donated_items_count??0) >= (widget.donation.getFundraiser().items_count??0)){
        status = "closed"; }
      else if(widget.donation.getFundraiser().status!=null&&widget.donation.getFundraiser().status!='active'
          &&widget.donation.getFundraiser().status!='assigned'
          &&widget.donation.getFundraiser().status!='accepted'){
        status = 'fundraiser_ban'; } else { status = "waiting_payment"; }
    }

    super.initState();
  }
  onDonationChanged(DonationModel x){
    setState(() {
      //if(x.id!=null&&x.id!>1) {
        _donation = DonorRequest(widget.user).getDonation(widget.donation.id??0);
        widget.onEnd();
      //}
    });
  }
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        if(widget.isNew) {
          if(Navigator.canPop(context)) { Navigator.pop(context);  }
          if(Navigator.canPop(context)) { Navigator.pop(context);  }
          if(Navigator.canPop(context)) { Navigator.pop(context);  }
        }else{ if(Navigator.canPop(context)) { Navigator.pop(context); } }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: widget.theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              if(loading) const LoadingBar( ),
              SingleChildScrollView(
                child: Column(
                  children: [ 
                    const SizedBox(height:34),
                    Material(
                        elevation: 8.0,
                        shadowColor: widget.theme.cardColor,
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        child: const CircleAvatar(
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



                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          const SizedBox(height: 20,),


                          if(type == 'new')
                            AddDonationFragment(
                                donation: widget.donation, theme: widget.theme,
                                tr: widget.tr, user: widget.user)

                          else if(type == 'donated' || type=='delivered')
                            DonatedFragment(
                                donation: widget.donation, theme: widget.theme,
                                tr: widget.tr, user: widget.user,
                                onDonationChanged: (x) => onDonationChanged(x))

                          else if(type == 'pending')
                              PaymentRequiredFragment(
                                donation: widget.donation, theme: widget.theme,
                                tr: widget.tr, user: widget.user, onEnd: widget.onEnd,
                                onLoadingChange: (value){setState(() { loading = value; });},
                                onDonationChanged: (x) => onDonationChanged(x),),

                          // if(widget.donation.payment_id!=null)
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                          //   child: ButtonBig( theme: widget.theme, child: Text( widget.tr("continue"),
                          //       style: widget.theme.textTheme.button), onClick: () => {
                          //
                          //     Navigator.pushReplacement(
                          //         context,MaterialPageRoute(builder: (context) =>
                          //         PaymentPageIntro(tr: widget.tr, theme: widget.theme, fundraiser:
                          //         widget.donation.getFundraiser(), user: widget.user,
                          //           donation: DonationModel.fresh(),) )
                          //     )
                          //
                          //   }),
                          // )

                        ],
                      ),
                    )

                    // FutureBuilder<dynamic>(
                    //     future: _donation,
                    //     builder: (context, snapshot) {
                    //       if (snapshot.hasData ) {
                    //         //print("snapshot ${snapshot.data}");
                    //         return Padding(
                    //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             mainAxisSize: MainAxisSize.min,
                    //             children: [
                    //
                    //               const SizedBox(height: 20,),
                    //
                    //               if(type == 'new')
                    //               AddDonationFragment(donation: snapshot.data.data, theme: widget.theme,
                    //                   tr: widget.tr, user: widget.user)
                    //
                    //               else if(type == 'donated'||type=='delivered')
                    //               DonatedFragment(donation: snapshot.data.data, theme: widget.theme,
                    //                   tr: widget.tr, user: widget.user, onDonationChanged: (x) => onDonationChanged(x))
                    //
                    //               else if(type == 'pending')
                    //               PaymentRequiredFragment(donation: snapshot.data.data, theme: widget.theme,
                    //                 tr: widget.tr, user: widget.user, onEnd: widget.onEnd, onLoadingChange: (value){setState(() { loading = value; });},
                    //               onDonationChanged: (x) => onDonationChanged(x),),
                    //
                    //               // if(widget.donation.payment_id!=null)
                    //               // Padding(
                    //               //   padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    //               //   child: ButtonBig( theme: widget.theme, child: Text( widget.tr("continue"),
                    //               //       style: widget.theme.textTheme.button), onClick: () => {
                    //               //
                    //               //     Navigator.pushReplacement(
                    //               //         context,MaterialPageRoute(builder: (context) =>
                    //               //         PaymentPageIntro(tr: widget.tr, theme: widget.theme, fundraiser:
                    //               //         widget.donation.getFundraiser(), user: widget.user,
                    //               //           donation: DonationModel.fresh(),) )
                    //               //     )
                    //               //
                    //               //   }),
                    //               // )
                    //
                    //             ],
                    //           ),
                    //         );
                    //       } else if (snapshot.hasError) {
                    //         return ListViewError(tr: widget.tr,
                    //           error: snapshot.error!, theme: widget.theme,
                    //           onRetry: (){setState(() {
                    //             _donation = DonorRequest(widget.user).getDonation(widget.donation.id??0);
                    //           });},);
                    //       }
                    //       // By default, show a loading spinner.
                    //       return Column(
                    //         children: const [
                    //           Expanded(child: Center(child: CircularProgressIndicator())),
                    //         ],
                    //       );
                    //     }
                    // ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: widget.theme.colorScheme.onBackground,
                          onPressed: () {
                            if(widget.isNew) {
                              Navigator.maybePop(context);
                              Navigator.maybePop(context);
                            }else{
                              Navigator.maybePop(context);
                            }
                            // Navigator.maybePop(context);
                          } ),


                    ],
                  ),

                  if(type == 'pending' || type == 'new'|| status == 'fundraiser_ban' || status == 'closed')
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          // value: dropdownValue,
                          icon: Icon(Icons.more_vert, color: widget.theme.colorScheme.onBackground,),
                          elevation: 16,
                          style: TextStyle(color: widget.theme.colorScheme.onBackground,),
                          underline: Container(
                            height: 0,
                            color: widget.theme.colorScheme.onBackground,
                          ),
                          onChanged: (String? newValue) { onCancelClicked(context);},
                          items: <String>['cancel']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(widget.tr(value), style: widget.theme.textTheme.bodyText2,),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  onCancelClicked(BuildContext context) async{
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(widget .tr("are_you_sure", args: [])),
            content: Text(widget .tr("cant_revert_this_change_latter", args: [])),
            actionsOverflowButtonSpacing: 20,
            actions: [
              TextButton(
                  onPressed: () async{
                try {
                  DonationModel temp = widget.donation;
                  temp.status = 'canceled';
                  Wrapper? wrapper = await DonorRequest(widget.user)
                      .editDonation(donation: temp);
                  if (((wrapper.success ?? false) ||
                      (wrapper.message != null))) {
                    await widget.onEnd();
                    if(Navigator.of(context).canPop())Navigator.pop(context);
                    if(Navigator.of(context).canPop())Navigator.pop(context);
                  } else {
                    if (wrapper.message!=null) {
                      ErrorHandlerUi().showErrorDialog(context: context,
                          title: "error",
                          description: wrapper.message??'',
                          theme: widget.theme,tr: widget.tr);
                    }
                  }
                }on DioError catch(e){
                  ErrorHandlerUi().showErrorDialog(context: context,
                      title: "error",
                      description: Utility.formatError(e, tr: widget.tr),
                      theme: widget.theme,tr: widget.tr);
                }
              },
              child: Text(widget.tr("ok"))),
        ],
        backgroundColor: widget.theme.cardColor,
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(20))),
      );
    });
  }
}
