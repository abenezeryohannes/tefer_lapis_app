import 'dart:ui';

import 'package:domain/models/stationary.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:util/RequestHandler.dart';
import 'package:util/Utility.dart';

class SchoolCard extends StatefulWidget {
  const SchoolCard({Key? key, required this.school, required this.user, required this.onClick,
      required this.theme, required this.tr})
      : super(key: key);

  final UserModel school;
  final UserModel user;
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final void Function(UserModel) onClick;

  @override
  State<SchoolCard> createState() => _SchoolCardState();
}

class _SchoolCardState extends State<SchoolCard> {
  @override
  Widget build(BuildContext context) {
    return  Card(
      semanticContainer: true,
      elevation: 0,
      color: Colors.transparent,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell( onTap: (){ widget.onClick(widget.school); },
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          alignment: Alignment.bottomLeft,
          children: [
            Hero(
              tag: "school_image_"+(widget.school.id.toString()),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage('${RequestHandler.baseImageUrl}${widget.school.avatar}'),
                  ),
                ),
              ),
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                  gradient:  RadialGradient(
                    radius: 10, 
                    colors: <Color>[
                      Colors.black45.withOpacity(0.2),
                      Colors.black45
                    ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10,14,10,12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(widget.school.full_name??"",
                            style: const TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   children: [
                      //     Text(widget.tr("students", args:['${widget.school.getSchool().students??'-'}']),
                      //         style: widget.theme.textTheme.caption),
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add_location, color: Colors.white, size: 16,),
                          const SizedBox(width: 3,),
                          Text(widget.school.getLocation().address ?? "",
                              style: TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.w400 ) ),
                        ],
                      ),
                      Text(widget.tr("km_away", args:[
                        Utility.calculateDriveMinute(widget.school.getLocation().latitude,
                            widget.school.getLocation().longitude,
                            widget.user.getLocation().latitude,
                            widget.user.getLocation().longitude).toString()
                      ]), style: TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.normal )),
                    ],
                  )
                ],
              ),
            ),

          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      //elevation: 5,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    );
  }
}
