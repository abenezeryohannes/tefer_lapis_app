import 'package:dio/dio.dart';
import 'package:domain/controllers/driver.request.dart';
import 'package:domain/models/delivery.model.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:util/Utility.dart';

import '../button.outline.big.dart';
import '../error.handler.ui.dart';

class DriverDeliveryCard extends StatefulWidget {
  const DriverDeliveryCard(
      {Key? key, required this.theme,required this.onClick, required this.tr,
        required this.delivery, required this.user, required this.onChange})
      : super(key: key);
  final ThemeData theme;
  final UserModel user;
  final Function onChange;
  final String Function(String, {List<String> args}) tr;
  final void Function(DeliveryModel) onClick;
  final DeliveryModel delivery;

  @override
  State<DriverDeliveryCard> createState() => _DriverDeliveryCardState();
}

class _DriverDeliveryCardState extends State<DriverDeliveryCard> {
  String left = '';
  @override
  void initState() {
    if(widget.delivery.expires_after!=null) {
      left = Utility.getTimesLeft(
          tr: widget.tr,
          time_start: widget.delivery.expires_after!,
          against: DateTime.now()
      );
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      color: widget.theme.cardColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: (){widget.onClick(widget.delivery);},
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox( height: 8 ),
              Text(widget.delivery.getFundraiser().title ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,
                      color: widget.theme.colorScheme.onBackground)),
              // const SizedBox( height: 8 ),
              // Text(widget.tr("km_away", args: [widget.delivery.distance ?? ""]), style: widget.theme.textTheme.subtitle2),
              // const SizedBox( height: 15 ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Row(
              //           children: [
              //             Image.asset( "assets/icons/stationary.png", width: 16, height: 16, ),
              //             const SizedBox( width: 5, ),
              //             Text(
              //               Utility.shorten(text: widget.delivery.getStationary().full_name, max: 14),
              //               style: widget.theme.textTheme.subtitle1,
              //               softWrap: false,
              //               overflow: TextOverflow.fade,
              //             )
              //           ],
              //         ),
              //         const SizedBox( height: 8 ),
              //         Text(
              //           Utility.shorten(text: widget.delivery.getStationary().getLocation().address ?? "", max: 16),
              //           style: widget.theme.textTheme.subtitle1,
              //           softWrap: false,
              //           overflow: TextOverflow.fade,
              //         )
              //       ],
              //     ),
              //     if(widget.delivery.getStationary().id!=null)
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Row(
              //             children: [
              //               Image.asset('assets/icons/school.png',
              //                 fit: BoxFit.fill, height: 16, width: 16,),
              //               const SizedBox(width: 5),
              //               Text(
              //                 Utility.shorten(text: widget.delivery.getSchool().full_name, max: 16),
              //                 style: widget.theme.textTheme.subtitle1,
              //                 softWrap: false,
              //                 overflow: TextOverflow.fade,
              //               )
              //             ],
              //           ),
              //           const SizedBox( height: 8 ),
              //           Text(
              //             Utility.shorten(text: widget.delivery.getSchool().getLocation().address ?? "", max: 14),
              //             style: widget.theme.textTheme.subtitle1,
              //             softWrap: false,
              //             overflow: TextOverflow.fade,
              //           )
              //         ],
              //       )
              //   ],
              // ),
              // const SizedBox( height: 15 ),


              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Icon(Icons.show_chart, size: 32,
                              color: (widget.delivery.status=='active'&&left.isNotEmpty)?
                              widget.theme.colorScheme.secondary:
                              (widget.delivery.status=='received' ||
                                  widget.delivery.status=='delivered')?
                                Colors.green:Colors.red
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Text(widget.tr("km", args: [widget.delivery.distance ?? ""]),
                              style: widget.theme.textTheme.bodyText2 ),
                        ],
                      ),
                    ),

                    if((widget.delivery.status == "received" || widget.delivery.status == "delivered")
                      && widget.delivery.trip_start_time!=null)
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                          child:  Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              const Center( child: Icon(Icons.play_arrow,
                                size: 32, color: Colors.green, ), ),

                              const SizedBox(height: 5,),

