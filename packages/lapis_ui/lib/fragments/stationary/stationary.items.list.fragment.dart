import 'package:domain/controllers/donor.request.dart';
import 'package:domain/controllers/school.request.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/stationary.item.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/widgets/cards/stationary.card.dart';
import 'package:lapis_ui/widgets/cards/stationary.item.card.dart';

import '../../widgets/cards/fundraiser.card.dart';
import '../../widgets/lazy.listview.dart';


class StationaryItemListFragment extends StatefulWidget {
  const StationaryItemListFragment({Key? key,
    required this.theme, required this.tr,
    required this.user, required this.stationary})
      : super(key: key);

  final ThemeData theme;
  final UserModel user;
  final UserModel stationary;
  final String Function(String, {List<String> args}) tr;

  @override
  State<StationaryItemListFragment> createState() => _StationaryItemListFragmentState();
}

class _StationaryItemListFragmentState extends State<StationaryItemListFragment> {

  late Future<PaginationModel?> StationaryItemPagination;

  @override
  void initState() {
    super.initState();
    StationaryItemPagination = DonorRequest(widget.user).getStationaryItems( user_id: widget.stationary.id??0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LazyListView( tr: widget.tr,onRetry: (){_onLoadingMore(null, 1);},
              pagination: StationaryItemPagination, loadMore: (pagination, page) async{
              _onLoadingMore(pagination, page);
          }, item: (data) =>  //const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: StationaryItemCard( //show_image: false,
                onClick: (stationaryItem){  _onItemClick(stationaryItem);},
                theme: widget.theme, tr: widget.tr, stationaryItemModel: data, user: widget.user,
              ),
          ),
        theme: widget.theme );
  }

  void _onLoadingMore(pagination, page){
    setState(() {
      StationaryItemPagination = DonorRequest(widget.user)
          .getStationaryItems(user_id:widget.stationary.id??0, pagination: pagination, page: page );
    });
  }


  void _onItemClick(StationaryItemModel stationaryItem){
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => FundraiserIntroPage(tr: widget.tr, theme: widget.theme,
    //   fundraiser: donation.getFundraiser(), user: widget.user, fundraiser: fundraiser,) ));
  }

}

