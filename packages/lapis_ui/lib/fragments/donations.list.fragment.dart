import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/intro/donation.page.intro.dart';
import 'package:lapis_ui/widgets/cards/donation.card.dart';

import '../intro/Stationaries.intro.dart';
import '../pages/donation.page.dart';
import '../widgets/lazy.listview.dart';

class DonationListFragment extends StatefulWidget {
  const DonationListFragment({Key? key,
    required this.theme, required this.tr, required this.user, required this.onEnd}) : super(key: key);

  final ThemeData theme;
  final UserModel user;
  final void Function() onEnd;
  final String Function(String, {List<String> args}) tr;
  // final Function(String) onChanged;

  @override
  State<DonationListFragment> createState() => _DonationListFragmentState();
}

class _DonationListFragmentState extends State<DonationListFragment> {

  late Future<PaginationModel?> donorPage;

  @override
  void initState() {
    super.initState();
    donorPage = DonorRequest(widget.user).getDonations(page: 1, limit: 5);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LazyListView( tr: widget.tr,onRetry: (){_onLoadingMore(null, 1);},
              pagination: donorPage, loadMore: (pagination, page) async{
                _onLoadingMore(pagination, page);
          }, item: (data) =>  //const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: DonationCard(
                    user: widget.user,
                    onClick: (donation){  _onItemClick(donation);},
                    theme: widget.theme, tr: widget.tr, donation: data, onChange: (){_onLoadingMore(null, 1);},
                    onLoadingChange: (bool ) {  },
                  ),
                ),
              theme: widget.theme );
  }

  void _onLoadingMore(pagination, page){
    setState(() {
      donorPage = DonorRequest(widget.user)
          .getDonations(
          pagination: pagination,
          page: page,
          limit: 5 );
    });
  }


  void _onItemClick(DonationModel donation){
    if(donation.stationary_user_id==null){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) =>
          StationariesIntro(tr: widget.tr,
              theme: widget.theme,
              onEnd: widget.onEnd,
              donation: donation,
              fundraiser: donation.getFundraiser(),
              user: widget.user)));
    }else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DonationPage(tr: widget.tr, theme: widget.theme,
        fundraiser: donation.getFundraiser(), user: widget.user, donation: donation, onEnd: () {  },) ));
    }
  }

}