                              Text(widget.tr( Utility.showDateSmall(tr: widget.tr,
                                  time: widget.delivery.trip_start_time!)),
                                  style: widget.theme.textTheme.bodyText2),
                            ],
                          )
                      ),

                    if((widget.delivery.status == "delivered")
                        && widget.delivery.trip_end_time!=null)
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                          child:  Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Center( child: Icon(Icons.stop, size: 32,
                                color: Colors.green, ), ),
                              const SizedBox(height: 5,),
                              Text( widget.tr(Utility.showDateSmall(tr: widget.tr,
                                  time: widget.delivery.trip_end_time!)),
                                  style: widget.theme.textTheme.bodyText2),
                            ],
                          )
                      ),






                    if(widget.delivery.createdAt!=null && left.isNotEmpty
                        && widget.delivery.status == 'active' )
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                          child:  Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Icon(Icons.timelapse, size: 32, color: widget.theme.colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Text(widget.tr("remaining_time",
                                  args: [ left ]),
                                  style: widget.theme.textTheme.bodyText2),
                            ],
                          )
                      )
                    else if((widget.delivery.createdAt!=null && left.isEmpty && widget.delivery.status != 'received'
                            && widget.delivery.status!='delivered')
                        || widget.delivery.status == 'expired' )
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                          child:  Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Center(
                                child: Icon(Icons.timelapse, size: 32, color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Text(widget.tr('expired'),
                                  style: widget.theme.textTheme.bodyText2),
                            ],
                          )
                      ),

                    // if(widget.delivery.createdAt!=null)
                    //   Text(timeago.format(widget.delivery.createdAt!), style: widget.theme.textTheme.subtitle2)
                  ],
                ),
              ),








              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Image.asset( "assets/icons/stationary.png", width: 16, height: 16, ),
                            Text(
                              Utility.shorten(text: widget.tr("start:"), max: 14),
                              style: widget.theme.textTheme.bodyText2,
                            ),
                            const SizedBox( width: 5 ),
                            Text(
                              // Utility.shorten(text: widget.donation.getStationary().full_name, max: 14),
                              widget.delivery.getStationary().full_name??'',
                              style: widget.theme.textTheme.bodyText2,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            )
                          ],
                        ),
                        const SizedBox( height: 8 ),
                        Row(
                          children: [
                            Icon(Icons.add_location, size:16, color: widget.theme.dividerColor),
                            const SizedBox(width: 4),
                            Text(
                              // Utility.shorten(text: widget.donation.getStationary().getLocation().address ?? "", max: 16),
                              widget.delivery.getStationary().getLocation().address ?? "",
                              style: widget.theme.textTheme.caption,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        )
                      ],
                    ),


                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Divider( color: widget.theme.dividerColor, ),
                    ),

                    if(widget.delivery.getStationary().id!=null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Image.asset('assets/icons/school.png',
                              //   fit: BoxFit.fill, height: 16, width: 16,),
                              Text(
                                Utility.shorten(text: widget.tr("destination:"), max: 14),
                                style: widget.theme.textTheme.bodyText2,
                              ),
                              const SizedBox( width: 5 ),
                              Text(
                                //Utility.shorten(text: widget.donation.getSchool().full_name, max: 16),
                                widget.delivery.getSchool().full_name??'',
                                style: widget.theme.textTheme.bodyText2,
                                softWrap: false,
                                overflow: TextOverflow.fade,
                              )
                            ],
                          ),
                          const SizedBox( height: 8 ),
                          Row(
                            children: [
                              Icon(Icons.add_location, size:16, color: widget.theme.dividerColor),
                              const SizedBox(width: 4),
                              Text(
                                // Utility.shorten(text: widget.donation.getSchool().getLocation().address ?? "", max: 14),
                                widget.delivery.getSchool().getLocation().address ?? "",
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
              if((widget.delivery.createdAt!=null && left.isEmpty &&(widget.delivery.status != "received" && widget.delivery.status != "delivered"))
                  || widget.delivery.status == 'expired' )
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: SizedBox(
                        height: 30,
                        child: ButtonOutlineBig(onClick: (){_onCancelClick(context);} ,
                          child: Text( widget.tr("cancel"), style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold), ),
                          theme: widget.theme, width: "min",)
                    ),
              ),
                  ],
                )

            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 1,
      margin: const EdgeInsets.all(8),
    );
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
                      DeliveryModel temp = widget.delivery;
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
                          description:  Utility.formatError(e, tr: widget.tr),
                          // (e.error is String)?e.error: (e.error!=null&&e.error.message is String)?e.error.message:
                          // widget.tr('something_went_wrong_try_again_letter'),
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
