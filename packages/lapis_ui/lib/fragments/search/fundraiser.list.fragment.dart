import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/intro/donation.page.intro.dart';
import 'package:lapis_ui/widgets/cards/donation.card.dart';
import 'package:lapis_ui/widgets/cards/school.card.dart';

import '../../intro/fundraiser.page.intro.dart';
import '../../pages/school.page.dart';
import '../../widgets/cards/fundraiser.card.dart';
import '../../widgets/lazy.listview.dart';


class FundraiserListFragment extends StatefulWidget {
  const FundraiserListFragment({Key? key,
    required this.theme, required this.tr,required this.search, required this.user}) : super(key: key);

  final ThemeData theme;
  final UserModel user;
  final String search;

  final String Function(String, {List<String> args}) tr;
  // final Function(String) onChanged;

  @override
  State<FundraiserListFragment> createState() => _FundraiserListFragmentState();
}

class _FundraiserListFragmentState extends State<FundraiserListFragment> {

  late Future<PaginationModel?> fundraiserPagination;
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
    fundraiserPagination = DonorRequest(widget.user).getFundraisers(search: widget.search);
  }

  @override
  Widget build(BuildContext context) {
    if(_search!=widget.search){_search=widget.search; _load();}

    return LazyListView( tr: widget.tr,onRetry: (){_onLoadingMore(null, 1);},
        pagination: fundraiserPagination, loadMore: (pagination, page) async{
      _onLoadingMore(pagination, page);
    }, item: (data) =>  //const SizedBox(height: 3),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: FundraiserCard( show_image: false,
        onSchoolClick: (fundraiser ) { _onSchoolClick(fundraiser); },
          onClick: (fundraiser){  _onItemClick(fundraiser);},
          theme: widget.theme, tr: widget.tr, fundraiser: data,
        ),
    ),
        theme: widget.theme );
  }

  void _onLoadingMore(pagination, page){
    setState(() {
      fundraiserPagination = DonorRequest(widget.user)
          .getFundraisers( pagination: pagination, page: page, search: widget.search );
    });
  }


  void _onItemClick(FundraiserModel fundraiser){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FundraiserIntroPage(
              tr: widget.tr, theme: widget.theme,
              fundraiser: fundraiser, user: widget.user, onEnd: () {  },
              ) ));
  }


  void _onSchoolClick(FundraiserModel fundraiser){
    if(fundraiser.getUser().id!=null) {
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => SchoolPage(
        theme: widget.theme, user: widget.user, tr: widget.tr, school: fundraiser.getUser()
    ) ));
    }
  }

}

