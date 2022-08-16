import 'package:domain/models/donation.item.model.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.item.model.dart';
import 'package:domain/models/stationary.item.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ItemForm extends StatefulWidget {
  const ItemForm({Key? key, required this.fundraiserItem,
        required this.onChanged, required this.theme, required this.donationItem,
        required this.tr}) : super(key: key);
  final FundraiserItemModel fundraiserItem;
  final DonationItemModel donationItem;
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final Function(String) onChanged;

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
                  child: TextFormField(
                          controller: controller,
                          onChanged: (val){
                            int? value = (int.tryParse(val));
                            if(value == null) {
                              widget.onChanged("0");
                            } else if(value < 0) {
                              setState(() {controller.text = "0";});
                            } else if(value > (widget.fundraiserItem.quantity??0) - (widget.fundraiserItem.donated??0)) {
                              setState(() {controller.text = "${(widget.fundraiserItem.quantity??0) - (widget.fundraiserItem.donated??0)}";});
                            }
                            else {
                              widget.onChanged(val);
                            }
                            },
                          style: widget.theme.textTheme.button,
                          decoration: InputDecoration(
                              hintText: '${(widget.fundraiserItem.quantity??0) - (widget.fundraiserItem.donated??0)}',
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              suffixIconConstraints: const BoxConstraints(maxWidth: 32, maxHeight: 24),
                              suffixIcon: Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Image.network( "http://10.0.2.2:3000/api/v1/media?path="+(widget.fundraiserItem.getItem().image??""),
                                  fit: BoxFit.fill, height: 24, width: 24,),
                              ),
                              constraints: const BoxConstraints(maxHeight: 42),
                              filled: true, fillColor: Colors.white,
                              hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]),
                              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                              contentPadding: const EdgeInsets.symmetric( horizontal: 10, vertical: 8),
                              //errorText: !validPhoneNumber ? widget.tr('field_required') : null,
                        )
                    )
                ),

          const SizedBox(width: 20,),
          Text(widget.tr('out_of', args: ['${widget.donationItem.quantity}', '${ widget.fundraiserItem.quantity}', widget.fundraiserItem.getItem().name??""]),
                  style: widget.theme.textTheme.bodyText2,)

        ],
      ),
    );
  }
}


















