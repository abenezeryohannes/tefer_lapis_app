import 'package:domain/controllers/donor.request.dart';
import 'package:domain/controllers/school.request.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';

import '../../intro/fundraiser.page.intro.dart';
import '../../pages/school.page.dart';
import '../../widgets/cards/fundraiser.card.dart';
import '../../widgets/lazy.listview.dart';


class SchoolFundraiserListFragment extends StatefulWidget {
  const SchoolFundraiserListFragment({Key? key,
    required this.theme, required this.tr, required this.user, required this.school}) : super(key: key);

  final ThemeData theme;
  final UserModel user;
  final UserModel school;
  final String Function(String, {List<String> args}) tr;

  @override
  State<SchoolFundraiserListFragment> createState() => _SchoolFundraiserListFragmentState();
}

class _SchoolFundraiserListFragmentState extends State<SchoolFundraiserListFragment> {

  late Future<PaginationModel?> fundraiserPagination;

  @override
  void initState() {
    super.initState();
    fundraiserPagination = SchoolRequest(widget.user).getFundraisers( id: widget.school.id??0);
  }

  @override
  void dispose() { super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return LazyListView( tr: widget.tr,onRetry: (){_onLoadingMore(null, 1);},
              pagination: fundraiserPagination, loadMore: (pagination, page) async{
              _onLoadingMore(pagination, page);
          },
        onNoData:  widget.tr("no_data", args: [widget.tr("fundraisers") + " "+ widget.tr("uploaded").toLowerCase()]),
        item: (data) =>  //const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: FundraiserCard( //show_image: false,
              show_school: false,
              onSchoolClick: (fundraiser ) { _onSchoolClick(fundraiser); },
                onClick: (fundraiser){  _onItemClick(fundraiser);},
                theme: widget.theme, tr: widget.tr, fundraiser: data,
              ),
          ),
        theme: widget.theme );
  }

  void _onLoadingMore(pagination, page){
    setState(() {
      fundraiserPagination = SchoolRequest(widget.user)
          .getFundraisers(id:widget.school.id??0, pagination: pagination, page: page );
    });
  }

  void _onItemClick(FundraiserModel fundraiser){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) =>
        FundraiserIntroPage(
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
    } }

}

