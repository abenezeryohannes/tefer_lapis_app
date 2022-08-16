import 'package:domain/controllers/donor.request.dart';
import 'package:domain/controllers/school.request.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/post.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';

import '../../pages/post.page.dart';
import '../../widgets/cards/post.card.dart';
import '../../widgets/lazy.listview.dart';


class SchoolPostListFragment extends StatefulWidget {
  const SchoolPostListFragment({Key? key,
    required this.theme, required this.tr, required this.user, required this.school}) : super(key: key);

  final ThemeData theme;
  final UserModel user;
  final UserModel school;
  final String Function(String, {List<String> args}) tr;
  // final Function(String) onChanged;

  @override
  State<SchoolPostListFragment> createState() => _SchoolPostListFragmentState();
}

class _SchoolPostListFragmentState extends State<SchoolPostListFragment> {

  late Future<PaginationModel?> postPagination;

  @override
  void initState() {
    super.initState();
    postPagination = SchoolRequest(widget.user).getPosts(id: widget.school.id??0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LazyListView(tr: widget.tr,onRetry: (){_onLoadingMore(null, 1);},
        pagination: postPagination, loadMore: (pagination, page) async{
      _onLoadingMore(pagination, page);
    }, item: (data) =>  //const SizedBox(height: 3),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child:   Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: PostCard(
            onClick: (post){  _onItemClick(post);},
            theme: widget.theme, tr: widget.tr, post: data
          ),
      ),
      ),
        theme: widget.theme );
  }

  void _onLoadingMore(pagination, page){
    setState(() {
      postPagination = SchoolRequest(widget.user)
          .getPosts(id:widget.school.id??0, pagination: pagination, page: page );
    });
  }


  void _onItemClick(PostModel post){
    Navigator.push( context, MaterialPageRoute(builder: (context) => PostPage(
      theme: widget.theme, post: post,) ));
  }

}

