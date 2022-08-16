import 'package:domain/models/donation.item.model.dart';
import 'package:flutter/material.dart';
import 'package:util/RequestHandler.dart';

class DonationItems extends StatefulWidget {
   const DonationItems({Key? key, required this.fundraiserItems, required this.theme, required this.tr}) : super(key: key);
  final List<DonationItemModel> fundraiserItems;
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;

  @override
  State<DonationItems> createState() => _DonationItemsState();
}

class _DonationItemsState extends State<DonationItems> {
  @override
  Widget build(BuildContext context) {

    return Wrap(
            spacing: 16,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            children: _buildItems()
    );
  }

  List<Widget> _buildItems(){
   return widget.fundraiserItems.map<Widget>((e) =>
        Container(
            decoration: BoxDecoration(
                border: Border.all(color: widget.theme.dividerColor, width: 2),
                borderRadius: BorderRadius.circular(10),
                color: widget.theme.cardColor
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              children: [
                Image.network( RequestHandler.baseImageUrl + (e.getItem().image ?? ""), fit: BoxFit.fill, height: 20, width: 20,),
                const SizedBox(height: 8,),
                Text( (e.quantity.toString()) + " " + (e.getItem().name??""), style: widget.theme.textTheme.overline)
              ],
            )
        )
    ).toList();
  }

}
