import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/intro/donation.page.intro.dart';
import 'package:lapis_ui/widgets/cards/stationary.card.dart';
import 'package:lapis_ui/widgets/list.view.error.dart';
import 'package:map/map.screen.dart';

import '../widgets/lazy.listview.dart';
import '../widgets/tab.dart';

class StationariesIntro extends StatefulWidget {
  const StationariesIntro(
      {Key? key, required this.onEnd, required this.theme, required this.donation,
        required this.fundraiser, required this.tr, required this.user})
      : super(key: key);
  final ThemeData theme;
  final Function() onEnd;
  final String Function(String, {List<String> args}) tr;
  final UserModel user;
  final FundraiserModel fundraiser;
  final DonationModel donation;

  @override
  State<StationariesIntro> createState() => _StationariesIntroState();


}

class _StationariesIntroState extends State<StationariesIntro> {
  int selectedTab = 0;
  PageController pageController = PageController(initialPage: 0);
  late Future<PaginationModel?> stationariesPagination;
  late Future<PaginationModel?> stationariesLocationPagination;

  @override
  void initState() {
    super.initState();
    stationariesLocationPagination = DonorRequest(widget.user).nearBy(
        latitude: widget.user.getLocation().latitude??0,
        longitude: widget.user.getLocation().longitude??0,
        type: 'stationary'
    );
    stationariesPagination = DonorRequest(widget.user).getDonationStationaries(id: widget.donation.id??0, limit: 5);

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: _appBar(),
              pinned: true,
              backgroundColor: widget.theme.scaffoldBackgroundColor,
              floating: true,
              leadingWidth: 30,
              expandedHeight: 190,
              forceElevated: innerBoxIsScrolled,
              // bottom: PreferredSize(preferredSize: Size( MediaQuery.of(context).size.width, 64),
              // child: _greetingWidget()),
              flexibleSpace: FlexibleSpaceBar(
                // title: _headerAction(),
                expandedTitleScale: 1,
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(0,40,0,0),
                  child: _background(),
                ),
              ),
            ),
          ];
        },
        body: _content()
      ),
    );
  }

  Widget _appBar(){
    return Row(
      children: [
        Row(
          children: [
            // IconButton(
            //     icon: const Icon(Icons.arrow_back),
            //     color: widget.theme.colorScheme.onBackground,
            //     onPressed: () {
            //       Navigator.maybePop(context);
            //     }),
            // const SizedBox(width: 5),
            Text(widget.tr("choose_stationaries"),
                style: widget.theme.textTheme.bodyText1)
          ],
        )
      ],
    );
  }

  Widget _background(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15),
            child: Text(widget.tr("choose_stationary_description"), style: widget.theme.textTheme.subtitle2),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 10, 0),
            child: Row(
              children: [
                MyTab(
                    theme: widget.theme,
                    items: [
                      TabItem(name: widget.tr('list'), icon: Icons.list),
                      TabItem(name: widget.tr('map'), icon: Icons.map),
                    ],
                    selected: selectedTab,
                    onChange: (index) => setState(() { selectedTab = index; pageController.jumpToPage(selectedTab); })),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(){
    return  PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (index) { setState(() {selectedTab = index; }); },
      scrollDirection: Axis.horizontal,
      children: [
        _listview(),
        _mapView(),
      ],
    );
  }

  Widget _listview(){
    return
      Column(
        children: [
          const SizedBox(height: 10),
          LazyListView( tr: widget.tr, onRetry: (){
                setState(() {
                  stationariesPagination = DonorRequest(widget.user).getDonationStationaries(id: widget.donation.id??0,
                      pagination: null, page: 1, limit: 5 );
                });
              },
            pagination: stationariesPagination, loadMore: _onLoadingMore, item: (data) =>  (data.total_donation_price!=null)?StationaryCard(
            stationary: data, theme: widget.theme, user: widget.user,
            tr: widget.tr, onClick: ( stationary ) {
              _onMarkerClicked(stationary);
          }, ):const SizedBox(),
              theme: widget.theme ),
        ],
      );
  }


  _onLoadingMore(pagination, page) async{
    setState(() {
      stationariesPagination = DonorRequest(widget.user).getDonationStationaries(id: widget.donation.id??0,
          pagination: pagination, page: page, limit: 5 );
    });
  }

  Widget _mapView(){
    return FutureBuilder<dynamic>(
        future: stationariesLocationPagination,
        builder: (context, snapshot) {
          //print("snap: ${snapshot.data}");
          if (snapshot.hasData) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MapScreen(
                  origin: const [],
                  destination: const [],
                  users:  snapshot.data.data,
                  onMarkerClicked: _onMarkerClicked,
                  // markers: snapshot.data.data.map((e) =>
                  // [e.getLocations().latitude, e.getLocation().longitude]),
                  setPath: (org, dest){ },
                  startPosition: [
                    widget.user.getLocation().latitude??0,
                    widget.user.getLocation().longitude??0
                  ],),
              ),
            );
          } else if (snapshot.hasError) {
            return ListViewError(tr: widget.tr, error: snapshot.error??{"message": "unknown Error"},
                theme: widget.theme, onRetry: (){
                  _onLoadingMore(null, 1);
                });
          }
          // By default, show a loading spinner.
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }
    );
  }

  _onMarkerClicked(UserModel user) async{
    DonationModel donation = widget.donation;
    donation.stationary_user_id = user.id;
    Wrapper wrapper = await DonorRequest(widget.user).assignStationary(donation_id: widget.donation.id??0,
        stationary_id: user.id??0);
    print(wrapper);
    if(wrapper.message==null&&wrapper.data!=null){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>
          DonationPageIntro(
            onEnd: widget.onEnd,
            tr: widget.tr,
            theme: widget.theme,
            fundraiser: widget.fundraiser,
            user: widget.user,
            donation: DonationModel.fromJson(wrapper.data),
          )
      ));
    }else{
      print(wrapper.message);
    }
  }
}
