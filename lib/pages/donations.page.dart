import 'dart:math';

import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/intro/Stationaries.intro.dart';
import 'package:lapis_ui/pages/donation.page.dart';
import 'package:lapis_ui/widgets/cards/donation.card.dart';
import 'package:lapis_ui/widgets/lazy.listview.dart';
import 'package:lapis_ui/widgets/loading.bar.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import '../config/themes/app.theme.dart';


class DonationsPage extends StatefulWidget {
  const DonationsPage({ Key? key,
    required this.saveUser, required this.user,
    required this.theme, required this.tr })
      : super(key: key);

  final UserModel user;
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final void Function(UserModel newUser) saveUser;

  @override
  State<DonationsPage> createState() => _DonationsPageState();
}

class _DonationsPageState extends State<DonationsPage> {

  late Future<PaginationModel?> donorPage;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    donorPage = DonorRequest(widget.user).getDonations(page: 1);
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              // title: _title(),
              pinned: false,
              backgroundColor: widget.theme.scaffoldBackgroundColor,
              floating: true,
              leadingWidth: 30,
              expandedHeight: 80,
              forceElevated: innerBoxIsScrolled,
              // bottom: PreferredSize(preferredSize: Size( MediaQuery.of(context).size.width, 64),
              // child: _greetingWidget()),
              flexibleSpace: FlexibleSpaceBar(
                // title: _headerAction(),
                expandedTitleScale: 1,
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(0,10,0,0),
                  child: _background(),
                ),
              ),
            ),
          ];
        },
        body: _content()
    );
  }


  Widget _background(){
    return Container(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 4,),
                      Text(tr("your_donations"),textAlign: TextAlign.start,
                        style: TextStyle( fontSize:20.0, fontWeight: FontWeight.w900,
                            color: widget.theme.colorScheme.secondary ),),
                      Padding(
                        padding: const EdgeInsets.only(top:4.0),
                        child: SizedBox( width: (MediaQuery.of(context).size.width*7/12),
                            child:  Text(tr( tr("donated_qoute"+(1 + (Random()).nextInt(1)).toString()),),
                              textAlign: TextAlign.start, style: const TextStyle( fontSize:12.0, ),)),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: RiveAnimation.asset('assets/anim/lapis.riv',
                      alignment:Alignment.center,
                      fit:BoxFit.contain,
                      stateMachines: ['State Machine Idle'],
                      artboard: 'New Artboard',
                      animations: ['idle'],
                    ),
                    radius: 34,
                  )
                ]
            ),
          ),

        ],
      ),
    );
  }

  Widget _content(){
    return Column(
      children: [
        const SizedBox(height: 10),
        LazyListView( tr: widget.tr, onRetry: (){print("tr"); _onLoadingMore(null, 1);},
            pagination: donorPage, loadMore: (pagination, page) async{
              _onLoadingMore(pagination, page);
            }, item: (data) =>  //const SizedBox(height: 3),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: DonationCard(
                user: widget.user, onChange: ()async{ _onLoadingMore(null, 1); },
                onClick: (donation){  _onItemClick(donation);},
                theme: widget.theme, tr: widget.tr, donation: data, onLoadingChange: (change ) { setState(() { loading = change; }); },
              ),
            ),
            theme: widget.theme ),
      ],
    );
  }

  void _onLoadingMore(pagination, page){
    setState(() {
      donorPage = DonorRequest(widget.user)
          .getDonations(
          pagination: pagination,
          page: page);
    });
  }


  void _onItemClick(DonationModel donation){
    if(donation.stationary_user_id==null){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) =>
          StationariesIntro(tr: widget.tr,
              theme: widget.theme,
              donation: donation,
              fundraiser: donation.getFundraiser(),
              user: widget.user, onEnd: () async{
                  _onLoadingMore(donorPage, 1);
            },)));
    }else {
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => DonationPage(tr: widget.tr, theme: widget.theme,
        fundraiser: donation.getFundraiser(), user: widget.user, donation: donation,
        onEnd: () {
          setState(() {
            donorPage = DonorRequest(widget.user).getDonations(page: 1);
          });
        },) ))
      .then((value) => {
          donorPage = DonorRequest(widget.user).getDonations(page: 1)
      });
    }
  }

}