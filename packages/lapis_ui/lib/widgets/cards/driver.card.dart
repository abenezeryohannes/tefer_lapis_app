import 'package:domain/models/delivery.model.dart';
import 'package:domain/models/donation.model.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:util/RequestHandler.dart';
import 'package:util/Utility.dart';

class DriverCard extends StatefulWidget {
  const DriverCard(
      {Key? key, required this.theme,required this.onClick, required this.tr, required this.delivery})
      : super(key: key);
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final void Function(DeliveryModel) onClick;
  final DeliveryModel delivery;

  @override
  State<DriverCard> createState() => _DriverCardState();
}

class _DriverCardState extends State<DriverCard> {
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
              Text(widget.delivery.status=="active"?widget.tr("will_be_delivered_by")
                  :(widget.delivery.status=="delivered")?widget.tr("delivered_by"):widget.tr(widget.delivery.status??''),
                  textAlign: TextAlign.left, style: widget.theme.textTheme.subtitle1),

              const SizedBox(height:5),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 16.0,
                      backgroundImage: NetworkImage( RequestHandler.baseImageUrl+(widget.delivery.getUser().avatar??'')),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(width: 10,),

                    Flexible(
                      child: Text(widget.delivery.getUser().full_name??'',
                        style: widget.theme.textTheme.subtitle1,),
                    ),

                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 50.0),
              //   child: Flexible(
              //     child: Text(widget.delivery.status??'',
              //       style: widget.theme.textTheme.subtitle2,),
              //   ),
              // ),
              if(widget.delivery.status=='received')
              const SizedBox(height:5),
              if(widget.delivery.status=='received')
                Flexible(
                child: Text('has_received_items_from_stationary',
                  style: widget.theme.textTheme.caption,),
              ),

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
}
