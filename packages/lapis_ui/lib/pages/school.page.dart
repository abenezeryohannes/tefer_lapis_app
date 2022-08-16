import 'package:dio/dio.dart';
import 'package:domain/controllers/donor.request.dart';
import 'package:domain/controllers/driver.request.dart';
import 'package:domain/models/subscription.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/fragments/school/school.fundraiser.list.fragment.dart';
import 'package:lapis_ui/fragments/school/school.info.fragment.dart';
import 'package:lapis_ui/fragments/school/school.post.list.fragment.dart';
import 'package:util/RequestHandler.dart';
import 'package:util/Utility.dart';
import '../fragments/school/school.donation.list.fragment.dart';
import '../widgets/error.handler.ui.dart';
import '../widgets/tab.dart';

class SchoolPage extends StatefulWidget {
  const SchoolPage({Key? key,
    required this.user,
    required this.theme,
    required this.school,
    required this.tr})
      : super(key: key);

  final UserModel user;
  final UserModel school;
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;

  @override
  State<SchoolPage> createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {

  int selectedTab = 0;
  PageController controller = PageController(initialPage: 0);
  // late bool subscribed;
  late Future<bool?> subscribed;
   bool isSubscribed = false;
  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async{ isSubscribed = (await isSubscribedTo()); }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: widget.theme.scaffoldBackgroundColor,
              expandedHeight: 200,
              titleSpacing: 0,
              centerTitle: false,
              floating: true,
              pinned: true,
              leading: InkWell(onTap: () {Navigator.maybePop(context);}, child: const Icon(Icons.arrow_back)),
              actions: [




                if(isSubscribed)
                DropdownButton<String>(
                  // value: dropdownValue,
                  icon: Icon(Icons.more_vert, color: widget.theme.colorScheme.onBackground,),
                  elevation: 16,
                  style: TextStyle(color: widget.theme.colorScheme.onBackground,),
                  underline: Container(
                    height: 0,
                    color: widget.theme.colorScheme.onBackground,
                  ),
                  items: <String>[ widget.tr("unsubscribe") ].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value, style: widget.theme.textTheme.bodyText2,));
                  }).toList(),
                  onChanged: (val) async{

                        showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      // title: Text(widget.tr("are_you_sure", args: [(widget.school.full_name??'')])),
                                      title: Text(widget.tr("are_you_sure")),
                                      content:  Text(widget.tr("un_subscription_description")) ,
                                      actionsOverflowButtonSpacing: 20,
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(widget.tr("no"))),
                                        TextButton(
                                            onPressed: () async{
                                              // if(widget.school.getSchool().topic!=null) {
                                              //   FirebaseMessaging.instance.unsubscribeFromTopic(widget.school.getSchool().topic!).then((value){
                                              //     print("SUCCESS: subscribing to topic ${widget.school.getSchool().topic}: ");
                                              //   }).onError((error, stackTrace){
                                              //     print("ERROR: subscribing to topic ${widget.school.getSchool().topic}: "+ error.toString());
                                              //   });
                                              // }

                                              isSubscribed = await unSubscribe();
                                              if(isSubscribed){
                                                Navigator.of(context).pop();
                                                return;
                                              }
                                              setState(() {
                                                subscribed = DonorRequest(widget.user).isSubscribed(
                                                  user_id: widget.user.id ?? 0,
                                                  school_id: widget.school.id ?? 0);
                                              });

                                              Navigator.of(context).pop();
                                            },
                                            child: Text(widget.tr("yes"))),
                                      ],
                                      backgroundColor: widget.theme.cardColor,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(20))),
                                    );
                                  });
                  },
                ),



              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Hero(
                      tag: "school_image_"+(widget.school.id.toString()),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage('${RequestHandler.baseImageUrl}${widget.school.avatar}'),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient:  LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.transparent,
                            widget.theme.scaffoldBackgroundColor
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Image.network(
                //   '${RequestHandler.baseImageUrl}${widget.school.avatar}',
                //   fit: BoxFit.cover,),
                title: Text(widget.school.full_name ?? "",
                  style: TextStyle(
                      color: widget.theme.colorScheme.onBackground,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),),
              ),
            ),
          ];
        },
        body: Column(
          children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyTab(
                      theme: widget.theme,
                      items: [
                        (widget.user.getToken().type=="driver")?
                            TabItem(name: widget.tr('donations')):
                            TabItem(name: widget.tr('fundraisers')),
                        TabItem(name: widget.tr('posts')),
                        TabItem(name: widget.tr('about')),
                      ],
                      selected: selectedTab,
                      onChange: (index) => setState(() {
                            controller.jumpToPage(index);
                            selectedTab = index;
                          })),
                ],
              ),
            ),


            Expanded(
              child: PageView(
                  controller: controller,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) { setState(() {selectedTab = index; }); },
                  scrollDirection: Axis.horizontal,
                  children: [

                    //const SizedBox(height: 10,)
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        (widget.user.getToken().type=="driver")?
                        SchoolDonationListFragment(theme: widget.theme,
                          user: widget.user,
                          school: widget.school, tr: widget.tr,)
                        :
                        SchoolFundraiserListFragment(theme: widget.theme,
                          user: widget.user,
                          school: widget.school, tr: widget.tr,),
                      ],
                    ),

                    Column(
                      children: [
                        const SizedBox(height: 16),
                        SchoolPostListFragment(theme: widget.theme, user: widget.user,
                          school: widget.school,
                          tr: widget.tr,),
                      ],
                    ),

                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: SchoolInfoFragment(onChanged: (val) async{ },
                            theme: widget.theme, tr: widget.tr, school: widget.school,),
                        ),
                      ],
                    ),

                  ]
              ),
            ),


          ],
        ),
      ),
      floatingActionButton:  FutureBuilder<bool?>(
        future: subscribed,
        builder: (context, snapshot) {
          print("snapshot $snapshot");
          if (snapshot.hasData) {
            if(snapshot.data??false){

              return const SizedBox(height: 0,); }
            // if(snapshot.data??false){
            //   return FloatingActionButton(
            //     onPressed: () {
            //       showDialog(
            //           context: context,
            //           builder: (BuildContext context) {
            //             return AlertDialog(
            //               // title: Text(widget.tr("are_you_sure", args: [(widget.school.full_name??'')])),
            //               title: Text(widget.tr("are_you_sure")),
            //               content:  Text(widget.tr("un_subscription_description")) ,
            //               actionsOverflowButtonSpacing: 20,
            //               actions: [
            //                 TextButton(
            //                     onPressed: () {
            //                       Navigator.of(context).pop();
            //                     },
            //                     child: Text(widget.tr("no"))),
            //                 TextButton(
            //                     onPressed: () async{
            //                       // if(widget.school.getSchool().topic!=null) {
            //                       //   FirebaseMessaging.instance.unsubscribeFromTopic(widget.school.getSchool().topic!).then((value){
            //                       //     print("SUCCESS: subscribing to topic ${widget.school.getSchool().topic}: ");
            //                       //   }).onError((error, stackTrace){
            //                       //     print("ERROR: subscribing to topic ${widget.school.getSchool().topic}: "+ error.toString());
            //                       //   });
            //                       // }
            //
            //                       await DonorRequest(widget.user).unSubscribe(
            //                           user_id: widget.user.id ?? 0,
            //                           school_id: widget.school.id ?? 0);
            //
            //                       setState(() {
            //                         subscribed = DonorRequest(widget.user).isSubscribed(
            //                           user_id: widget.user.id ?? 0,
            //                           school_id: widget.school.id ?? 0);
            //                       });
            //
            //                       Navigator.of(context).pop();
            //                     },
            //                     child: Text(widget.tr("yes"))),
            //               ],
            //               backgroundColor: widget.theme.cardColor,
            //               shape: const RoundedRectangleBorder(
            //                   borderRadius:
            //                   BorderRadius.all(Radius.circular(20))),
            //             );
            //           });
            //     },
            //     mini: true,
            //     child: Icon(Icons.subscribe, color: widget.theme.colorScheme.onSecondary ),
            //     backgroundColor: widget.theme.colorScheme.secondary,
            //   );
            // }else{
            isSubscribed = true;
              return FloatingActionButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          // title: Text(widget.tr("are_you_sure", args: [(widget.school.full_name??'')])),
                          title: Text(widget.tr("are_you_sure")),
                          content: Text(widget.tr("subscription_description")),
                          actionsOverflowButtonSpacing: 20,
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(widget.tr("no"))),
                            TextButton(
                                onPressed: () async{
                                  // if(widget.school.getSchool().topic!=null) {
                                  //   FirebaseMessaging.instance.subscribeToTopic(widget.school.getSchool().topic!).then((value){
                                  //     print("SUCCESS: subscribing to topic ${widget.school.getSchool().topic}: ");
                                  //   }).onError((error, stackTrace){
                                  //     print("ERROR: subscribing to topic ${widget.school.getSchool().topic}: "+ error.toString());
                                  //   });
                                  // }


                                  isSubscribed = await subscribe();
                                  if(!isSubscribed){
                                    Navigator.of(context).pop();
                                    return;
                                  }

                                  setState(() { isSubscribed = true; });
                                  setState(() { subscribed = DonorRequest(widget.user).isSubscribed(
                                      user_id: widget.user.id ?? 0,
                                      school_id: widget.school.id ?? 0); });
                                  Navigator.of(context).pop();
                                },
                                child: Text(widget.tr("yes"))),
                          ],
                          backgroundColor: widget.theme.cardColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                        );
                      });
                },
                mini: true,
                child: Icon(Icons.favorite, color: widget.theme.colorScheme.onSecondary ),
                backgroundColor: widget.theme.colorScheme.secondary,
              );
            // }
          } else if (snapshot.hasError) {
            return const SizedBox();
          }else {
            return const SizedBox();
          }

        }
      ),
    );
  }


  Future<bool> isSubscribedTo() async{
    bool? sol = false;
    try {
      if (widget.user.getToken().type == "driver") {
        sol = await DriverRequest(widget.user).isSubscribed(
            user_id: widget.user.id ?? 0, school_id: widget.school.id ?? 0);
      } else {
        sol = await DonorRequest(widget.user).isSubscribed(
            user_id: widget.user.id ?? 0, school_id: widget.school.id ?? 0);
      }
    }on DioError catch(e){
      ErrorHandlerUi().showErrorDialog(context: context,
          title: "error",
          description:  Utility.formatError(e, tr: widget.tr),
          theme: widget.theme,tr: widget.tr);
    }
    if(sol == null) { return Future.value(false);
    } else { return sol; }
  }


  Future<bool> subscribe() async{
    try {
      if (widget.user.getToken().type == "driver") {
        await DriverRequest(widget.user).subscribe(
            user_id: widget.user.id ?? 0,
            school_id: widget.school.id ?? 0);
      } else {
        await DonorRequest(widget.user).subscribe(
            user_id: widget.user.id ?? 0,
            school_id: widget.school.id ?? 0);
      }
    }on DioError catch(e){
      ErrorHandlerUi().showErrorDialog(context: context,
          title: "error",
          description:  Utility.formatError(e, tr: widget.tr),
          theme: widget.theme,tr: widget.tr);
      return Future.value(false);
    }
    return Future.value(true);
  }


  Future<bool> unSubscribe() async{
    try {
      if (widget.user.getToken().type == "driver") {
        await DriverRequest(widget.user).unSubscribe(
            user_id: widget.user.id ?? 0,
            school_id: widget.school.id ?? 0);
      } else {
        await DonorRequest(widget.user).unSubscribe(
            user_id: widget.user.id ?? 0,
            school_id: widget.school.id ?? 0);
      }
    }on DioError catch(e){
      ErrorHandlerUi().showErrorDialog(context: context,
          title: "error",
          description:  Utility.formatError(e, tr: widget.tr),
          theme: widget.theme,tr: widget.tr);
      return Future.value(false);
    }
    return Future.value(true);
  }

}




