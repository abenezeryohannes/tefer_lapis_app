import 'package:domain/controllers/donor.request.dart';
import 'package:domain/controllers/driver.request.dart';
import 'package:domain/controllers/school.request.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';

import '../../intro/fundraiser.page.intro.dart';
import '../../pages/driver.donation.page.dart';
import '../../pages/school.page.dart';
import '../../widgets/cards/driver.donation.card.dart';
import '../../widgets/cards/fundraiser.card.dart';
import '../../widgets/lazy.listview.dart';


class SchoolDonationListFragment extends StatefulWidget {
  const SchoolDonationListFragment({Key? key,
    required this.theme, required this.tr, required this.user, required this.school}) : super(key: key);

  final ThemeData theme;
  final UserModel user;
  final UserModel school;
  final String Function(String, {List<String> args}) tr;

  @override
  State<SchoolDonationListFragment> createState() => _SchoolDonationListFragmentState();
}

class _SchoolDonationListFragmentState extends State<SchoolDonationListFragment> {

  late Future<PaginationModel?> donationPagination;

  @override
  void initState() {
    _load();
    super.initState();
  }

  void _load() {
    donationPagination = SchoolRequest(widget.user).getDonations(page: 1, id: widget.school.id??0 );
  }

  @override
  Widget build(BuildContext context) {
    return LazyListView( tr: widget.tr,onRetry: (){_onLoadingMore(null, 1);},
              pagination: donationPagination, loadMore: (pagination, page) async{
              _onLoadingMore(pagination, page);
          },
        onNoData:  widget.tr("no_data", args: [widget.tr("donations") + " "+ widget.tr("").toLowerCase()]),
        item: (data) =>  //const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: DriverDonationCard(
              onClick: (donation){  _onItemClick(donation);},
              theme: widget.theme, tr: widget.tr, donation: data, ),
          ),
        theme: widget.theme );
  }


  void _onLoadingMore(pagination, page){
    setState(() {
      donationPagination = DriverRequest(widget.user) .getDonations( pagination: pagination, page: page );
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

