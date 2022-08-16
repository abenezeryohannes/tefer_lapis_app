import 'package:domain/models/activity.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/fundraiser.item.model.dart';
import 'package:domain/models/post.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:lapis_ui/widgets/button.big.dart';
import 'package:util/RequestHandler.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/widgets/cards/fundraiser.progress.dart';
import 'package:lapis_ui/widgets/tag.dart';

class ActivityCard extends StatefulWidget {
  const ActivityCard({Key? key, this.show_image = true,
    required this.onClick, required this.theme, required this.tr, required this.activity}) : super(key: key);
  final ActivityModel activity;
  final ThemeData theme;
  final bool show_image;
  final String Function(String, {List<String> args}) tr;
  final void Function(ActivityModel) onClick;

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  @override
  Widget build(BuildContext context) {
    return  (widget.activity.type=="fundraiser")?
            _buildFundraiser(widget.activity.getFundraiser()):
            _buildPost(widget.activity.getPost());
  }

  List<Widget> buildTag(List<FundraiserItemModel> fundraiserItem ){
    return fundraiserItem.map<Widget>( (x) =>  Tag(fundraiserItem: x,theme: widget.theme,tr: widget.tr) ).toList() ;
  }

  Widget _buildFundraiser(FundraiserModel fundraiser){
    return   Card(
      semanticContainer: true,
      color: widget.theme.cardColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell( onTap: (){ widget.onClick(widget.activity); },
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Flexible(
                fit: FlexFit.loose,
                flex: 4,
                child: Stack(
                  children: [
                    Container(
                      // color: Colors.red,
                      decoration: BoxDecoration(

                        image: DecorationImage(
                          opacity: 0.8,
                            image: NetworkImage( RequestHandler.baseImageUrl+(widget.activity.getFundraiser() .image??"") ),
                          fit: BoxFit.cover
                        )
                      ),
                      constraints: const BoxConstraints.expand()
                    ),


                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: MediaQuery.of(context).size.width*1/2,
                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        decoration: BoxDecoration(
                          gradient:  LinearGradient(
                            begin: Alignment.center,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              Colors.transparent.withOpacity(0.2),
                              widget.theme.cardColor
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                )
                // Image.network(
                //
                //   RequestHandler.baseImageUrl+(widget.activity.getFundraiser()
                //       .image??""), fit: BoxFit.contain, //height: 100,
                //  //width: MediaQuery.of(context).size.width/4,
                // ),
              ),
              // if(widget.show_image) const SizedBox(height:20),

              Flexible(
                fit: FlexFit.loose,
                flex: 8,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.activity.getUser().full_name ?? "", style: widget.theme.textTheme.subtitle2),
                        const SizedBox(height: 5,),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Icon(Icons.add_location, color: widget.theme.colorScheme.onBackground, size: 14,),
                        //     const SizedBox(width: 3,),
                        //     Text(widget.activity.getUser().getLocation().address ?? "", style: widget.theme.textTheme.caption),
                        //   ],
                        // ),
                        // const SizedBox(height: 16,),

                        Text(fundraiser.title ?? "", style: widget.theme.textTheme.bodyText2),
                        const SizedBox(height:10),

                        Text(fundraiser.description ?? "", maxLines: 2, style: widget.theme.textTheme.subtitle2),
                        const SizedBox(height:14),

                        // Flexible(
                        //   child: Wrap(
                        //     spacing: 3,
                        //     runSpacing: 3,
                        //     direction: Axis.horizontal,
                        //     children: buildTag(fundraiser.getFundraiserItems()),
                        //   ),
                        // ),

                        // const SizedBox(height: 20),
                        // Column(
                        //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //
                        //     FundraiserProgress(fundraiser: fundraiser, type: "min",
                        //         theme: widget.theme, tr: widget.tr),
                        //     const SizedBox(height: 10),
                        //     Container(
                        //         alignment: Alignment.bottomRight,
                        //         height: 30,
                        //         child: ButtonBig(onClick: () => { },
                        //           child: Text( widget.tr("give_away"), style: widget.theme.textTheme.overline, ), theme: widget.theme, width: "min",)
                        //     ),
                        //     // const SizedBox(height: 10),
                        //   ],
                        // ),

                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
    );
  }

  Widget _buildPost(PostModel post){
    return Card(
      semanticContainer: true,
      color: widget.theme.cardColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell( onTap: (){ widget.onClick(widget.activity); },
        child: IntrinsicHeight(
          child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [


              Flexible(
                  fit: FlexFit.loose,
                  flex: 4,
                  child: Stack(
                    children: [
                      Container(
                        // color: Colors.red,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage( RequestHandler.baseImageUrl+(post.image??"")),
                                  fit: BoxFit.cover
                              )
                          ),
                          constraints: const BoxConstraints.expand()
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: MediaQuery.of(context).size.width*1/2,
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          decoration: BoxDecoration(
                            gradient:  LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.centerRight,
                              colors: <Color>[
                                Colors.transparent.withOpacity(0.2),
                                widget.theme.cardColor
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  )
                // Image.network(
                //
                //   RequestHandler.baseImageUrl+(widget.activity.getFundraiser()
                //       .image??""), fit: BoxFit.contain, //height: 100,
                //  //width: MediaQuery.of(context).size.width/4,
                // ),
              ),


              Flexible(
                flex: 8,
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.activity.getUser().full_name ?? "", style: widget.theme.textTheme.subtitle2),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              Icon(Icons.add_location, color: widget.theme.colorScheme.onBackground, size: 14,),
                              const SizedBox(width: 3,),
                              Text(widget.activity.getUser().getLocation().address ?? "", style: widget.theme.textTheme.caption),
                          ],
                        ),
                        // const SizedBox(height: 10,),
                        // Image.network( RequestHandler.baseImageUrl+(post.image??""),
                        //   fit: BoxFit.fill, width: MediaQuery.of(context).size.width,),
                        // const SizedBox(height:20),
                        // Text(widget.post.title ?? "", style: widget.theme.textTheme.bodyText1),
                        const SizedBox(height:10),
                        Text(post.caption ?? "", style: widget.theme.textTheme.bodyText2),
                        const SizedBox(height:10),
                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
    );
  }
}
