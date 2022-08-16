import 'package:domain/models/user.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map/map.requests.dart';
import 'package:util/RequestHandler.dart';
import 'package:util/Utility.dart';

class SchoolStationaryDistanceCard extends StatefulWidget {
  const SchoolStationaryDistanceCard({Key? key, required this.stationary, required this.school, required this.theme, required this.tr}) : super(key: key);
  final UserModel stationary;
  final UserModel school;
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;

  @override
  State<SchoolStationaryDistanceCard> createState() => _SchoolStationaryDistanceCardState();
}

class _SchoolStationaryDistanceCardState extends State<SchoolStationaryDistanceCard> {

  late Future<List<String>> distanceAndDuration;

  @override
  void initState() {
    distanceAndDuration = MapRequests(UserModel.fresh()).getDistanceAndDuration(
        origin: [widget.stationary.getLocation().latitude??0,widget.stationary.getLocation().longitude??0],
        destination: [widget.school.getLocation().latitude??0,widget.school.getLocation().longitude??0]
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      color: widget.theme.cardColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const SizedBox( height: 10 ),
              Container(
                width: MediaQuery.of(context).size.width*7/12,
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image.asset( "assets/icons/stationary.png", width: 16, height: 16, ),
                        Text(
                          Utility.shorten(text: widget.tr("start")+":", max: 14),
                          style: widget.theme.textTheme.bodyText2,
                        ),
                        const SizedBox( height: 5 ),
                        Flexible(
                          child: Text(
                            // Utility.shorten(text: widget.donation.getStationary().full_name, max: 14),
                            widget.stationary.full_name??'',
                            style: widget.theme.textTheme.bodyText2,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,

                          ),
                        )
                      ],
                    ),
                    const SizedBox( height: 8 ),
                    Row(
                      children: [
                        Icon(Icons.add_location, size:16, color: widget.theme.dividerColor),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            // Utility.shorten(text: widget.donation.getStationary().getLocation().address ?? "", max: 16),
                            widget.stationary.getLocation().address ?? "",
                            style: widget.theme.textTheme.caption,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),


                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Divider( color: widget.theme.dividerColor, ),
                    ),

                    if(widget.stationary.id!=null)
                      Row(
                        children: [
                          // Image.asset('assets/icons/school.png',
                          //   fit: BoxFit.fill, height: 16, width: 16,),
                          Text(
                            Utility.shorten(text: widget.tr("destination")+":", max: 14),
                            style: widget.theme.textTheme.bodyText2,
                          ),
                          const SizedBox( height: 5 ),
                          Flexible(
                            child: Text(
                              //Utility.shorten(text: widget.donation.getSchool().full_name, max: 16),
                              widget.school.full_name??'',
                              style: widget.theme.textTheme.bodyText2,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    if(widget.stationary.id!=null)
                      const SizedBox( height: 8 ),

                    if(widget.stationary.id!=null)
                      Row( children: [
                        Icon(Icons.add_location, size:16, color: widget.theme.dividerColor),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            // Utility.shorten(text: widget.donation.getSchool().getLocation().address ?? "", max: 14),
                            widget.school.getLocation().address ?? "",
                            style: widget.theme.textTheme.caption,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox( height: 8 ),
            ],
        ),

        FutureBuilder<dynamic>(
                future: distanceAndDuration,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Text(widget.tr(snapshot.data[1]
                            // Utility.calculateDriveMinute(widget.school.getLocation().latitude,
                            //     widget.school.getLocation().longitude,
                            //     widget.stationary.getLocation().latitude,
                            //     widget.stationary.getLocation().longitude).toString()
                          ), style: widget.theme.textTheme.bodyText1),
                          const SizedBox(height: 15),
                          Text(widget.tr(snapshot.data[0]
                            // Utility.calculateDistance(widget.school.getLocation().latitude,
                            //     widget.school.getLocation().longitude,
                            //     widget.stationary.getLocation().latitude,
                            //     widget.stationary.getLocation().longitude).toString()
                          ), style: widget.theme.textTheme.bodyText2),

                        ],
                      ),
                    );
                  }
                  else if (snapshot.hasError) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          '${snapshot.error}',
                          style: widget.theme.textTheme.bodyText1,
                        ),
                      ),
                    );
                  }
                  // By default, show a loading spinner.
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                }
            )


        ],
      )

      // Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       Wrap(
      //         direction: Axis.horizontal,
      //         alignment: WrapAlignment.spaceBetween,
      //         spacing: 10,
      //         runSpacing: 10,
      //         children: [
      //           Row(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               CircleAvatar(
      //                 radius: 12,
      //                 backgroundColor: Colors.transparent,
      //                 backgroundImage: NetworkImage(RequestHandler.baseImageUrl+(widget.school.avatar??''),)
      //               ),
      //               const SizedBox(width: 10,),
      //               Flexible(child: Text(widget.school.full_name??'', style: widget.theme.textTheme.subtitle1)),
      //             ],
      //           ),
      //           Row(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               CircleAvatar(
      //                   radius: 12,
      //                   backgroundColor: Colors.transparent,
      //                   backgroundImage: NetworkImage("${RequestHandler.baseImageUrl}${widget.stationary.avatar??''}"),
      //               ),
      //               const SizedBox(width: 10,),
      //               Flexible(child: Text(widget.stationary.full_name??'', style: widget.theme.textTheme.subtitle1)),
      //             ],
      //           )
      //         ],
      //       ),
      //       const SizedBox(height: 20),
      //       FutureBuilder<dynamic>(
      //           future: distanceAndDuration,
      //           builder: (context, snapshot) {
      //             if (snapshot.hasData) {
      //               return Column(
      //                 children: [
      //
      //                   Text(widget.tr(snapshot.data[1]
      //                     // Utility.calculateDriveMinute(widget.school.getLocation().latitude,
      //                     //     widget.school.getLocation().longitude,
      //                     //     widget.stationary.getLocation().latitude,
      //                     //     widget.stationary.getLocation().longitude).toString()
      //                   ), style: widget.theme.textTheme.headline4),
      //                   const SizedBox(height: 15),
      //                   Text(widget.tr(snapshot.data[0]
      //                     // Utility.calculateDistance(widget.school.getLocation().latitude,
      //                     //     widget.school.getLocation().longitude,
      //                     //     widget.stationary.getLocation().latitude,
      //                     //     widget.stationary.getLocation().longitude).toString()
      //                   ), style: widget.theme.textTheme.bodyText2),
      //
      //                 ],
      //               );
      //             }
      //             else if (snapshot.hasError) {
      //               return Text(
      //                 '${snapshot.error}',
      //                 style: widget.theme.textTheme.bodyText1,
      //               );
      //             }
      //             // By default, show a loading spinner.
      //             return const Center(child: CircularProgressIndicator());
      //           }
      //       )
      //     ],
      //   ),
      // )
      ,shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
    );
  }
}
