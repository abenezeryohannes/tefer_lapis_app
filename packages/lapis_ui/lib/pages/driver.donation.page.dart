import 'package:dio/dio.dart';
import 'package:domain/controllers/donor.request.dart';
import 'package:domain/controllers/driver.request.dart';
import 'package:domain/models/delivery.model.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/pages/driver.donation.direction.page.dart';
import 'package:lapis_ui/widgets/button.outline.big.dart';
import 'package:util/Utility.dart';

import '../fragments/donation/driver.donated.fragment.dart';
import '../intro/payment.page.intro.dart';
import '../widgets/button.big.dart';
import '../widgets/error.handler.ui.dart';
import '../widgets/list.view.error.dart';
import 'package:util/RequestHandler.dart';

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
        backgroundColor: widget.theme.scaffoldBackgroundColor,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: _headerAction(),
                leadingWidth: 0,
                leading: null,
                pinned: true,
                iconTheme: const IconThemeData(size: 0),
                backgroundColor: widget.theme.scaffoldBackgroundColor,
                floating: true,
                expandedHeight: 200,
                forceElevated: innerBoxIsScrolled,
                // bottom: PreferredSize(preferredSize: Size( MediaQuery.of(context).size.width, 64),
                // child: _greetingWidget()),
                flexibleSpace: FlexibleSpaceBar(
                  //title: _headerAction(),
                  expandedTitleScale: 3,
                  background:  Stack(
                    children: [
                      Hero(
                        tag: "img_fundraiser",
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage('${RequestHandler.baseImageUrl}${widget.fundraiser.image}'),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient:  LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.transparent,
                              widget.theme.scaffoldBackgroundColor
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // SliverPadding(
              //   padding: const EdgeInsets.all(16.0),
              //   sliver: SliverList(
              //     delegate: SliverChildListDelegate([
              //       _greetingWidget()
              //     ]),
              //   ),
              // ),


            ];
          },
          body: _content(context),
        ));
  }


  Widget _headerAction(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Card(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 5,
            child: InkWell(
              onTap: () { Navigator.maybePop(context); },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon( Icons.arrow_back, size: 24,
                    color: widget.theme.colorScheme.onBackground
                ),
              ),
            )
        ),


        if(widget.donation.getDeliveries().isNotEmpty&&widget.donation.getDeliveries().first.status=='active')
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
          )

      ],
    );
  }

  Widget _content(context){
    return FutureBuilder<dynamic>(
        future: _donation,
        builder: (context, snapshot) {
          if (snapshot.hasData ) {
            //print("snapshot ${snapshot.data}");
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DriverDonatedFragment(donation: snapshot.data.data, theme: widget.theme,
                      tr: widget.tr, user: widget.user, onDonationChanged: (x) => onDonationChanged(x),),
                  ),

                  if(!(snapshot.data.data.getDeliveries().isNotEmpty&&snapshot.data.data.getDeliveries().first.status=="delivered"))
                    _actions(snapshot, context)
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
    );

  }



  Widget _actions(snapshot, context){
    return Column(
      children: [
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
                          title: Text(widget.tr("are_you_sure"), style: widget.theme.textTheme.bodyText1,),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.timelapse, size: 62, color: widget.theme.colorScheme.secondary,),
                              const SizedBox(height: 20),
                              Text(widget.tr("are_you_sure_detail_for_to_deliver")),
                            ],
                          ),
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
                                          fundraiser: snapshot.data.data.getFundraiser(),
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
                          school: snapshot.data.data.getFundraiser().getUser(),
                          fundraiser: snapshot.data.data.getFundraiser(),
                          stationary: snapshot.data.data.getStationary(),
                          user: widget.user, donation: snapshot.data.data,) ));
                  })
          ),















      ]
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
                      DeliveryModel temp = widget.donation.getDeliveries().first;
                    temp.status = 'canceled';
                    Wrapper? wrapper = await DriverRequest(widget.user).updateDelivery(delivery: temp);
                    if (((wrapper.success ?? false) ||
                    (wrapper.message != null))) {
                     await widget.onChange();
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
                    description: (e.error is String)?e.error: (e.error!=null&&e.error.message is String)?e.error.message:widget.tr('something_went_wrong_try_again_letter'),
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
