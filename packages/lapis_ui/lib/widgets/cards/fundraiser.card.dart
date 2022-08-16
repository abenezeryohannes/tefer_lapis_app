import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/fundraiser.item.model.dart';
import 'package:lapis_ui/widgets/button.big.dart';
import 'package:shimmer/shimmer.dart';
import 'package:util/RequestHandler.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/widgets/cards/fundraiser.progress.dart';
import 'package:lapis_ui/widgets/tag.dart';

import '../../pages/school.page.dart';

class FundraiserCard extends StatefulWidget {
  const FundraiserCard({Key? key, required this.fundraiser, this.show_image = true,
    this.show_school = true,
    required this.onClick, required this.theme, required this.tr, required this.onSchoolClick}) : super(key: key);
  final FundraiserModel fundraiser;
  final ThemeData theme;
  final bool show_image;
  final bool show_school;
  final Function(FundraiserModel) onSchoolClick;
  final String Function(String, {List<String> args}) tr;
  final void Function(FundraiserModel) onClick;

  @override
  State<FundraiserCard> createState() => _FundraiserCardState();
}

class _FundraiserCardState extends State<FundraiserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      color: widget.theme.backgroundColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell( onTap: (){ widget.onClick(widget.fundraiser); },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,5,0,15),
          child: Stack(

            children: [ 

              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if(widget.show_school)
                            InkWell(
                              onTap: (){ widget.onSchoolClick(widget.fundraiser);},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: RequestHandler.baseImageUrl+(widget.fundraiser.image??""),
                                      fit: BoxFit.cover,
                                      imageBuilder: (context, imageProvider) => Container(
                                        width: 32.0, height: 32.0,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                                          image: DecorationImage(
                                              image: imageProvider, fit: BoxFit.cover),
                                        ),
                                      ),
                                      placeholder: (context, url) => SizedBox(
                                          width: 32.0, height: 32.0,
                                          child: Shimmer.fromColors(
                                            baseColor: widget.theme.cardColor.withOpacity(0.5),
                                            highlightColor: widget.theme.cardColor.withOpacity(1),
                                            child: Card( elevation: 1.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(16),
                                                )),
                                          )
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                          width: 32.0,  height: 32.0,
                                          alignment: Alignment.center,
                                          child: Icon(Icons.error, color: widget.theme.dividerColor)
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 3),
                                          child: Text(
                                              widget.fundraiser.getUser().full_name ?? "",
                                              style: widget.theme.textTheme.bodyText2
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.add_location, color: widget.theme.dividerColor, size: 14,),
                                            const SizedBox(width: 3,),
                                            Text(widget.fundraiser.getUser().getLocation().address ?? "",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.normal,
                                                  color: widget.theme.dividerColor
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // ElevatedButton(
                            //     style: ElevatedButton.styleFrom(
                            //         primary: widget.theme.cardColor,
                            //
                            //         side: BorderSide(color: widget.theme.highlightColor),
                            //         minimumSize:  const Size(0, 20),
                            //         shape: const StadiumBorder()
                            //     ),
                            //     onPressed: () => { },
                            //     child: Padding(
                            //       padding: const EdgeInsets.symmetric(vertical: 5.0),
                            //       child: Row(
                            //
                            //         children: [
                            //           Text(widget.tr('follow'), style: TextStyle(
                            //               fontSize: 12,
                            //               fontWeight: FontWeight.bold,
                            //               color: widget.theme.colorScheme.secondary
                            //           ),),
                            //           const SizedBox(width:2 ),
                            //           Icon(Icons.add, color: widget.theme.colorScheme.secondary, size: 14,)
                            //         ],
                            //       ),
                            //     )
                            // )

                          ],
                        ),
                      ),
                      const SizedBox(height: 5,),

                      if(widget.show_image)Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Hero(
                          tag: "fundraiser_"+widget.fundraiser.id.toString(),
                          child: CachedNetworkImage(
                            imageUrl: RequestHandler.baseImageUrl+(widget.fundraiser.image??""),
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) => Container(
                              width: MediaQuery.of(context).size.width,
                              height: 240.0,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) => SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 240.0,
                                child: Shimmer.fromColors(
                                  baseColor: widget.theme.cardColor.withOpacity(0.5),
                                  highlightColor: widget.theme.cardColor.withOpacity(1),
                                  child: Card(
                                      elevation: 1.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                )
                            ),
                            errorWidget: (context, url, error) => Container(
                                width: MediaQuery.of(context).size.width,
                                height: 240.0,
                                alignment: Alignment.center,
                                child:  Icon(Icons.error_outline, color: widget.theme.dividerColor)),
                          ),
                        ),
                      ),

                  if(widget.show_image)const SizedBox(height:12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Hero(
                      tag: "fundraiser_title"+widget.fundraiser.id.toString(),
                      child: Text(widget.fundraiser.title ?? "", style:TextStyle(
                        color: widget.theme.colorScheme.onBackground, overflow: TextOverflow.ellipsis,
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                      )),
                    ),
                  ),
                  const SizedBox(height:8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Hero(
                      tag: "fundraiser_description"+widget.fundraiser.id.toString(),
                      child: Text(widget.fundraiser.description ?? "", overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: widget.theme.textTheme.subtitle2),
                    ),
                  ),
                  const SizedBox(height:12),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 3,
                        direction: Axis.horizontal,
                        children: buildTag(widget.fundraiser.getFundraiserItems()),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible( flex: 2, fit: FlexFit.tight, child:
                        FundraiserProgress(fundraiser: widget.fundraiser,
                            theme: widget.theme, tr: widget.tr)),

                        const SizedBox(width: 30),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(widget.tr('raised'),
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                              ),),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,0,0,0),
                              child: Text(widget.tr('cash', args: [widget.fundraiser.donated_amount??'0']),
                                style: widget.theme.textTheme.bodyText2,),
                            ),
                          ],
                        ),

                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(widget.tr('donated'),
                        //       style: const TextStyle(
                        //           color: Colors.green,
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 14
                        //       ),),
                        //     const SizedBox(height: 3),
                        //     Text(widget.tr('items', args: [(widget.fundraiser.donated_items_count??0).toString()]),
                        //       style: widget.theme.textTheme.bodyText2,),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //
                  //       Flexible( flex: 2, fit: FlexFit.tight, child:
                  //         FundraiserProgress(fundraiser: widget.fundraiser,
                  //             theme: widget.theme, tr: widget.tr)),
                  //
                  //       // Flexible(
                  //       //   flex: 1,
                  //       //   fit: FlexFit.loose,
                  //       //   child: SizedBox(
                  //       //     height: 30,
                  //       //     child: ButtonBig(onClick: () => { },
                  //       //       child: Text( widget.tr("give_away"), style: widget.theme.textTheme.overline, ), theme: widget.theme, width: "min",)
                  //       //   ),
                  //       // ),
                  //
                  //     ],
                  //   ),
                  // ),

                ]
              ),

            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.5,
      margin: const EdgeInsets.fromLTRB(0,0,0,16),
    );
  }

  List<Widget> buildTag(List<FundraiserItemModel> fundraiserItem ){
    return fundraiserItem.map<Widget>( (x) =>  Tag(fundraiserItem: x,theme: widget.theme,tr: widget.tr) ).toList() ;
  }
}
