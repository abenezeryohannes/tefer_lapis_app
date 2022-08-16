import 'package:flutter/material.dart';
import 'package:walkthrough/config/AppTheme.dart';
import 'package:walkthrough/domain/asset_types.dart';
import 'package:walkthrough/domain/walkthrough_item.dart';

class Walk {
  List<WalkthroughItem> walkthroughItems = [];
  BuildContext context;
  final String Function(String) tr;
  final ThemeData theme;

  Walk({required this.context, required this.tr, required this.theme});
  Walk.initialize({required this.theme, required this.walkthroughItems, required this.context, required this.tr});


  Widget info(int index) {
    return Container(
        //margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        alignment: Alignment.center,
        child: Stack(children: [
          
          //background
          (walkthroughItems[index].assetType == AssetType.BG)
              ? Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(
                            "assets/${(walkthroughItems[index].directory.length > 1) ? (walkthroughItems[index].directory + "/") : ""}${walkthroughItems[index].asset}"),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      )),
                      //color: Colors.red,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  // Align(
                  //   alignment: Alignment.topCenter,
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height/3,
                  //     width: MediaQuery.of(context).size.width,
                  //     decoration: const BoxDecoration(
                  //       gradient: LinearGradient(colors: [Colors.black54, Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  //   ),
                  // ),
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height/2,
                  //     width: MediaQuery.of(context).size.width,
                  //     decoration: const BoxDecoration(
                  //       gradient: LinearGradient(colors: [Colors.black54, Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                  //   ),
                  // )
                ],
              )
              : const SizedBox(height: 0, width: 0),
          
          //non background image or anime
          Column(
            children: <Widget>[
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          // color: Colors.red,
                          margin: const EdgeInsets.only(bottom: 20, top: 50),
                          width: MediaQuery.of(context).size.width*4/5,
                          height: MediaQuery.of(context).size.width*4/5,
                          child: (walkthroughItems[index].assetType ==
                                  AssetType.IMAGE)
                              ? Image.asset(
                                  "assets/${(walkthroughItems[index].directory.length > 1) ? (walkthroughItems[index].directory + "/") : ""}${walkthroughItems[index].asset}",
                                  alignment: Alignment.bottomCenter,
                                  fit: BoxFit.contain,
                                )
                              : const SizedBox(height: 0)
                          // : FlareActor(
                          //     "assets/animations/bluetooth_walkthrough.flr",
                          //     alignment: Alignment.center,
                          //     isPaused: false,
                          //     fit: BoxFit.contain,
                          //     animation: "pulse")
                          ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Column(                         
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          
                          children: <Widget> [
                            Text(
                              tr(walkthroughItems[index].title),
                              textAlign: TextAlign.left,
                              style: theme.textTheme.headline6
                              ),
                            const SizedBox(height:30),
                            Text(
                                tr(walkthroughItems[index]
                                  .description), //walkDesc[index],
                              textAlign: TextAlign.left,
                              style: theme.textTheme.subtitle1
                            ),
                            const SizedBox(height:30)
                          ],
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ]));
  }
}
