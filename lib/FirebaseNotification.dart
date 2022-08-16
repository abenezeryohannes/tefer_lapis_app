import 'dart:async';
import 'dart:ffi';
import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/current.user.model.dart';
import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/post.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/intro/fundraiser.page.intro.dart';
import 'package:lapis_ui/pages/donation.page.dart';
import 'package:lapis_ui/pages/post.page.dart';
import 'package:myapp/config/themes/app.theme.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import 'main.dart';

class FirebaseNotification {
    late StreamSubscription iosSubscription;

    static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      print("AB onBackgroundMessage: $message");
    }

    static void initState() {

      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions( alert: true,
        badge: true, sound: true,
      );

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print("Ab onMessage: $message");
        if(MyApp.navigatorKey.currentState!=null) {
          BuildContext context = MyApp.navigatorKey.currentState!.context;
          _showNotification(message, context);
        }
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
        print("Ab onMessageOpenedApp: $message");
        if(MyApp.navigatorKey.currentState!=null){
          BuildContext context = MyApp.navigatorKey.currentState!.context;
          handleNotificationClicks(message, context);
        }else {
          print("navigator key current state is null");
        }
      });
    }

    static Future<bool> handleNotificationClicks(RemoteMessage message, BuildContext context) async{
      if(message.data["messageType"]==null) return Future.value(false);

      if(message.data["messageType"]!.toLowerCase().contains("delivery-assignment")){
        //open donation
        if(message.data["id"]!=null) {
          Wrapper? wrapper = await DonorRequest(Provider.of<CurrentUserModel>(context).getUser())
              .getDonation(message.data["id"]??0);
          if(wrapper!=null&&(wrapper.success??false)){
              _openDonation(context: context, donation: wrapper.data);
          }else{
            print("error: ${ wrapper.toString() }");
            //toasterror
          }
        }

      }else if(message.data["messageType"]!.toLowerCase().contains("delivery-request-declined")){
        //open donation
        if(message.data["id"]!=null) {
          Wrapper? wrapper = await DonorRequest(Provider.of<CurrentUserModel>(context).getUser())
              .getDonation(message.data["id"]??0);
          if(wrapper!=null&&(wrapper.success??false)){
            _openDonation(context: context, donation: wrapper.data);
          }else{
            print("error: ${ wrapper.toString() }");
            //toasterror
          }
        }

      }else if(message.data["messageType"]!.toLowerCase().contains("new-fundraiser")){
        //open fundraiser
        if(message.data["id"]!=null) {

          FundraiserModel? fundraiserModel = await DonorRequest(Provider.of<CurrentUserModel>(context).getUser())
              .getFundraiser( id: message.data["id"]??0 );

          if(fundraiserModel!=null){
            _openFundraiser(context: context, fundraiserModel: fundraiserModel);
          }else{
            print("error: fundraiser is null");
            //toasterror
          }

        }

      }else if(message.data["messageType"]!.toLowerCase().contains("donation-delivered")){
        //open donation
        if(message.data["id"]!=null) {
          Wrapper? wrapper = await DonorRequest(Provider.of<CurrentUserModel>(context).getUser())
              .getDonation(message.data["id"]??0);
          if(wrapper!=null&&(wrapper.success??false)){
            _openDonation(context: context, donation: wrapper.data);
          }else{
            print("error: ${ wrapper.toString() }");
            //toasterror
          }
        }

      }else if(message.data["messageType"]!.toLowerCase().contains("payment-successful")){
        //open donation
        if(message.data["id"]!=null) {
          Wrapper? wrapper = await DonorRequest(Provider.of<CurrentUserModel>(context).getUser())
              .getDonation(message.data["id"]??0);
          if(wrapper!=null&&(wrapper.success??false)){
            _openDonation(context: context, donation: wrapper.data);
          }else{
            print("error: ${ wrapper.toString() }");
            //toasterror
          }
        }

      }else if(message.data["messageType"]!.toLowerCase().contains("new-post")){
        //open post
        if(message.data["id"]!=null) {
          Wrapper? wrapper = await DonorRequest(Provider.of<CurrentUserModel>(context).getUser())
              .getPost(message.data["id"]??0);
          if(wrapper!=null&&(wrapper.success??false)){
            _openPost(context: context, post: wrapper.data);
          }else{
            print("error: ${ wrapper.toString() }");
            //toasterror
          }
        }

      }
      return Future.value(true);
    }

    static void _showNotification(RemoteMessage message, BuildContext context){
      if(message.notification==null) return;
      bool loading = false;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  // title: Text(widget.tr("are_you_sure", args: [(widget.school.full_name??'')])),
                  title: Row(
                    children: [
                      Material(
                        elevation: 3.0,
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: RiveAnimation.asset('assets/anim/lapis.riv',
                            alignment:Alignment.center,
                            fit:BoxFit.contain,
                            stateMachines: const ['State Machine Idle'],
                            artboard: 'New Artboard',
                            animations: [(message.data["state"])??'idle'],
                          ),
                          radius: 15,
                        )),
                      const SizedBox(width: 5,),
                      Text(message.notification!.title??"", style: const TextStyle(fontSize: 18),),
                    ],
                  ),
                  content: (loading)? const Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: CircularProgressIndicator(),
                      ) : Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(message.notification!.body??"",style: const TextStyle(fontSize: 14),
                      maxLines: 6, overflow: TextOverflow.ellipsis,),
                  ),
                  actionsOverflowButtonSpacing: 20,
                  actions: [

                    if(message.data["negative"]!=null)
                    TextButton(
                        onPressed: () { Navigator.of(context).pop(); },
                        child: Text((tr(message.data["negative"])))
                    ),

                    if(message.data["positive"]!=null)
                    TextButton(
                        onPressed: () async{
                          setState((){loading=true;});
                          await handleNotificationClicks(message, context);
                          setState((){loading=false;});
                          Navigator.of(context).pop();
                        },
                        child: Text(tr(message.data["positive"]))
                    ),

                  ],
                  // backgroundColor: widget.theme.cardColor,
                  shape: const RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(20))),
                );
              }
            );
          });
    }

    static void _openDonation({required BuildContext context, required DonationModel donation, }){
        if(MyApp.navigatorKey.currentState!=null) {
          Navigator.push(
            MyApp.navigatorKey.currentState!.context,
            MaterialPageRoute(
                builder: (context) => DonationPage(tr: tr, theme: Provider.of<AppTheme>(context).getThemeData(),
                  fundraiser: donation.getFundraiser(), user: Provider.of<CurrentUserModel>(context).getUser(),
                  donation: donation, onEnd: () {  },)
            ));
        }else {
          print("current state is nul so can't open the donation page.");
        }
    }


    static void _openFundraiser({required BuildContext context, required FundraiserModel fundraiserModel,}){
      if(MyApp.navigatorKey.currentState!=null) {
        Navigator.push(
            MyApp.navigatorKey.currentState!.context,
            MaterialPageRoute(
                builder: (context) => FundraiserIntroPage(tr: tr, theme: Provider.of<AppTheme>(context).getThemeData(),
                  fundraiser: fundraiserModel, user: Provider.of<CurrentUserModel>(context).getUser(),
                   onEnd: () {  },)
            ));
      }else {
        print("current state is nul so can't open the donation page.");
      }
    }

    static void _openPost({required BuildContext context, required PostModel post, }){
      if(MyApp.navigatorKey.currentState!=null) {
        Navigator.push(
            MyApp.navigatorKey.currentState!.context,
            MaterialPageRoute(
                builder: (context) => PostPage(  theme: Provider.of<AppTheme>(context).getThemeData(),
                  post: post,)
            ));
      }else {
        print("current state is nul so can't open the donation page.");
      }
    }


}

