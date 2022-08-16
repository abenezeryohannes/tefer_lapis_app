import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/widgets/cards/school.card.dart';
import '../../pages/school.page.dart';
import '../../widgets/lazy.listview.dart';

class SchoolListFragment extends StatefulWidget {
  const SchoolListFragment({Key? key,
    required this.theme, required this.tr,required this.search,
    required this.user}) : super(key: key);

  final ThemeData theme;
  final UserModel user;
  final String search;

  final String Function(String, {List<String> args}) tr;
  // final Function(String) onChanged;

  @override
  State<SchoolListFragment> createState() => _SchoolListFragmentState();

}

class _SchoolListFragmentState extends State<SchoolListFragment> {

  late Future<PaginationModel?> schoolPagination;
  String _search ="";

  @override
  void initState() { _load(); super.initState(); }

  @override
  void dispose() { super.dispose(); }

  void _load() { // print("loading $_search");
    schoolPagination = DonorRequest(widget.user).getSchools(search: widget.search);
  }

  @override
  Widget build(BuildContext context) {
    print("loading search ${widget.search}");
    if(_search!=widget.search){_search=widget.search; _load();}

    return LazyListView( tr: widget.tr,onRetry: (){_onLoadingMore(null, 1);},
        pagination: schoolPagination, loadMore: (pagination, page) async{
      _onLoadingMore(pagination, page);
    }, item: (data) =>  //const SizedBox(height: 3),

    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SchoolCard(
          onClick: (school){  _onItemClick(school);}, user: widget.user,
          theme: widget.theme, tr: widget.tr, school: data,
        ),
    ), theme: widget.theme );

  }

  void _onLoadingMore(pagination, page){
    setState(() {
      schoolPagination = DonorRequest(widget.user)
          .getSchools( pagination: pagination, page: page, search: widget.search );
    });
  }

  void _onItemClick(UserModel school){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SchoolPage(
        theme: widget.theme, user: widget.user, tr: widget.tr, school: school
        ) ));
  }

}

