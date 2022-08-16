import 'package:dio/dio.dart';
import'package:domain/controllers/donor.request.dart';
import 'package:domain/models/current.user.model.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:domain/shared_preference/user.sp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lapis_ui/pages/donation.direction.page.dart';
import 'package:lapis_ui/widgets/button.outline.big.dart';
 import 'package:url_launcher/url_launcher.dart';
import 'package:util/RequestHandler.dart';
import 'package:util/Utility.dart';

import '../../intro/payment.page.intro.dart';
import '../../widgets/button.big.dart';
import '../../widgets/donation.Items.dart';
import '../../widgets/error.handler.ui.dart';
import '../../widgets/loading.bar.dart';

class PaymentRequiredFragment extends StatefulWidget {
  const PaymentRequiredFragment(
      {Key? key,required this.onDonationChanged, required this.onLoadingChange,
        required this.donation,required this.onEnd, required this.theme, required this.tr, required this.user})
      : super(key: key);
  final ThemeData theme;
  final Function() onEnd;
  final Function(bool loading) onLoadingChange;
  final String Function(String, {List<String> args}) tr;
  final String Function(DonationModel) onDonationChanged;
  final UserModel user;
  final DonationModel donation;

  @override
  State<PaymentRequiredFragment> createState() => _PaymentRequiredFragmentState();
}

