import 'package:domain/controllers/driver.request.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/pages/driver.donation.page.dart';
import 'package:lapis_ui/widgets/cards/driver.donation.card.dart';
import 'package:lapis_ui/widgets/cards/driver.donation.card.mini.dart';
import 'package:lapis_ui/widgets/lazy.listview.dart';

class SubscribedDonationDriver extends StatefulWidget {
  const SubscribedDonationDriver({Key? key,
    required this.user,
    required this.theme,
    required this.tr})
      : super(key: key);

  final UserModel user;
  final ThemeData theme;
  // final Function(PaginationModel pagination, int page) loadMore;
  final String Function(String, {List<String> args}) tr;

  @override
  State<SubscribedDonationDriver> createState() => _SubscribedDonationDriverState();
}

class _SubscribedDonationDriverState extends State<SubscribedDonationDriver> {

  late Future<PaginationModel?> searchPagination;
  String _search = "";

  @override
  void initState() {
    _load();
    super.initState();
  }

  void _load() {
    searchPagination = DriverRequest(widget.user).getSubscribedDonations(page: 1, search: _search);
  }
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        LazyListView(
            tr: widget.tr,
            onRetry: () async{
              setState(() { searchPagination =
                  DriverRequest(widget.user).getSubscribedDonations(page: 1, search: _search); });
              },
            pagination: searchPagination,
            onNoData: widget.tr("subscribe_for_driver_data"),
            loadMore: (pagination, page) async{ _onLoadingMore(pagination, page);},
            item: (data) =>   DriverDonationCardMini(
              onClick: (donation){  _onItemClick(donation);},
              theme: widget.theme, tr: widget.tr, donation: data,
            ),
            theme: widget.theme ),
      ],
    );
  }

  void _onLoadingMore(pagination, page){
    setState(() {
      searchPagination = DriverRequest(widget.user)
          .getSubscribedDonations( pagination: pagination, page: page);
    });
  }

  void _onItemClick(DonationModel donation){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DriverDonationPage(tr: widget.tr, theme: widget.theme,
      donation: donation, user: widget.user, onChange: () {
        _onLoadingMore(null, 1);
      }, fundraiser: donation.getFundraiser(),) ));
  }

}
