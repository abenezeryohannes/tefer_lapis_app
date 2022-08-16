import 'package:domain/models/stationary.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:util/RequestHandler.dart';
import 'package:util/Utility.dart';

class StationaryCard extends StatefulWidget {
  const StationaryCard({Key? key, required this.stationary, required this.user, required this.onClick,
    required this.theme, required this.tr})
      : super(key: key);

  final UserModel stationary;
  final UserModel user;
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final void Function(UserModel) onClick;

  @override
  State<StationaryCard> createState() => _StationaryCardState();
}

class _StationaryCardState extends State<StationaryCard> {
  @override
  Widget build(BuildContext context) {
    // print(widget.stationary);
    String price = widget.stationary.total_donation_price??'';
    String km = widget.stationary.distance_from_school.toString();
    return  Card(
      semanticContainer: true,
      color: widget.theme.cardColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell( onTap: (){ widget.onClick(widget.stationary); },
        child: Stack(
          children: [


            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Hero(
            //     tag: "avatar",
            //     child: Container(
            //       height: 98,
            //       width: 98,
            //       decoration: BoxDecoration(
            //         image: DecorationImage(
            //           fit: BoxFit.cover,
            //           opacity: 0.3,
            //           image: NetworkImage('${RequestHandler.baseImageUrl}${widget.stationary.avatar}'),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Container(
            //     height: 100,
            //     width: 100,
            //     decoration: BoxDecoration(
            //       gradient:  LinearGradient(
            //         begin: Alignment.centerRight,
            //         end: Alignment.centerLeft,
            //         colors: <Color>[
            //           Colors.transparent ,
            //           widget.theme.cardColor
            //         ],
            //       ),
            //     ),
            //   ),
            // ),



            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Utility.shorten(text:widget.stationary.full_name, max: 20),
                      style: widget.theme.textTheme.bodyText2),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add_location, color: widget.theme.colorScheme.onBackground,
                          size: 14,),
                      const SizedBox(width: 3,),
                      Text(widget.stationary.getLocation().address ?? "",
                          style: widget.theme.textTheme.caption),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Row(
                          children: [
                              Image.asset('assets/icons/price_tag.png',
                                fit: BoxFit.fill, height: 18, width: 18,),
                            const SizedBox(width: 8,),
                            Text(widget.tr("cash", args: [
                              Utility.format(price, false)
                            ]
                            ), style: widget.theme.textTheme.caption),
                          ],
                        ),
                      if(Utility.format(km, false)!='-')
                      Text(widget.tr("km_away", args:[
                        //widget.stationary.distance_from_school.toString()
                        Utility.format(km, false)
                        //
                        // Utility.calculateDriveMinute(widget.stationary.getLocation().latitude,
                        //     widget.stationary.getLocation().longitude,
                        //     widget.user.getLocation().latitude,
                        //     widget.user.getLocation().longitude).toString()
                      ]), style: widget.theme.textTheme.caption),

                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 1,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
    );
  }
}
