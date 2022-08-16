import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/models/fundraiser.item.model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:util/RequestHandler.dart';

class Tag extends StatefulWidget {
  const Tag({Key? key, required this.fundraiserItem, required this.theme, required this.tr}) : super(key: key);
  final FundraiserItemModel fundraiserItem;
  final ThemeData theme;
  final String Function(String) tr;
  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      color: widget.theme.backgroundColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: RequestHandler.baseImageUrl+(widget.fundraiserItem.getItem().image??""),
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => Container(
                  width: 18, height: 18,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => SizedBox(
                    child: Shimmer.fromColors(
                      baseColor: widget.theme.cardColor.withOpacity(0.5),
                      highlightColor: widget.theme.cardColor.withOpacity(1),
                      child: Card( elevation: 1.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          )),
                    )
                ),
                errorWidget: (context, url, error) => SizedBox(
                    child: Icon(Icons.error_outline, color: widget.theme.dividerColor,)
                ),
              ),
              //Image.network( RequestHandler.baseImageUrl+(widget.fundraiserItem.getItem().image??""), fit: BoxFit.fill, height: 18, width: 18,),
              const SizedBox(width: 5,),
              Text( (((widget.fundraiserItem.quantity??0) - (widget.fundraiserItem.donated??0)) .toString())+" "+widget.tr(widget.fundraiserItem.getItem().name??""),
                  style: widget.theme.textTheme.caption),
            ]
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    );
  }
}
