import 'package:domain/models/stationary.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:util/RequestHandler.dart';
import 'package:util/Utility.dart';

class SearchStationaryCard extends StatefulWidget {
  const SearchStationaryCard({Key? key, required this.stationary, required this.user, required this.onClick,
    required this.theme, required this.tr})
      : super(key: key);

  final UserModel stationary;
  final UserModel user;
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final void Function(UserModel) onClick;

  @override
  State<SearchStationaryCard> createState() => _SearchStationaryCardState();
}

class _SearchStationaryCardState extends State<SearchStationaryCard> {
  @override
  Widget build(BuildContext context) {
    print(widget.stationary);
    return  Card(
      semanticContainer: true,
      color: widget.theme.cardColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell( onTap: (){ widget.onClick(widget.stationary); },
        child: Stack(
          children: [

            Align(
              alignment: Alignment.centerLeft,
              child: Hero(
                tag: "stationary_image"+widget.stationary.id.toString(),
                child: Container(
                  height: 98,
                  width: 98,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      opacity: 0.8,
                      image: NetworkImage('${RequestHandler.baseImageUrl}${widget.stationary.avatar}'),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  gradient:  LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      Colors.transparent,
                      widget.theme.cardColor.withOpacity(0.5)
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(110, 10, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( Utility.shorten(text:widget.stationary.full_name, max: 20),
                      overflow: TextOverflow.fade,
                      style: widget.theme.textTheme.bodyText2),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add_location, color: widget.theme.colorScheme.onBackground, size: 14,),
                      const SizedBox(width: 3,),
                      Text(widget.stationary.getLocation().address ?? "", style: widget.theme.textTheme.caption),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        // Row(
                        //   children: [
                        //       Image.asset('assets/icons/price_tag.png',
                        //         fit: BoxFit.fill, height: 18, width: 18,),
                        //     const SizedBox(width: 8,),
                        //     Text(widget.tr("cash", args: [widget.stationary.total_donation_price??"-"]), style: widget.theme.textTheme.subtitle2),
                        //   ],
                        // ),
                      Text(widget.tr("km_away", args:[
                        //widget.stationary.distance_from_school.toString()
                        Utility.calculateDriveMinute(widget.stationary.getLocation().latitude,
                            widget.stationary.getLocation().longitude,
                            widget.user.getLocation().latitude,
                            widget.user.getLocation().longitude).toString()
                      ]), style: widget.theme.textTheme.subtitle2),

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
      elevation: 0.5,
      margin: const EdgeInsets.all(10),
    );
  }
}
