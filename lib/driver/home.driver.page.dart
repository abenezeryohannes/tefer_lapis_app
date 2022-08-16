import 'dart:math';
import 'package:dio/dio.dart';
import 'package:domain/controllers/donor.request.dart';
import 'package:domain/controllers/user.request.dart';
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
import 'package:domain/controllers/driver.request.dart';
import 'package:lapis_ui/widgets/cards/driver.donation.card.dart';
import 'package:lapis_ui/widgets/error.handler.ui.dart';
import 'package:lapis_ui/widgets/floating.search.dart';
import 'package:lapis_ui/widgets/lazy.listview.dart';
import 'package:lapis_ui/widgets/loading.bar.dart';
import 'package:lapis_ui/widgets/search.textfield';
import 'package:myapp/driver/profile.driver.page.dart';
import 'package:myapp/driver/search.donation.driver.page.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:util/Utility.dart';
import '../config/themes/app.theme.dart';

class HomeDriverPage extends StatefulWidget {
  const HomeDriverPage(
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
  State<HomeDriverPage> createState() => _HomeDriverPageState();
}

class _HomeDriverPageState extends State<HomeDriverPage> {

  late Future<PaginationModel?> donationsPagination;
  bool loading = false;

  @override
  void initState() { super.initState();
  donationsPagination = DriverRequest(widget.user).getDonations(page: 1);
  }

  @override
  void dispose() { super.dispose(); }


  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            title: _headerAction(),
            pinned: true,
            backgroundColor: widget.theme.scaffoldBackgroundColor,
            floating: true,
            expandedHeight: 130,
            forceElevated: innerBoxIsScrolled,
            // bottom: PreferredSize(preferredSize: Size( MediaQuery.of(context).size.width, 64),
            // child: _greetingWidget()),
            // bottom: PreferredSize(
            //   preferredSize: const Size.fromHeight(60),
            //   child: _search(),
            // ),
          flexibleSpace: FlexibleSpaceBar(
            // title: _headerAction(),
            expandedTitleScale: 3,
            background: Padding(
              padding: const EdgeInsets.fromLTRB(0,50,0,0),
              child: _greetingWidget(),
            ),
          )
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
      body: _content(),
    );
  }

  String searchText = "";
  String dropdownValue = "";


      Widget _search(){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Stack(

        children: [


          Hero(
            tag: 'search_bar',
            child: Card(
              color: widget.theme.cardColor,
              elevation: 1,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                    // enabled: false,
                    readOnly: true,
                    // style: widget.theme.textTheme.button,
                    // onChanged: (text) { widget.onChange(text); },
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                      SearchDonationDriverPage( tr: widget.tr, theme: widget.theme,
                      user: widget.user,
                      request: ({int page=1, String search="",
                        PaginationModel? pagination}){
                        return DriverRequest(widget.user).getDonations(
                            pagination: pagination, page: page, search: search);
                      },
                      mapItem: (data) {
                        return DriverDonationCard(
                          onClick: (donation){  _onItemClick(donation);},
                          theme: widget.theme, tr: widget.tr, donation: data,
                        );
                      },
                      ) ));
                    },

                    decoration: InputDecoration(
                      hintText: widget.tr("search"),
                      border: InputBorder.none,

                      focusColor: widget.theme.colorScheme.secondary,
                      constraints: const BoxConstraints(maxHeight: 42),
                      filled: false, fillColor: widget.theme.backgroundColor,
                      hintStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 16,
                          color: widget.theme.dividerColor),
                      contentPadding: const EdgeInsets.symmetric( horizontal: 10, vertical: 10),
                    )
                ),
              )
            ),
          ),



          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: Icon(Icons.more_vert, color: widget.theme.colorScheme.onBackground,),
                elevation: 16,
                style: TextStyle(color: widget.theme.colorScheme.onBackground,),
                underline: Container(
                  height: 0,
                  color: widget.theme.colorScheme.onBackground,
                ),
                onChanged: (String? newValue) {
                  setState(() { dropdownValue = newValue!;
                  donationsPagination = DriverRequest(widget.user)
                      .getDonations( page: 1, sort_by: dropdownValue );
                  });
                },

                items: <String>['nearest', 'date', 'cheapest', 'expensive']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(widget.tr(value), style: widget.theme.textTheme.bodyText2,),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

      Widget _content(){
      return
        Column(
          children: [
            LazyListView( tr: widget.tr,onRetry: (){_onLoadingMore(null, 1);},
                pagination: donationsPagination, loadMore: (pagination, page) async{
                  _onLoadingMore(pagination, page);
                }, item: (data) =>  //const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DriverDonationCard(
                    onClick: (donation){  _onItemClick(donation);},
                    theme: widget.theme, tr: widget.tr, donation: data,
                  ),
                ),   theme: widget.theme ),
          ],
        );
    }

      Widget _greetingWidget(){
    return Container(
      alignment: Alignment.topCenter,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 4,
            ),
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
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ]),
    );
  }

      void _onLoadingMore(pagination, page){
        setState(() {
          donationsPagination = DriverRequest(widget.user)
              .getDonations(
              pagination: pagination,
              page: page );
        });
      }

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

      void _onItemClick(DonationModel donation){
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DriverDonationPage(tr: widget.tr, theme: widget.theme,
          donation: donation, user: widget.user, onChange: () {
            _onLoadingMore(null, 1);
        }, fundraiser: donation.getFundraiser(),) ));
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
              onPressed: () {
                onProfileClicked(context);
              },
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
                      donationsPagination = DriverRequest(widget.user)
                          .getDonations( page: 1, sort_by: dropdownValue );
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
    }finally{
      setState(() { loading = false; });
    }
  }

  void onProfileClicked(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileDriverPage(
              saveUser: (newUser) async {
                widget.saveUser(newUser);
              },
              themes: widget.themeDatas,
              locales: context.supportedLocales,
              theme: widget.theme,
              tr: tr,
              user: widget.user, onThemeChange: (index ) { widget.onThemeChange(index); },
            )));
  }



}
