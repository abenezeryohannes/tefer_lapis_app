import 'package:domain/models/post.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:util/RequestHandler.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key,
    required this.theme,
    required this.post,
  })
      : super(key: key);

  final PostModel post;
  final ThemeData theme;


  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Stack(
              children: [

                Hero(
                  tag: "post_image"+(widget.post.id.toString()),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('${RequestHandler.baseImageUrl}${widget.post.image}'),
                      ),
                    ),
                  ),
                ),


                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height/3,
                    decoration: BoxDecoration(
                      gradient:  LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.transparent,
                          widget.theme.backgroundColor
                        ],
                      ),
                    ),
                  ),
                ),


                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height/3,
                    decoration: BoxDecoration(
                      gradient:  LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: <Color>[
                          Colors.transparent,
                          widget.theme.backgroundColor
                        ],
                      ),
                    ),
                  ),
                ),


                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 29),
                    child: IconButton(
                        icon: const Icon(Icons.cancel,),
                        color: widget.theme.colorScheme.onBackground,
                        onPressed: () {
                          Navigator.maybePop(context);
                        }),
                  ),
                ),


                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(widget.post.caption??"",
                        style: TextStyle(fontSize: 18, color: widget.theme.colorScheme.onBackground)),
                  ),
                )

              ],
            ),
    );
  }
}
