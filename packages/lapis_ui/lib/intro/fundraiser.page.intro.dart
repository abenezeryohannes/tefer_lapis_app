

import 'dart:math';

import 'package:http/http.dart' show get;
import 'dart:io';
import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/donation.item.model.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_persistent_keyboard_height/flutter_persistent_keyboard_height.dart';
import 'package:lapis_ui/intro/Stationaries.intro.dart';
import 'package:lapis_ui/widgets/button.big.dart';
import 'package:lapis_ui/widgets/button.on.keyboard.dart';
import 'package:lapis_ui/widgets/items.form.dart';
import 'package:lapis_ui/widgets/list.view.error.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_share/social_share.dart';
import 'package:util/RequestHandler.dart';

import '../widgets/cards/fundraiser.progress.dart';
import '../widgets/lazy.listview.dart';


class FundraiserIntroPage extends StatefulWidget {

  const FundraiserIntroPage(
        {
          Key? key, required this.fundraiser,
          required this.theme,
          required this.tr,
          required this.user,
          required this.onEnd
        })
    : super(key: key);

    final ThemeData theme;
    final String Function(String, {List<String> args}) tr;
    final UserModel user;
    final void Function() onEnd;
    final FundraiserModel fundraiser;


@override
  State<FundraiserIntroPage> createState() => _FundraiserIntroPageState();
}

class _FundraiserIntroPageState extends State<FundraiserIntroPage> {

  late Future<Wrapper> donatableItems;
  late DonationModel _donation;
  double _total = 0;

  @override
  void dispose() {  super.dispose(); }

