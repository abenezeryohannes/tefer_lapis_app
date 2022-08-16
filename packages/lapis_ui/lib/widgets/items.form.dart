import 'package:domain/models/donation.item.model.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.item.model.dart';
import 'package:domain/models/stationary.item.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:util/RequestHandler.dart';


class ItemForm extends StatefulWidget {
  const ItemForm({Key? key, required this.StationaryItem,
        required this.onChanged, required this.theme, //required this.donationItem,
        required this.tr}) : super(key: key);
  final StationaryItemModel StationaryItem;
  // final DonationItemModel donationItem;
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final Function(int, StationaryItemModel) onChanged;

  @override
  State<ItemForm> createState() => _ItemFormState();
}


class _ItemFormState extends State<ItemForm> {

  TextEditingController controller = TextEditingController(text: "0");
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
                SizedBox(width: MediaQuery.of(context).size.width*1/6,),
                SizedBox(
                  width: 80,
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      if(!hasFocus) {
                        int? value = (int.tryParse(controller.text));
                        if(value == null || value < 0) {
                          setState(() {controller.text = "0";});
                        }
                      }
                    },
                    child: TextFormField(
                            controller: controller,
                            onChanged: (val){
                              int? value = (int.tryParse(val));
                              if(value == null || value < 0) {
                                setState(() {controller.text = "";});
                              } else if(value > (widget.StationaryItem.donatable_amount??0)) {
                                setState(() {controller.text = "${(widget.StationaryItem.donatable_amount??0)}";});
                              }
                              widget.onChanged(int.tryParse(controller.text)??0, widget.StationaryItem);
                            },
                            style: widget.theme.textTheme.button,
                            decoration: InputDecoration(
                                hintText: '${(widget.StationaryItem.donatable_amount??0)}',
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                suffixIconConstraints: const BoxConstraints(maxWidth: 32, maxHeight: 24),
                                suffixIcon: Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Image.network( RequestHandler.baseImageUrl+(widget.StationaryItem.getItem().image??""),
                                    fit: BoxFit.fill, height: 24, width: 24,),
                                ),
                                constraints: const BoxConstraints(maxHeight: 42),
                                filled: true,
                                fillColor: widget.theme.cardColor,
                                hintStyle: TextStyle(fontWeight: FontWeight.bold, color: widget.theme.dividerColor),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.theme.dividerColor),
                                  borderRadius: const BorderRadius.all(Radius.circular(15))),
                              border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.theme.colorScheme.secondary),
                                  borderRadius: const BorderRadius.all(Radius.circular(15))),
                               contentPadding: const EdgeInsets.symmetric( horizontal: 10, vertical: 8),
                                //errorText: !validPhoneNumber ? widget.tr('field_required') : null,
                          )
                      ),
                  )
                ),

          const SizedBox(width: 20,),
          Text(widget.tr('out_of', args: ['${widget.StationaryItem.donate}', '${(widget.StationaryItem.donatable_amount??0)}',
                        widget.StationaryItem.getItem().name??""]),
                  style: widget.theme.textTheme.bodyText2,)

        ],
      ),
    );
  }
}


















