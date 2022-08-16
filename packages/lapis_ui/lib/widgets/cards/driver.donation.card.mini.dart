import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/models/donation.model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:util/RequestHandler.dart';
import 'package:util/Utility.dart';

class DriverDonationCardMini extends StatefulWidget {
  const DriverDonationCardMini(
      {Key? key, required this.theme,required this.onClick, required this.tr, required this.donation})
      : super(key: key);
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final void Function(DonationModel) onClick;
  final DonationModel donation;

  @override
  State<DriverDonationCardMini> createState() => _DriverDonationCardMiniState();
}

class _DriverDonationCardMiniState extends State<DriverDonationCardMini> {
  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      elevation: 0.5,
      color: widget.theme.cardColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: (){widget.onClick(widget.donation);},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: Text(widget.donation.getFundraiser().title ?? "", style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: widget.theme.colorScheme.onBackground
              )),
            ),


            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Container(
                //   height: 240.0,
                //   padding: const EdgeInsets.symmetric(horizontal: 0),
                //   child: Hero(
                //     tag: 'img_fundraiser',
                //     child: CachedNetworkImage(
                //       imageUrl: RequestHandler.baseImageUrl+(widget.donation.getFundraiser().image??""),
                //       fit: BoxFit.cover,
                //       height: 240.0,
                //       imageBuilder: (context, imageProvider) => Container(
                //         width: MediaQuery.of(context).size.width,
                //         height: 240.0,
                //         decoration: BoxDecoration(
                //          // borderRadius: const BorderRadius.all(Radius.circular(20)),
                //           image: DecorationImage(
                //               image: imageProvider, fit: BoxFit.cover),
                //         ),
                //       ),
                //
                //       placeholder: (context, url) => SizedBox(
                //           width: MediaQuery.of(context).size.width,
                //           height: 240.0,
                //           child: Shimmer.fromColors(
                //             baseColor: widget.theme.cardColor.withOpacity(0.5),
                //             highlightColor: widget.theme.cardColor.withOpacity(1),
                //             child: Card(
                //                 elevation: 1.0,
                //                 shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(16),
                //                 )),
                //           )
                //       ),
                //       errorWidget: (context, url, error) => Container(
                //           width: MediaQuery.of(context).size.width,
                //           height: 240.0,
                //           alignment: Alignment.center,
                //           child: const Icon(Icons.error)),
                //     ),
                //   ),
                // ),



                Align(
                  alignment: AlignmentDirectional.bottomStart, // <-- SEE HERE
                  child: Card(
                    color: widget.theme.cardColor,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.show_chart, size: 16, color: widget.theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 5,),
                          Text(widget.tr("km", args: [widget.donation.distance ?? ""]),
                              style: widget.theme.textTheme.caption ),
                        ],
                      ),
                    ),
                  ),
                ),

                if(widget.donation.createdAt!=null)

                Align(
                  alignment: AlignmentDirectional.bottomEnd, // <-- SEE HERE
                  child: Card(
                    color: widget.theme.cardColor,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7),
                      child:  Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time, size: 16, color: widget.theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 5,),
                          Text(timeago.format(widget.donation.createdAt!),
                              style: widget.theme.textTheme.caption),
                        ],
                      )
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox( height: 10 ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
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
                            Utility.shorten(text: widget.tr("start")+":", max: 14),
                            style: widget.theme.textTheme.bodyText2,
                          ),
                          const SizedBox( width: 5 ),
                          Text(
                            // Utility.shorten(text: widget.donation.getStationary().full_name, max: 14),
                            widget.donation.getStationary().full_name??'',
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
                            widget.donation.getStationary().getLocation().address ?? "",
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

                  if(widget.donation.getStationary().id!=null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Image.asset('assets/icons/school.png',
                          //   fit: BoxFit.fill, height: 16, width: 16,),
                          Text(
                            Utility.shorten(text: widget.tr("destination")+":", max: 14),
                            style: widget.theme.textTheme.bodyText2,
                          ),
                          const SizedBox( width: 5 ),
                          Text(
                            //Utility.shorten(text: widget.donation.getSchool().full_name, max: 16),
                            widget.donation.getSchool().full_name??'',
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
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(8),
    );
  }
}