  @override
  void initState() {

    donatableItems = DonorRequest(widget.user).getDonatableAmount(fundraiserId: widget.fundraiser.id??0);

      _donation = DonationModel(
        fundraiser_id: widget.fundraiser.id,
        donor_user_id: widget.user.id,
        amount: "0.0"
      );

      //print("fundraiser items: ${widget.fundraiser.getFundraiserItems().toString()}");

      widget.fundraiser.getFundraiserItems().forEach((e){
        _donation.getDonationItems().add(
          DonationItemModel( item_id:e.item_id,
              unit_price:((e.getItem().avg_price??'0')),
              quantity: 0)
        );
      });

      //print("_donation : " "${_donation.toString()}");

      _computeTotal();

      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final keyboardHeight = PersistentKeyboardHeight.of(context).keyboardHeight;
    //print("keyboard: $keyboardHeight");
    return Scaffold(
        backgroundColor: widget.theme.scaffoldBackgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () { _onClick(); },
          backgroundColor: _total>0 ? widget.theme.colorScheme.secondary:widget.theme.backgroundColor,
          child: Icon(Icons.navigate_next, color: _total>0 ? widget.theme.colorScheme.onSecondary:widget.theme.dividerColor,),
        ),
        body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
      return <Widget>[
        SliverAppBar(
          title: _headerAction(),
          leadingWidth: 0,
          leading: null,
          pinned: true,
          iconTheme: const IconThemeData(size: 0),
          backgroundColor: widget.theme.scaffoldBackgroundColor,
          floating: true,
          expandedHeight: 200,
          forceElevated: innerBoxIsScrolled,
          // bottom: PreferredSize(preferredSize: Size( MediaQuery.of(context).size.width, 64),
          // child: _greetingWidget()),
          flexibleSpace: FlexibleSpaceBar(
             //title: _headerAction(),
            expandedTitleScale: 3,
            background:  Stack(
              children: [
                Hero(
                  tag: "fundraiser_"+widget.fundraiser.id.toString(),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('${RequestHandler.baseImageUrl}${widget.fundraiser.image}'),
                      ),
                    ),
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     gradient:  LinearGradient(
                //       begin: Alignment.topCenter,
                //       end: Alignment.bottomCenter,
                //       colors: <Color>[
                //         Colors.transparent,
                //         widget.theme.scaffoldBackgroundColor
                //       ],
                //     ),
                //   ),
                // ),
              ],
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
    body: content(),
    ));
  }

  Widget _headerAction(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Card(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 5,
            child: InkWell(
              onTap: () { Navigator.maybePop(context); },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon( Icons.arrow_back, size: 24,
                    color: widget.theme.colorScheme.onBackground
                ),
              ),
            )
        ),

        Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 5,
            child: InkWell(onTap: () async{
              Uri url = Uri.parse(RequestHandler.baseImageUrl + (widget.fundraiser.image??''));
              var response = await get(url);
              var documentDirectory = await getApplicationDocumentsDirectory();
              var firstPath = documentDirectory.path + "/images";
              int start = (widget.fundraiser.image==null)?0:widget.fundraiser.image!.lastIndexOf('/')+1;
              var filePathAndName = '${Random(10000000)}.png';
              if(widget.fundraiser.image!=null) {
                filePathAndName = documentDirectory.path + '/images/${widget.fundraiser.image!.substring(start)}';
              }
              print('file Path: $filePathAndName');
              //comment out the next three lines to prevent the image from being saved
              //to the device to show that it's coming from the internet
              await Directory(firstPath).create(recursive: true);
              File file2 = File(filePathAndName);
              file2.writeAsBytesSync(response.bodyBytes);

              // print("test");
              if(file2.existsSync()) {
                  SocialShare.shareOptions(
                    ((widget.fundraiser.title??'') + '\n' + (widget.fundraiser.description??'')),
                  imagePath: filePathAndName
                );
              }else{
                SocialShare.shareOptions(
                    ((widget.fundraiser.title??'') + '\n' + (widget.fundraiser.description??'')),
                );
              }
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.share,size: 24, color: widget.theme.colorScheme.onBackground),
              ),
            )),


      ],
    );
  }



  Widget content(){
    return Material(
      elevation: 10,
      child: SingleChildScrollView (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
              child: Text(widget.fundraiser.title??'',textAlign: TextAlign.start,
                  style: widget.theme.textTheme.bodyText1),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
                  child: Hero(
                      tag: "xfundraiser_description"+widget.fundraiser.id.toString(),
                      child: Text(widget.tr(widget.fundraiser.description??""), style: widget.theme.textTheme.subtitle2)),
                ),

                const SizedBox(height: 10,),

                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FundraiserProgress(fundraiser: widget.fundraiser, theme: widget.theme, showText: false, tr: widget.tr),
                ),

                const SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(widget.tr('raised'),
                            style: TextStyle(
                              color: (widget.fundraiser.donated_items_count??0)>0?Colors.green:Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 14
                            ),),
                          const SizedBox(height: 3),
                          Text(widget.tr('cash', args: [widget.fundraiser.donated_amount??'0']),
                            style: widget.theme.textTheme.bodyText1,),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.tr('donated'),
                            style: TextStyle(
                                color: (widget.fundraiser.donated_items_count??0)>0?Colors.green:Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                            ),),
                          const SizedBox(height: 3),
                          Text(widget.tr('items', args: [(widget.fundraiser.donated_items_count??0).toString()]),
                            style: widget.theme.textTheme.bodyText1,),
                        ],
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: _buildFundraiserItemInput(),
                ),

                const SizedBox(height: 30),

                if(_total>0)
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/icons/price_tag.png", width: 24, height: 24, fit: BoxFit.cover,),
                    const SizedBox(width: 10),
                    Text("~ $_total ETB", style: widget.theme.textTheme.headline3),
                  ],
                ),

                const SizedBox(height: 30),

              ],
            ),
            // if(_total>0  )
            //   Padding(
            //     padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
            //     child: Center(
            //       child: ButtonBig(theme: widget.theme, child: Text( widget.tr("continue"),
            //           style: TextStyle(
            //             color: widget.theme.colorScheme.onSecondary,
            //             fontWeight: FontWeight.bold
            //           )), onClick: _onClick),
            //     ),
            //   )
          ],
        ),
      ),
    );
  }

  void _onClick() async{
    _donation.DonationItems = _donation.getDonationItems().where((e) => ((e.quantity??0) > 0)).toList();
    // print(_donation.toString());
    if(_total>0){
      Wrapper? wrapper = await DonorRequest(widget.user).donate(donation: _donation);
      if(wrapper.message==null) {
        DonationModel donation = DonationModel.fromJson(wrapper.data);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) =>
            StationariesIntro(tr: widget.tr,
                theme: widget.theme,
                onEnd: widget.onEnd,
                donation: donation,
                fundraiser: widget.fundraiser,
                user: widget.user)));
        // }else{
        //
        // }
      }else {
        //at least show 2
        print(wrapper);
      }
    }
  }
  void _computeTotal(){
    _total = 0;
    _donation.getDonationItems().forEach((element) {_total+= (element.quantity??0)*
        (double.parse(element.unit_price??'0'));});
    _donation.amount = _total.toString();
  }

  Widget _buildFundraiserItemInput(){
    return FutureBuilder<dynamic>(
        future: donatableItems,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.success) {
            return ListView.builder(
              itemCount: snapshot.data.data.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, position) {
                return ItemForm(StationaryItem: snapshot.data.data[position],
                  theme: widget.theme, tr: widget.tr, onChanged: (val, si) {
                  // print("check: $val ${si.toString()}");
                  // print("checkk: ${_donation.getDonationItems().singleWhere((e) => e.item_id == si.item_id).toString()}");
                    _donation.getDonationItems().singleWhere((e) => e.item_id == si.item_id).quantity = val;
                    setState(() { si.donate = val; _computeTotal(); });
                  });
              },
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: ListViewError(tr: widget.tr,
                error: snapshot.error!, theme: widget.theme,
              onRetry: (){setState(() {
                donatableItems = DonorRequest(widget.user).getDonatableAmount(
                    fundraiserId: widget.fundraiser.id??0
                );
              });},),
            );
          }
          return const Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0),
              child: Center(child: CircularProgressIndicator()));
        });

      // LazyListView(
      //     pagination: donatableItems, loadMore: (pagination, page) async{},
      //     item: (data) =>  ItemForm(StationaryItem: data,
      //       theme: widget.theme, tr: widget.tr, onChanged: (val, si) { setState(() {
      //         si.donate = (val);
      //         _computeTotal();
      //       }); },),
      //     theme: widget.theme );

      // return Scrollbar(
      //   child: ListView.builder(
      //       itemCount: widget.fundraiser.getFundraiserItems().length,
      //       shrinkWrap: true, itemBuilder: (context, position) {
      //     return ItemForm(fundraiserItem: widget.fundraiser.getFundraiserItems()[position],
      //         donationItem: _donation.getDonationItems()[position],
      //         theme: widget.theme, tr: widget.tr, onChanged: (val) { setState(() {
      //           _donation.getDonationItems()[position].quantity = int.tryParse(val);
      //           _computeTotal();
      //         }); },);
      //   }),
      // );

  }


}
