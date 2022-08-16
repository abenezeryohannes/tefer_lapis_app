import 'package:domain/models/stationary.item.model.dart';
import 'package:domain/models/stationary.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:util/RequestHandler.dart';
import 'package:util/Utility.dart';

class StationaryItemCard extends StatefulWidget {
  const StationaryItemCard({Key? key, required this.stationaryItemModel,
    required this.user, required this.onClick,
    required this.theme, required this.tr})
      : super(key: key);

  final StationaryItemModel stationaryItemModel;
  final UserModel user;
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final void Function(StationaryItemModel) onClick;

  @override
  State<StationaryItemCard> createState() => _StationaryItemCardState();
}

class _StationaryItemCardState extends State<StationaryItemCard> {
  @override
  Widget build(BuildContext context) {

    String price = widget.stationaryItemModel.unit_price??'';
     return  Card(
      semanticContainer: true,
      color: widget.theme.cardColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell( onTap: (){ widget.onClick(widget.stationaryItemModel); },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(
                    "${RequestHandler.baseImageUrl}${widget.stationaryItemModel.getItem().name??''}",
                    width: 24, height: 24,
                  ),
                  const SizedBox(width: 3,),
                  Text(widget.stationaryItemModel.getItem().name ?? "",
                      style: widget.theme.textTheme.headline6),
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
                        Text( widget.tr("cash", args:[ Utility.format(price, false) ]),
                            style: widget.theme.textTheme.subtitle2),
                      ],
                    ),
                  Text(widget.tr("available", args:[
                    widget.stationaryItemModel.quantity.toString(),
                    widget.stationaryItemModel.getItem().unit??"",
                  ]), style: widget.theme.textTheme.subtitle2),

                ],
              )
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
    );
  }
}
