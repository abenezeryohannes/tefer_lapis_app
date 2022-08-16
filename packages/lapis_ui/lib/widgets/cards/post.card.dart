import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/fundraiser.item.model.dart';
import 'package:domain/models/post.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:lapis_ui/widgets/button.big.dart';
import 'package:shimmer/shimmer.dart';
import 'package:util/RequestHandler.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/widgets/cards/fundraiser.progress.dart';
import 'package:lapis_ui/widgets/tag.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key? key, required this.post,
    required this.onClick, required this.theme, required this.tr}) : super(key: key);
  final PostModel post;
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final void Function(PostModel) onClick;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {

    return Card(
      semanticContainer: true,
      color: widget.theme.scaffoldBackgroundColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell( onTap: (){ widget.onClick(widget.post); },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  // Text(widget.post.getUser().full_name ?? "", style: widget.theme.textTheme.bodyText1),
                  // const SizedBox(height: 5,),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //       Icon(Icons.add_location, color: widget.theme.colorScheme.onBackground, size: 14,),
                  //       const SizedBox(width: 3,),
                  //       Text(widget.post.getUser().getLocation().address ?? "", style: widget.theme.textTheme.caption),
                  //   ],
                  // ),
                  const SizedBox(height: 5,),
                  Hero(
                    tag: "post_image"+(widget.post.id.toString()),
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.width,
                      height: 240.0,
                      imageUrl: RequestHandler.baseImageUrl+(widget.post.image??""),
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) => Container(
                        width: MediaQuery.of(context).size.width,
                        height: 240.0,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                                  borderRadius: BorderRadius.circular(16),
                                )),
                          )
                      ),
                      errorWidget: (context, url, error) => Container(
                          width: MediaQuery.of(context).size.width,
                          height: 240.0,
                          alignment: Alignment.center,
                          child: const Icon(Icons.error)),
                    ),
                  ),
                  // Image.network( RequestHandler.baseImageUrl+(widget.post.image??""),
                  //   fit: BoxFit.fill, width: MediaQuery.of(context).size.width,),
                  const SizedBox(height:10),
                  // Text(widget.post.title ?? "", style: widget.theme.textTheme.bodyText1),
                  // const SizedBox(height:10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(widget.post.caption ?? "", style: widget.theme.textTheme.caption),
                  ),
                  const SizedBox(height:10),
            ]
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      margin: const EdgeInsets.fromLTRB(0,0,0,10),
    );
  }

}
