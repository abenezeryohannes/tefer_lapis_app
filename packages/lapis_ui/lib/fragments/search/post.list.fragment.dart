import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/post.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/intro/donation.page.intro.dart';
import 'package:lapis_ui/pages/post.page.dart';
import 'package:lapis_ui/widgets/cards/donation.card.dart';
import 'package:lapis_ui/widgets/cards/school.card.dart';

import '../../widgets/cards/post.card.dart';
import '../../widgets/lazy.listview.dart';


class PostListFragment extends StatefulWidget {
  const PostListFragment({Key? key,
    required this.theme, required this.tr,required this.search, required this.user}) : super(key: key);

  final ThemeData theme;
  final UserModel user;
  final String search;

  final String Function(String, {List<String> args}) tr;
  // final Function(String) onChanged;

  @override
  State<PostListFragment> createState() => _PostListFragmentState();
}

class _PostListFragmentState extends State<PostListFragment> {

  late Future<PaginationModel?> postPagination;
  String _search ="";

  @override
  void initState() {
    _load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _load() {
    postPagination = DonorRequest(widget.user).getPosts(search: widget.search);
  }

  @override
  Widget build(BuildContext context) {
    if(_search!=widget.search){_search=widget.search; _load();}

    return LazyListView( tr: widget.tr,
        onRetry: (){_onLoadingMore(null, 1);},
        onNoData:  widget.tr("no_data", args: [widget.tr("post") + " "+ widget.tr("uploaded").toLowerCase()]),
        pagination: postPagination, loadMore: (pagination, page) async{
      _onLoadingMore(pagination, page);
    }, item: (data) =>  //const SizedBox(height: 3),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: PostCard(
          onClick: (post){  _onItemClick(post);},
          theme: widget.theme, tr: widget.tr, post: data
        ),
      ),
        theme: widget.theme );
  }

  void _onLoadingMore(pagination, page){
    setState(() {
      postPagination = DonorRequest(widget.user)
          .getPosts( pagination: pagination, page: page, search: widget.search );
    });
  }


  void _onItemClick(PostModel post){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PostPage(
      theme: widget.theme, post: post,) ));
  }

}

