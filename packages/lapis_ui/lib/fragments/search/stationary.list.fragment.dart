import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/intro/donation.page.intro.dart';
import 'package:lapis_ui/pages/stationary.page.dart';
import 'package:lapis_ui/widgets/cards/donation.card.dart';
import 'package:lapis_ui/widgets/cards/school.card.dart';
import 'package:lapis_ui/widgets/cards/search.stationary.card.dart';
import 'package:lapis_ui/widgets/cards/stationary.card.dart';

import '../../widgets/lazy.listview.dart';


class StationaryListFragment extends StatefulWidget {
  const StationaryListFragment({Key? key,
    required this.theme, required this.tr,required this.search, required this.user}) : super(key: key);

  final ThemeData theme;
  final UserModel user;
  final String search;

  final String Function(String, {List<String> args}) tr;
  // final Function(String) onChanged;

  @override
  State<StationaryListFragment> createState() => _StationaryListFragmentState();
}

class _StationaryListFragmentState extends State<StationaryListFragment> {

  late Future<PaginationModel?> stationaryPagination;
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
    stationaryPagination = DonorRequest(widget.user).getStationaries(search: widget.search);
  }

  @override
  Widget build(BuildContext context) {
    if(_search!=widget.search){_search=widget.search; _load();}
    return LazyListView( tr: widget.tr,onRetry: (){_onLoadingMore(null, 1);},
        pagination: stationaryPagination, loadMore: (pagination, page) async{
      _onLoadingMore(pagination, page);
    }, item: (data) =>  //const SizedBox(height: 3),
    SearchStationaryCard(
        onClick: (stationary){  _onItemClick(stationary);}, user: widget.user,
        theme: widget.theme, tr: widget.tr, stationary: data,
      ),
        theme: widget.theme );
  }

  void _onLoadingMore(pagination, page){
    setState(() {
      stationaryPagination = DonorRequest(widget.user)
          .getStationaries( pagination: pagination, page: page, search: widget.search );
    });
  }


  void _onItemClick(UserModel stationary){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => StationaryPage(tr: widget.tr, theme: widget.theme,
       user: widget.user, stationary: stationary,) ));
  }

}

