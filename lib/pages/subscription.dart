import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/activity.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/intro/fundraiser.page.intro.dart';
import 'package:lapis_ui/pages/post.page.dart';
import 'package:lapis_ui/widgets/cards/activity.card.dart';
import 'package:lapis_ui/widgets/lazy.listview.dart';
import 'package:myapp/driver/subscribed.donation.driver.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import '../config/themes/app.theme.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({ Key? key  ,required this.saveUser, required this.user, required this.theme, required this.tr })
      : super(key: key);

  final UserModel user;
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final void Function(UserModel newUser) saveUser;
  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {


  late Future<PaginationModel?> fundraiserPagination;

  @override
  void initState() { super.initState();
  fundraiserPagination = DonorRequest(widget.user).getActivities();
  }


  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              // title: _background(),
              pinned: false,
              snap: false,
              backgroundColor: widget.theme.scaffoldBackgroundColor,
              floating: true,
              collapsedHeight: 60,
              leadingWidth: 30,
              expandedHeight: 60,
              forceElevated: innerBoxIsScrolled,
              // bottom: PreferredSize(preferredSize: Size( MediaQuery.of(context).size.width, 64),
              // child: _greetingWidget()),
              flexibleSpace: FlexibleSpaceBar(
                // title: _headerAction(),
                expandedTitleScale: 1,
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(10,10,10,0),
                  child: _background(),
                ),
              ),
            ),
          ];
        },
        body: (widget.user.getToken().type=='driver')?_contentDriver(): _content()
    );
  }


  Widget _background(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4,),
          Text(tr("notification"),textAlign: TextAlign.start,
            style: TextStyle( fontSize:20.0, fontWeight: FontWeight.w900,
                color: widget.theme.colorScheme.secondary ),),
          Padding(
            padding: const EdgeInsets.only(top:4.0),
            child: SizedBox(
                width: (MediaQuery.of(context).size.width*10/12),
                child:  Text(tr("campaigns_and_posts_from_your_favorite_schools"),
                  textAlign: TextAlign.start,
                  style:  const TextStyle( fontSize:12.0, ),)),
          )
        ],
      ),
    );
  }

  Widget _content(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0 ),
      child: LazyListView( tr: widget.tr, onRetry: (){_onLoadingMore(null, 1);},
          onNoData: widget.tr("subscribe_for_donor_data"),
          pagination: fundraiserPagination, loadMore: (pagination, page) async{
            _onLoadingMore(pagination, page);
          }, item: (data) =>  //const SizedBox(height: 3),
          ActivityCard( onClick: (activity){  _onItemClick(activity);},
            theme: widget.theme, tr: widget.tr, activity: data,
          ), theme: widget.theme ),
    );
  }

  Widget _contentDriver(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0 ),
      child: SubscribedDonationDriver(
        theme: widget.theme, user: widget.user, tr: widget.tr,
      )
    );
  }

  void _onLoadingMore(pagination, page){
    setState(() {
      fundraiserPagination = DonorRequest(widget.user)
          .getActivities(
          pagination: pagination,
          page: page );
    });
  }


  void _onItemClick(ActivityModel activityModel) async{
    if(activityModel.type=="fundraiser"){

      FundraiserModel? fundraiser = await DonorRequest(widget.user).getFundraiser( id: activityModel.getFundraiser().id??0 );
      if(fundraiser==null) return;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) =>
          FundraiserIntroPage(
            tr: widget.tr, theme: widget.theme,
            fundraiser: fundraiser, user: widget.user, onEnd: () {  },
          ) ));

    }else if(activityModel.type=="post"){
      Navigator.push( context, MaterialPageRoute(builder: (context) => PostPage(
        theme: widget.theme, post: activityModel.getPost(),) ));
    }
  }



}