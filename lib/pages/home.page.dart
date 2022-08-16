import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dio/dio.dart';
import 'package:domain/controllers/donor.request.dart';
import 'package:domain/controllers/user.request.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/intro/fundraiser.page.intro.dart';
import 'package:lapis_ui/pages/profile.page.dart';
import 'package:lapis_ui/pages/school.page.dart';
import 'package:lapis_ui/widgets/cards/fundraiser.card.dart';
import 'package:lapis_ui/widgets/error.handler.ui.dart';
import 'package:lapis_ui/widgets/lazy.listview.dart';
import 'package:lapis_ui/widgets/loading.bar.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:util/Utility.dart';
import '../config/themes/app.theme.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {Key? key,
      required this.saveUser,
      required this.user,
      required this.theme,
      required this.themeDatas,
      required this.onThemeChange,
      required this.tr})
      : super(key: key);

  final UserModel user;
  final ThemeData theme;
  final Function(int) onThemeChange;
  final List<ThemeData> themeDatas;
  final String Function(String, {List<String> args}) tr;
  final void Function(UserModel newUser) saveUser;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<PaginationModel?> fundraiserPagination;
  late String dropdownValue;
  bool loading = false;
  @override
  void initState() {
    super.initState(); dropdownValue = "nearest";
    fundraiserPagination = DonorRequest(widget.user).getFundraisers(page: 1, sort: dropdownValue);
  }

  @override
  void dispose() { super.dispose(); }

  String greeting(){
    String greeting = "";
    int hours=DateTime.now().hour;
    if(hours>=0 && hours<=12){
      greeting = "good_morning";
    } else if(hours>=12 && hours<=16){
      greeting = "good_afternoon";
    } else if(hours>=16 && hours<=21){
      greeting = "good_evening";
    } else if(hours>=21 && hours<=24){
      greeting = "good_night";
    }
    return greeting;
  }

  @override
  Widget build(BuildContext context) {
    print("user token: ${widget.user.getToken().token}");
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: _headerAction(),
              pinned: true,
              backgroundColor: widget.theme.scaffoldBackgroundColor,
              floating: true,
              expandedHeight: 120,
              forceElevated: innerBoxIsScrolled,
              // bottom: PreferredSize(preferredSize: Size( MediaQuery.of(context).size.width, 64),
              // child: _greetingWidget()),
              flexibleSpace: FlexibleSpaceBar(
                // title: _headerAction(),
                expandedTitleScale: 3,
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(0,50,0,0),
                  child: _greetingWidget(),
                ),
              ),
            ),
            // SliverPadding(
            //   padding: const EdgeInsets.all(16.0),
            //   sliver: SliverList(
            //     delegate: SliverChildListDelegate([
            //       _greetingWidget()
            //     ]),
            //   ),
            // ),


          ];
        },
        body: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            const SizedBox( height: 20.0, ),

            LazyListView( tr: widget.tr, onRetry: (){_onLoadingMore(null, 1);},
                pagination: fundraiserPagination, loadMore: (pagination, page) async{
              _onLoadingMore(pagination, page);}, item: (data) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: FundraiserCard(
                  onClick: (fundraiser) {
                    _onItemClick(fundraiser);
                    },
                  theme: widget.theme, tr: widget.tr, fundraiser: data, onSchoolClick: (fundraiser ) { _onSchoolClick(fundraiser); },
            ),
              ), theme: widget.theme )

          ],
        ),
      ),
    );
  }


  void _onLoadingMore(pagination, page){
    setState(() {
      fundraiserPagination = DonorRequest(widget.user)
          .getFundraisers(
          pagination: pagination,
          page: page, sort: dropdownValue );
    });
  }


  void _onItemClick(FundraiserModel fundraiser){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FundraiserIntroPage(tr: widget.tr, theme: widget.theme,
      fundraiser: fundraiser, user: widget.user, onEnd: () {  },) ));
  }



  void onProfileClicked(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(
                  onChange: (newUser) async {
                    widget.saveUser(newUser);
                  },
                  themes: widget.themeDatas,
                  locales: context.supportedLocales,
                  theme: widget.theme,
                  tr: tr,
                  user: widget.user, onThemeChange: (index ) { widget.onThemeChange(index); },
                )));
  }


  Widget _greetingWidget(){
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
      ),
      const SizedBox( width: 20, ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox( height: 4, ),

          Text(
            tr(greeting(), args: [
              (widget.user.full_name!=null)?widget.user.full_name!.split(' ')[0]:'']),
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
                color: widget.theme.colorScheme.secondary),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: SizedBox(
                width: (MediaQuery.of(context).size.width * 2 / 3),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        tr("qoute"+(1 + (Random()).nextInt(9)).toString()),
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 12, color: widget.theme.colorScheme.onBackground, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                )),
          )

        ],
      ),
    ]);
  }

  Widget _headerAction() {
    return Column(
      children: [
        if(loading) const LoadingBar( ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.person, color: widget.theme.colorScheme.onBackground,),
              tooltip: tr('profile'),
              onPressed: () { onProfileClicked(context); },
            ),


            Stack(
              alignment: Alignment.centerRight,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    Text(widget.tr('cash', args: [widget.user.getDonor().donated??'0']),
                      style: widget.theme.textTheme.bodyText2,),

                    const SizedBox(width: 3,),

                    Text(widget.tr('donated'),
                      style:  TextStyle(
                          color: widget.theme.colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),),
                    const SizedBox(width: 30,),
                  ],
                ),

                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    // value: dropdownValue,
                    icon: Icon(Icons.more_vert, color: widget.theme.colorScheme.onBackground,),
                    elevation: 16,
                    style: TextStyle(color: widget.theme.colorScheme.onBackground,),
                    underline: Container(
                      height: 0,
                      color: widget.theme.colorScheme.onBackground,
                    ),
                    onChanged: (String? newValue) {
                      if(newValue == 'switch_to_delivery_mode'){
                        onSwitch('driver'); return;
                      }else if(newValue == 'switch_to_donor_mode'){
                        onSwitch('donor'); return;
                      }else if(newValue == 'sort_by')return;
                        setState(() { dropdownValue = newValue!;
                        fundraiserPagination = DonorRequest(widget.user).getFundraisers(page: 1, sort: dropdownValue);
                      });
                    },

                    items: <String>[
                          (widget.user.getToken().type=='donor')?'switch_to_delivery_mode':'switch_to_donor_mode',
                            'nearest', 'date', 'cheapest', 'expensive',
                         ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        enabled: value!='sort_by',
                        child: (value == 'switch_to_delivery_mode'||value == 'switch_to_donor_mode')?
                             Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Row(
                                   children: [
                                     Icon(Icons.switch_left_rounded, color: widget.theme.colorScheme.onBackground,),
                                     const SizedBox(width: 10),
                                     Text(widget.tr(value), style: widget.theme.textTheme.bodyText2,),
                                   ],
                                 ),
                                 const SizedBox(height: 10),
                                 Divider( height: 1, color: widget.theme.dividerColor, ),
                               ],
                             ): (value == 'sort_by')?
                            Text(widget.tr(value), style: widget.theme.textTheme.subtitle2,)
                            : Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(widget.tr(value), style: widget.theme.textTheme.bodyText2,),
                            ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

            // IconButton(
            //   icon: const Icon(Icons.more_vert),
            //   tooltip: tr('filter'),
            //   onPressed: () {
            //
            //     //TODO ON Home Page Filter PRESSED
            //   },
            // ),
          ],
        ),
      ],
    );
  }


  void _onSchoolClick(FundraiserModel fundraiser){
    if(fundraiser.getUser().id!=null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SchoolPage(
          theme: widget.theme, user: widget.user, tr: widget.tr, school: fundraiser.getUser()
      ) ));
    }
  }


  void onSwitch(String type) async{
    UserModel temp = widget.user;
    if(temp.Token!=null) { temp.Token!.type = type;}
    try {
      setState(() { loading = true; });
      //temp.Token = TokenModel.
      //fresh(token:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjo1MSwiaWF0IjoxNjU3MDM0MTAyfQ.tefztGAmdLfe-e-54rd1qRSTIC_T2QD4D05YQFNnCcU",type:val);
      Wrapper wrap = await UserRequest(widget.user)
          .editUser(user: temp);
      if (wrap.success ?? false ||
          (wrap.message == null &&
              wrap.data != null)) {
        widget.saveUser(wrap.data);
      }
    }on DioError catch(e){
      ErrorHandlerUi().showErrorDialog(context: context,
          title: "error",
          description:  Utility.formatError(e, tr: widget.tr),
          theme: widget.theme,tr: widget.tr);
    }finally{ setState(() { loading = false; }); }
  }


}
