import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:domain/shared_preference/user.sp.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/intro/donation.walkthrough,page.dart';
import 'package:lapis_ui/intro/fundraiser.page.intro.dart';
import 'package:lapis_ui/widgets/cards/fundraiser.card.dart';
import 'package:lapis_ui/widgets/lazy.listview.dart';
import 'package:lapis_ui/widgets/tab.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:map/map.screen.dart';

import '../pages/school.page.dart';

class FundraiserListIntro extends StatefulWidget {
  const FundraiserListIntro({
        Key? key, required this.onEnd,
        required this.theme,
        required this.tr,
        required this.user
      }) : super( key: key );

  final ThemeData theme;
  final void Function() onEnd;
  final String Function(String, {List<String> args}) tr;
  final UserModel user;

  @override
  State<FundraiserListIntro> createState() => _FundraiserListIntroState();

}

class _FundraiserListIntroState extends State<FundraiserListIntro> {
  int selectedTab = 0;
  PageController pageController = PageController(initialPage: 0);
  late Future<PaginationModel?> fundraiserPage;
  late Future<PaginationModel?> fundraiserLocationPagination;

  @override
  void initState() {
    loadMap();
    super.initState();
    fundraiserLocationPagination = DonorRequest(widget.user).
    getNearbyFundraisers(latitude: widget.user.getLocation().latitude??37.773972,
        longitude: widget.user.getLocation().longitude??-122.431297);
    fundraiserPage = DonorRequest(widget.user).getFundraisers();
  }

  void loadMap()async {
    UserSP userSp = UserSP();
    await userSp.loadPreference();
    UserModel user = await userSp.getUser();
    fundraiserLocationPagination = DonorRequest(widget.user).
    getNearbyFundraisers(latitude: user.getLocation().latitude??37.773972,
        longitude: user.getLocation().longitude??-122.431297);

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
                title: _title(),
                pinned: true,
                backgroundColor: widget.theme.scaffoldBackgroundColor,
                floating: true,
                leadingWidth: 30,
                expandedHeight: 180,
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

  Widget _title(){
    return Row(
      children: [
        IconButton(
            icon: const Icon(Icons.cancel),
            color: widget.theme.colorScheme.onBackground,
            onPressed: () { widget.onEnd();}),
        const SizedBox(width: 5),
        Text(
            widget.tr("fundraisers"),
            style: widget.theme.textTheme.bodyText1
        )
      ],
    );
  }

  Widget _background(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Text(
                widget.tr('fundraisers_intro'),
                style: widget.theme.textTheme.subtitle2
            ),
          ),
          const SizedBox(height: 16,),
          Row(
            children: [
              MyTab(
                  theme: widget.theme,
                  items: [
                    TabItem(name: widget.tr('list'), icon: Icons.list,),
                    TabItem(name: widget.tr('map'), icon: Icons.map),
                  ],
                  selected: selectedTab,
                  onChange: (index) => setState(() { selectedTab = index; pageController.jumpToPage(selectedTab); })),
            ],
          ),
        ],
      ),
    );
  }

  Widget _content(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          child: PageView(
            controller: pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) { setState(() {selectedTab = index; }); },
            scrollDirection: Axis.horizontal,
            children: [
              Column(
                children: [
                  _listView(),
                ],
              ),
              Column(
                children: [
                  _mapView(),
                ],
              ),
            ],
          ),
        )


      ],
    );
  }



  Widget _mapView(){
    return FutureBuilder<dynamic>(
        future: fundraiserLocationPagination,
        builder: (context, snapshot) {
//          print("snap: ${snapshot.data.data.map( (e) =>  e.getUser() )}");

          if (snapshot.hasData) {
            List<UserModel> test = [for ( FundraiserModel fundraiser in snapshot.data.data ) fundraiser.getUser()];
            print("mapView location:  ${test}");
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MapScreen(
                  origin: const [ ],
                  destination: const [ ],
                  users: [
                    for ( FundraiserModel fundraiser in snapshot.data.data ) fundraiser.getUser()
                  ],
                  onMarkerClicked: (user){
                    //print("user: $user");
                    for(int i = 0; i < snapshot.data.data.length; i++){
                        if(snapshot.data.data[i].getUser().id == user.id) {
                          _onMarkerClicked(snapshot.data.data[i]);
                          break;
                       }
                     }
                  },
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
            return Expanded(
              child: Text(
                '${snapshot.error}',
                style: widget.theme.textTheme.bodyText1,
              ),
            );
          }
          // By default, show a loading spinner.
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }
    );
  }

  Widget _listView(){
    return LazyListView( tr: widget.tr,onRetry: (){_onLoadingMore(null, 1);},
              pagination: fundraiserPage, loadMore: _onLoadingMore, item: (data) =>  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: FundraiserCard(
                    fundraiser: data ,
                    onSchoolClick: (fundraiser ) { _onSchoolClick(fundraiser); },
                    onClick: _onMarkerClicked,
                    theme: widget.theme, tr: widget.tr
                ),
              ),
          ),
          theme: widget.theme );
  }

  _onMarkerClicked(FundraiserModel fundraiser) async{
    print("yes $fundraiser");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) =>
        FundraiserIntroPage(
          tr: widget.tr,
          onEnd: widget.onEnd,
          theme: widget.theme,
          fundraiser: fundraiser,
          user: widget.user,
        )
    ));
  }

  _onLoadingMore(pagination, page) async{
    setState(() {
      fundraiserPage = DonorRequest(widget.user)
          .getFundraisers(
          pagination: pagination,
          page: page );
    });
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
