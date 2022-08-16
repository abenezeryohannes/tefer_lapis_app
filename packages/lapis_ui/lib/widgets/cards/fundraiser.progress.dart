
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/fundraiser.item.model.dart';
import 'package:flutter/material.dart';

class FundraiserProgress extends StatefulWidget {
  const FundraiserProgress({Key? key, required this.fundraiser,this.showText = true, required this.theme, required this.tr, this.type = "max"}) : super(key: key);
  final FundraiserModel fundraiser;
  final ThemeData theme;
  final String type;
  final bool showText;
  final String Function(String) tr;

  @override
  State<FundraiserProgress> createState() => _FundraiserProgressState();
}

class _FundraiserProgressState extends State<FundraiserProgress> {

  late double percent;

  @override
  Widget build(BuildContext context) {
   percent =  MediaQuery.of( context ).size.width *
        ( ((widget.fundraiser.donated_items_count??0*100)/(widget.fundraiser.items_count??1)) );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(widget.fundraiser.donated_items_count!=null&&widget.showText&&widget.fundraiser.donated_items_count!>0)
            Text("${widget.fundraiser.donated_items_count} ${widget.tr("of")} ${widget.fundraiser.items_count} ${widget.tr("materials")}" ,
                  style: (widget.type=="max")?widget.theme.textTheme.subtitle2:widget.theme.textTheme.caption)
            else if(widget.showText)
              Text(widget.tr("no_donations_yet"),
              style: (widget.type=="max")?widget.theme.textTheme.subtitle2:widget.theme.textTheme.caption),

            if(widget.fundraiser.donated_items_count!=null&&widget.fundraiser.donated_items_count!>0)
              Text("${((widget.fundraiser.donated_items_count??0*100)/(widget.fundraiser.items_count??1))} %",
                style: (widget.type=="max")?widget.theme.textTheme.subtitle2:widget.theme.textTheme.caption)
          ],
        ),
        const SizedBox( height: 10,),
        Container(
            height: (widget.type=="max")?8:4,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              border: Border.all( color: widget.theme.dividerColor.withOpacity(0.4) ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: widget.theme.cardColor,
          ),
          child: Container( height: (widget.type=="max")?8:4,
                    width: percent,
                    decoration: BoxDecoration(
                        border: Border.all( color: widget.theme.dividerColor ),
                        borderRadius: const BorderRadius.all( Radius.circular(10) ),
                        color: Colors.green
                        // color: ((percent*100/MediaQuery.of(context).size.width)<25)?Colors.redAccent:
                        // ((percent*100/MediaQuery.of(context).size.width)<60)? Colors.amber: Colors.blueAccent ,
                    ),
                  )
        )
      ],
    );
  }
}
