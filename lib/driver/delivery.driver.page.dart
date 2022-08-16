import 'dart:math';

import 'package:dio/dio.dart';
import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/delivery.model.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/intro/fundraiser.page.intro.dart';
import 'package:lapis_ui/pages/donation.page.dart';
import 'package:lapis_ui/pages/driver.donation.page.dart';
import 'package:lapis_ui/pages/profile.page.dart';
import 'package:lapis_ui/widgets/cards/driver.donation.card.dart';
import 'package:lapis_ui/widgets/cards/fundraiser.card.dart';
import 'package:lapis_ui/widgets/error.handler.ui.dart';
import 'package:lapis_ui/widgets/lazy.listview.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import '../config/themes/app.theme.dart';

import 'package:domain/controllers/driver.request.dart';
import 'package:lapis_ui/widgets/cards/driver.delivery.card.dart';

class DeliveryDriverPage extends StatefulWidget {
  const DeliveryDriverPage(
      {Key? key,
        required this.saveUser,
        required this.user,
        required this.theme,
        required this.tr})
      : super(key: key);

  final UserModel user;
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final void Function(UserModel newUser) saveUser;

  @override
  State<DeliveryDriverPage> createState() => _DeliveryDriverPageState();
}

class _DeliveryDriverPageState extends State<DeliveryDriverPage> {

  late Future<PaginationModel?> deliveryPagination;

  @override
  void initState() { super.initState();
  deliveryPagination = DriverRequest(widget.user).getDeliveries(page: 1);
  }

  @override
  void dispose() { super.dispose(); }


  @override
  Widget build(BuildContext context) {
    return  NestedScrollView(
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
                      Text(tr("deliveries"),textAlign: TextAlign.start,
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

        LazyListView( tr: widget.tr, onRetry: (){_onLoadingMore(null, 1);},
            pagination: deliveryPagination, loadMore: (pagination, page) async{
              _onLoadingMore(pagination, page);
            }, item: (data) =>  //const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: DriverDeliveryCard(
                onChange: (){_onLoadingMore(null, 1);},
                onClick: (delivery){  _onItemClick(delivery);},user: widget.user,
                theme: widget.theme, tr: widget.tr, delivery: data,
              ),
            ),
            theme: widget.theme )

      ],
    );
  }

  void _onLoadingMore(pagination, page){
    setState(() {
      deliveryPagination = DriverRequest(widget.user)
          .getDeliveries(
          pagination: pagination,
          page: page );
    });
  }


  void _onItemClick(DeliveryModel delivery){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DriverDonationPage(tr: widget.tr, theme: widget.theme,
      fundraiser: delivery.getFundraiser(), donation: delivery.getDonation(), user: widget.user, onChange: () {
        _onLoadingMore(null, 1);
      },) ));
  }











}
