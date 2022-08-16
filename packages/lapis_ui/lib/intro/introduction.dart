import 'package:domain/models/donation.item.model.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/fundraiser.item.model.dart';
import 'package:domain/models/item.model.dart';
import 'package:domain/models/location.model.dart';
import 'package:domain/models/stationary.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/intro/payment.page.intro.dart';

import 'fundraisers.list.intro.dart';

class Introduction extends StatefulWidget {

  const Introduction({Key? key, required this.user, required this.theme,
    required this.tr, required this.onEnd })
      : super(key: key);

  final UserModel user; final ThemeData theme;
  final String Function(String, {List<String> args}) tr; final Function() onEnd;

  @override
  State<Introduction> createState() => _IntroductionState();

}


class _IntroductionState extends State<Introduction> {

  int selectedTab  = 0;
  @override
  Widget build(BuildContext context) {


    //
    FundraiserModel fundraiser = FundraiserModel.fresh();
    FundraiserItemModel fItem = FundraiserItemModel.fresh();
    ItemModel item = ItemModel.fresh();
    UserModel user = UserModel.fresh(full_name: "Hill Side School", );
    LocationModel location = LocationModel.fresh();

    user.Location = location;
    fItem.Item = item;
    fundraiser.FundraiserItems = [fItem, fItem, fItem, fItem, fItem, fItem, fItem];
    fundraiser.User = user;

    UserModel stationary = user;
    StationaryModel st = StationaryModel.fresh();
    // stationary.Stationary = st;
    UserModel school = user;

    DonationModel donation = DonationModel.fresh();
    donation.Stationary = stationary;
    donation.Fundraiser = fundraiser;
    DonationItemModel donItem = DonationItemModel.fresh();
    DonationItemModel donItem2 = DonationItemModel.fresh();
    DonationItemModel donItem3 = DonationItemModel.fresh();
    DonationItemModel donItem4 = DonationItemModel.fresh();
    DonationItemModel donItem5 = DonationItemModel.fresh();
     donation.DonationItems = [ donItem, donItem2, donItem3, donItem4, donItem5 ];
    //
    //
    //
    //
    //
    //
    //
    //
    //
     return FundraiserListIntro(user: widget.user,
         onEnd: widget.onEnd,theme: widget.theme, tr: widget.tr );

    // return FundraiserIntroPage(user: widget.user, fundraiser: fundraiser, theme: widget.theme, tr: widget.tr );
    // return StationariesIntro(user: widget.user, fundraiser: fundraiser, theme: widget.theme, tr: widget.tr );
     //return PaymentPageIntro(user: widget.user, fundraiser: fundraiser, theme: widget.theme, tr: widget.tr, donation: donation, );
     //return DonationPageIntro(user: widget.user, fundraiser: fundraiser, theme: widget.theme, tr: widget.tr, donation: donation, );
    // SingleChildScrollView(
    //   child:
      // ListView(
      //   shrinkWrap: true,
      //   physics: const BouncingScrollPhysics(),
      //   scrollDirection: Axis.vertical,
      //   children: [
      //     FundraiserIntro(user: widget.user, theme: widget.theme, tr: widget.tr ),
          // FundraiserCard( fundraiser: fundraiser,theme: widget.theme, tr: widget.tr ),
          // const SizedBox(height: 10),
          // MyTab(theme: widget.theme, items: [
          //   TabItem(name: "name", icon: "icons/donation_unselected.png"),
          //   TabItem(name: "age", icon: "icons/donation_selected.png"),
          //   TabItem(name: "ff", icon: "icons/donation_selected.png"),
          // ],
          //   onChange: (x){ setState(() { selectedTab = x;  }); },
          //   selected: selectedTab,),
          // const SizedBox(height: 10),
          // SchoolStationaryDistanceCard(stationary: stationary,
          //     school: school, theme: widget.theme, tr: widget.tr),
          // const SizedBox(height: 10),
          // DonationCard(theme: widget.theme, tr: widget.tr, donation: donation),
          // const SizedBox(height: 10),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 30),
          //   child: ButtonBig(onClick: () => {}, text: "button", theme: widget.theme,),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 30),
          //   child: ButtonOutlineBig(onClick: () => {}, text: "button", theme: widget.theme,),
          // ),
          // const SizedBox(height: 40),
          // ItemForm( fundraiserItem: fundraiser.fundraiserItems![0], theme: widget.theme, tr: widget.tr ),
          // StationaryCard( stationary: stationary, theme: widget.theme, tr: widget.tr ),
          // DonationItems( fundraiserItems: fundraiser.fundraiserItems, theme: widget.theme, tr: widget.tr )

      //   ],
      // ),
    // );

  }
}





















