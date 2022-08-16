import 'package:dio/dio.dart';
import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/donation.item.model.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.item.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/widgets/button.outline.big.dart';
import 'package:lapis_ui/widgets/donation.Items.dart';
import 'package:lapis_ui/widgets/donation.tag.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:util/Utility.dart';

import '../button.big.dart';
import '../error.handler.ui.dart';
import '../tag.dart';

class DonationCard extends StatefulWidget {
  const DonationCard(
      {Key? key,  required this.onChange, required this.theme,required this.onClick, required this.tr, required this.donation,required this.user,
        required this.onLoadingChange})
      : super(key: key);
  final ThemeData theme;
  final Function onChange;
  final Function(bool) onLoadingChange;
  final UserModel user;
  final String Function(String, {List<String> args}) tr;
  final void Function(DonationModel) onClick;
  final DonationModel donation;

  @override
  State<DonationCard> createState() => _DonationCardState();
}

class _DonationCardState extends State<DonationCard> {
  late String status;

  @override
  void initState() {
    if((widget.donation.payment_id!=null&&widget.donation.payment_id! > 0) || (widget.donation.differed!=null&&widget.donation.differed!>0)){
      if(widget.donation.getDeliveries().isNotEmpty&&widget.donation.getDeliveries().first.status == 'delivered') {
        status = "delivered"; } else { status = "donated"; }
    }else{
      if((widget.donation.getFundraiser().donated_items_count??0) >= (widget.donation.getFundraiser().items_count??0)){
        status = "closed"; }
      else if(widget.donation.getFundraiser().status!=null
          &&widget.donation.getFundraiser().status!='active'
          &&widget.donation.getFundraiser().status!='assigned'
          &&widget.donation.getFundraiser().status!='accepted'){
         status = 'fundraiser_ban'; } else { status = "waiting_payment"; }
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      color: widget.theme.backgroundColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: ( ){ widget.onClick(widget.donation); },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(widget.donation.getFundraiser().title ?? "", style:TextStyle(
                      color: widget.theme.colorScheme.onBackground,
                      fontSize: 17,
                      fontWeight: FontWeight.w700
                  )),
                ),
              ),

              //fundraiser, closed, delivered
              if(status == 'fundraiser_ban'|| status == 'closed' || status == 'delivered' || status == 'donated')
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  color:  (status=='fundraiser_ban'||status=='closed')?Colors.red[800]:(status=='delivered')?Colors.green[800]:Colors.blue[800],
                  child: Text((status=='fundraiser_ban')?widget.tr(status)+widget.tr(widget.donation.getFundraiser().status??'')
                      : widget.tr(status),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),

              const SizedBox( height: 5 ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(widget.donation.getFundraiser().description ?? "", overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: widget.theme.textTheme.subtitle2),
              ),
              const SizedBox(height:12),
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 3,
                    direction: Axis.horizontal,
                    children: buildTag(widget.donation.getDonationItems()),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [


                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.tr('total'),
                          style: TextStyle(
                              color: (status=='donated')?Colors.blue:(status=='delivered')?Colors.green:(status=='fundraiser_ban')?Colors.red: Colors.yellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 12
                          ),),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,3,0,0),
                          child: Text(widget.tr('cash', args: [widget.donation.amount??'0']),
                            style: widget.theme.textTheme.bodyText2,),
                        ),
                      ],
                    ),





                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.tr('items_'),
                          style: TextStyle(
                              color: (status=='donated')?Colors.blue:(status=='delivered')?Colors.green:(status=='fundraiser_ban')?Colors.red: Colors.yellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 12
                          ),),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,3,0,0),
                          child: Text(widget.tr('items', args: [widget.donation.getDonationItems().length.toString()]),
                            style: widget.theme.textTheme.bodyText2,),
                        ),
                      ],
                    ),

                    if(status=='waiting_payment')
                      Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 30,
                          child: ButtonOutlineBig(onClick: (){_onDonateClick();} ,
                            child: Text( widget.tr("donated"), style: widget.theme.textTheme.overline, ),
                            theme: widget.theme, width: "min",)
                        ),
                      )
                    else if(status == 'fundraiser_ban' || status == 'closed')
                      Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: SizedBox(
                            height: 30,
                            child: ButtonOutlineBig(onClick: (){_onCancelClick(context);} ,
                              child: Text( widget.tr("cancel"), style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold), ),
                              theme: widget.theme, width: "min",)
                        ),
                      )
                  ],
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Row(
              //         children: [
              //           Image.asset( "assets/icons/school.png", width: 20, height: 20, ),
              //           const SizedBox( width: 5, ),
              //           Text(
              //             Utility.shorten(text: widget.donation.getSchool().full_name, max: 14),
              //             style: widget.theme.textTheme.subtitle1,
              //             softWrap: false,
              //             overflow: TextOverflow.fade,
              //           )
              //         ],
              //       ),
              //       if(widget.donation.getStationary().id!=null)
              //         Row(
              //           children: [
              //             Image.asset('assets/icons/stationary.png',
              //               fit: BoxFit.fill, height: 20, width: 20,),
              //             const SizedBox(width: 5),
              //             Text(
              //               Utility.shorten(text: widget.donation.getStationary().full_name, max: 12),
              //               style: widget.theme.textTheme.subtitle1,
              //                   softWrap: false,
              //                   overflow: TextOverflow.fade,
              //             )
              //           ],
              //         )
              //     ],
              //   ),
              // ),
              // const SizedBox( height: 15 ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Row(
              //         children: [
              //             (widget.donation.payment_id == null &&
              //                     widget.donation.differed==0)
              //                 ? Text(widget.tr("waiting"), style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 16),)
              //                 : Text(widget.tr("donated"), style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 16)),
              //           const SizedBox(width: 8),
              //           Text(widget.tr("cash", args: [widget.donation.amount.toString()]),
              //               style: widget.theme.textTheme.bodyText1)
              //         ],
              //       ),
              //       if(widget.donation.createdAt!=null)
              //       Text(timeago.format(widget.donation.createdAt!), style: widget.theme.textTheme.subtitle2)
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(8),
    );
  }

  List<Widget> buildTag(List<DonationItemModel> donationItems ){
    return donationItems.map<Widget>( (x) =>  DonationTag(donationItem: x,theme: widget.theme,tr: widget.tr) ).toList() ;
  }

  _onDonateClick() async{
    widget.onLoadingChange(true);
    try {
      Wrapper wrapper = await DonorRequest(widget.user)
          .pay(widget.donation.id ?? 0);

      // if(Navigator.canPop(context)) {
      //   Navigator.of(context).pop();
      // }

      final Uri _url = Uri.parse(wrapper.data);
      if (!await launchUrl(_url)) print( 'Could not launch $_url');

    } on DioError catch(e){
      ErrorHandlerUi().showErrorDialog(context: context,
          title: "error",
          description:  Utility.formatError(e, tr: widget.tr),
          theme: widget.theme,tr: widget.tr);
    }finally{
      widget.onLoadingChange(false);
    }
  }


  _onCancelClick(BuildContext context) async{
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
                        await widget.onChange();
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
                          description:  Utility.formatError(e, tr: widget.tr),
                          //(e.error is String)?e.error: (e.error!=null&&e.error.message is String)?e.error.message:widget.tr('something_went_wrong_try_again_letter'),
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
  }

}