class _PaymentRequiredFragmentState extends State<PaymentRequiredFragment> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(widget.tr("waiting_for_payment"), style: const TextStyle( fontSize: 16,
                color: Colors.amber ))

            ,const SizedBox( height: 10,),

            Text(("${Utility.format(widget.donation.amount??'0', true)} ETB"),
                style: TextStyle(fontSize: 24, color: widget.theme.colorScheme.onBackground,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DonationItems( fundraiserItems: widget.donation.getDonationItems(),
                  theme: widget.theme,
                  tr: widget.tr ),
            ),

            const SizedBox( height: 20,),

            Flexible(
              child: Text(widget.donation.getFundraiser().title??'',
                  style: widget.theme.textTheme.bodyText1,
                textAlign: TextAlign.center,  ),
            ),

            const SizedBox( height: 10,),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Text(widget.tr(widget.donation.getFundraiser().description??""),
                  textAlign: TextAlign.center, style: widget.theme.textTheme.subtitle2),
            ),

            const SizedBox( height: 10,),







            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         // Image.asset( "assets/icons/stationary.png", width: 16, height: 16, ),
                  //         Text(
                  //           Utility.shorten(text: widget.tr("school")+":", max: 14),
                  //           style: widget.theme.textTheme.bodyText2,
                  //         ),
                  //         const SizedBox( width: 5 ),
                  //         Text(
                  //           // Utility.shorten(text: widget.donation.getStationary().full_name, max: 14),
                  //           widget.donation.getStationary().full_name??'',
                  //           style: widget.theme.textTheme.bodyText2,
                  //           softWrap: false,
                  //           overflow: TextOverflow.fade,
                  //         )
                  //       ],
                  //     ),
                  //     const SizedBox( height: 8 ),
                  //     Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Icon(Icons.add_location, size:20, color: widget.theme.dividerColor),
                  //         const SizedBox(width: 4),
                  //         Text(
                  //           // Utility.shorten(text: widget.donation.getStationary().getLocation().address ?? "", max: 16),
                  //           widget.donation.getStationary().getLocation().address ?? "",
                  //           style: widget.theme.textTheme.subtitle1,
                  //           softWrap: false,
                  //           overflow: TextOverflow.fade,
                  //         ),
                  //       ],
                  //     )
                  //   ],
                  // ),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Divider( color: widget.theme.dividerColor, ),
                  ),

                  const SizedBox( height: 20,),


                  if(widget.donation.getStationary().id!=null)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image.asset('assets/icons/school.png',
                            //   fit: BoxFit.fill, height: 16, width: 16,),
                            Text(
                              Utility.shorten(text: widget.tr("stationary")+":", max: 14),
                              style: widget.theme.textTheme.bodyText2,
                            ),
                            const SizedBox( width: 5 ),
                            Flexible(
                              child: Text(
                                //Utility.shorten(text: widget.donation.getSchool().full_name, max: 16),
                                widget.donation.getStationary().full_name??'',
                                style: widget.theme.textTheme.bodyText2,
                                softWrap: false,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                        const SizedBox( height: 8 ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_location, size:20, color: widget.theme.dividerColor),
                            const SizedBox(width: 4),
                            Text(
                              // Utility.shorten(text: widget.donation.getSchool().getLocation().address ?? "", max: 14),
                              widget.donation.getSchool().getLocation().address ?? "",
                              style: widget.theme.textTheme.caption,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        )
                      ],
                    )
                ],
              ),
            ),
            const SizedBox( height: 8 ),

          ],
        ),

        const SizedBox(height: 60),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              ButtonOutlineBig( theme: widget.theme, child: Text( widget.tr("get_direction"),
                  style: widget.theme.textTheme.bodyText2),
                  onClick: () async{ _onDirection(); }),

              const SizedBox(height: 10),

              ButtonBig( theme: widget.theme, child: Text( widget.tr("make_payment"), style: widget.theme.textTheme.button), onClick: () {
                _onPayClicked(context);
              }),

              const SizedBox(height: 15),

            ],
          ),
        )
      ],
    );
  }

   _onPayClicked(BuildContext context) async{
     // return showDialog(
     //     context: context,
     //     builder: (BuildContext context) {
     //       return AlertDialog(
     //         title: Text(widget .tr("yene_pay_dialog_title", args: [])),
     //         content: Text(widget .tr("yene_pay_dialog_content", args: [])),
     //         actionsOverflowButtonSpacing: 20,
     //         actions: [
     //           TextButton(
     //               onPressed: () async{
     //                 // PaginationModel? resp =  await DonorRequest(widget.user).getDonations();
     //                 // if((resp!=null && (resp.total_items??0)<2) ){
     //                 //   Navigator.of(context).pop();
     //                 //   Navigator.of(context).pop();
     //                 //   Navigator.of(context).pop();
     //                 //   widget.onEnd();
     //                 // }else {
                   widget.onLoadingChange(true);
                    try {
                      Wrapper wrapper = await DonorRequest(widget.user)
                          .pay(widget.donation.id ?? 0);

                      // if(Navigator.canPop(context)) {
                      //   Navigator.of(context).pop();
                      // }

                        final Uri _url = Uri.parse(wrapper.data);
                        if (!await launchUrl(_url)) print( 'Could not launch $_url');
                        widget.onDonationChanged(DonationModel.fresh());
                    } on DioError catch(e){
                       ErrorHandlerUi().showErrorDialog(context: context,
                       title: "error",
                       description: Utility.formatError(e, tr: widget.tr),
                       theme: widget.theme,tr: widget.tr);
                     }finally{
                      widget.onLoadingChange(false);
                    }
     // }
         //           },
         //           child: Text(widget.tr("ok"))),
         //     ],
         //     backgroundColor: widget.theme.cardColor,
         //     shape: const RoundedRectangleBorder(
         //         borderRadius:
         //         BorderRadius.all(Radius.circular(20))),
         //   );
         // });
   }



   void _onDirection() async{
    widget.onLoadingChange(true);
     try {
       Wrapper? wrapper = await DonorRequest(widget.user).getDonation(widget.donation.id ?? 0);

       if(wrapper!=null&&(wrapper.success??false)){
         Navigator.push(
             context,MaterialPageRoute(builder: (context) =>
             DonationDirectionPage(tr: widget.tr, theme: widget.theme,
               school: widget.donation.getFundraiser().getUser(),
               stationary: widget.donation.getStationary(),
               onDonationChanged: widget.onDonationChanged,
               user: widget.user, donation: widget.donation,)));
       }else {
         ErrorHandlerUi().showErrorDialog( context: context, title: "error",
             description: (wrapper!=null&&wrapper.message!=null)? wrapper.message! : widget.tr('something_went_wrong_try_again_letter'),
             theme: widget.theme,tr: widget.tr );
      }
     } on DioError catch(e) {

           ErrorHandlerUi().showErrorDialog( context: context, title: "error",
             description: Utility.formatError(e, tr: widget.tr),
             theme: widget.theme,tr: widget.tr );

     } finally { widget.onLoadingChange(false); }

   }





}
