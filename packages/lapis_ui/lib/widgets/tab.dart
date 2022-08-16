import 'package:flutter/material.dart';

class MyTab extends StatefulWidget {
  const MyTab({ Key? key,required this.theme,required this.items,
                  required this.selected, required this.onChange
            }) : super(key: key);

  final ThemeData theme;
  final int selected;
  final List<TabItem> items;
  final Function onChange;

  @override
  State<MyTab> createState() => _MyTabState();
}

class TabItem{
    String name;
    String? url;
    String? asset;
    IconData? icon;
    String? type;
    TabItem({ required this.name, this.icon, this.asset, this.url, this.type = "regular" });
}

class _MyTabState extends State<MyTab> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 10,
        runSpacing: 15,
        direction: Axis.horizontal,
        children: _buildItems(widget.selected)
    );
  }


  List<Widget> _buildItems(int selected){
    return widget.items.map((e) =>
      //   InkWell(
      //     onTap: (){  widget.onChange( widget.items.indexOf(e));  },
      //     child: Container(
      //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(10),
      //       color: e == widget.items[widget.selected]?
      //       widget.theme.colorScheme.secondary:
      //       Colors.transparent,
      //     ),
      //     child: Rren: [
      //         Image.asset( "assets/"+e.icon!, fit: BoxFit.fill, height: 16, width: 16, ),
      //         coow(
      //           mainAxisSize: MainAxisSize.min,
      //           childnst SizedBox( width: 8, ),
      //         Text(e.name, style: e == widget.items[widget.selected]?
      //                                   widget.theme.textTheme.overline:
      //                                   widget.theme.textTheme.subtitle2 )
      //       ],
      //     )
      //     ),
      // )
    //
      Row(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  // elevation: e == widget.items[widget.selected]? 5 : 0,
                  primary:  e == widget.items[widget.selected]?
                            widget.theme.colorScheme.secondary: widget.theme.scaffoldBackgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  shape: (e.type=="main") ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),
                  side: BorderSide(width: 2, color: widget.theme.colorScheme.secondary))
                      : StadiumBorder( side: BorderSide(width: 2, color: widget.theme.colorScheme.secondary) ),
                ),
                onPressed: () => { widget.onChange( widget.items.indexOf(e)) },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (e.asset!=null)?Image.asset( e.asset!, fit: BoxFit.fill, height: 16, width: 16, )
                    :(e.url!=null)?Image.network( e.url!, fit: BoxFit.fill, height: 16, width: 16, )
                    :(e.icon!=null)?Icon(e.icon!, size: 16, color: e == widget.items[widget.selected]?
                          widget.theme.colorScheme.onSecondary
                        : widget.theme.colorScheme.onBackground, ):
                    const SizedBox( width: 0, )

                    ,if(e.asset!=null||e.url!=null||e.icon!=null) const SizedBox( width: 8, ),
                    Text(e.name, style: e == widget.items[widget.selected]?
                   TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: widget.theme.colorScheme.onSecondary):
                    widget.theme.textTheme.caption )
                  ],
                )),
          if(e.type=="main")
            Container(color: widget.theme.dividerColor,
              margin: const EdgeInsets.fromLTRB(8, 0, 0, 0), width: 1, height: 28)
        ],
      )
    ).toList();
  }
}
