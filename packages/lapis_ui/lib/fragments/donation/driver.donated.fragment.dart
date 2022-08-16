import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/widgets/cards/driver.card.dart';
import 'package:util/Utility.dart';

import '../../intro/payment.page.intro.dart';
import '../../pages/donation.direction.page.dart';
import '../../pages/driver.donation.direction.page.dart';
import '../../widgets/button.big.dart';
import '../../widgets/button.outline.big.dart';
import '../../widgets/donation.Items.dart';

class DriverDonatedFragment extends StatefulWidget {
  const DriverDonatedFragment(
      {Key? key,
        required this.onDonationChanged, required this.donation, required this.theme, required this.tr,
        required this.user})
      : super(key: key);
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final void Function(DonationModel) onDonationChanged;
  final UserModel user;
  final DonationModel donation;

  @override
  State<DriverDonatedFragment> createState() => _DriverDonatedFragmentState();
}

class _DriverDonatedFragmentState extends State<DriverDonatedFragment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Text(widget.donation.getFundraiser().title??'',textAlign: TextAlign.start,
                  style: widget.theme.textTheme.bodyText1),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              child: Text(widget.tr(widget.donation.getFundraiser().description??""), style: widget.theme.textTheme.subtitle2),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(widget.tr('raised'),
                        style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                        ),),
                      const SizedBox(height: 3),
                      Text(("${Utility.format(widget.donation.amount??'0', true)} ETB"),
                          style: widget.theme.textTheme.bodyText2),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.tr('donated'),
                        style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                        ),),
                      const SizedBox(height: 3),
                      Text(widget.tr('items', args: [(widget.donation.getDonationItems().length).toString()]),
                        style: widget.theme.textTheme.bodyText2,),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20,),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DonationItems(
                    fundraiserItems: widget.donation.getDonationItems(),
                    theme: widget.theme,
                    tr: widget.tr
                ),
              ),
            ),

            const SizedBox(height: 30,),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Image.asset( "assets/icons/stationary.png", width: 16, height: 16, ),
                      Text(
                        Utility.shorten(text: widget.tr("start:"), max: 14),
                        style: widget.theme.textTheme.bodyText2,
                      ),
                      const SizedBox( width: 5 ),
                      Text(
                        // Utility.shorten(text: widget.donation.getStationary().full_name, max: 14),
                        widget.donation.getStationary().full_name??'',
                        style: widget.theme.textTheme.bodyText2,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      )
                    ],
                  ),
                  const SizedBox( height: 8 ),
                  Row(
                    children: [
                      Icon(Icons.add_location, size:20, color: widget.theme.dividerColor),
                      const SizedBox(width: 4),
                      Text(
                        // Utility.shorten(text: widget.donation.getStationary().getLocation().address ?? "", max: 16),
                        widget.donation.getStationary().getLocation().address ?? "",
                        style: widget.theme.textTheme.subtitle1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Divider( color: widget.theme.dividerColor, ),
            ),

            if(widget.donation.getStationary().id!=null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Image.asset('assets/icons/school.png',
                        //   fit: BoxFit.fill, height: 16, width: 16,),
                        Text(
                          Utility.shorten(text: widget.tr("destination:"), max: 14),
                          style: widget.theme.textTheme.bodyText2,
                        ),
                        const SizedBox( width: 5 ),
                        Text(
                          //Utility.shorten(text: widget.donation.getSchool().full_name, max: 16),
                          widget.donation.getSchool().full_name??'',
                          style: widget.theme.textTheme.bodyText2,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        )
                      ],
                    ),
                    const SizedBox( height: 8 ),
                    Row(
                      children: [
                        Icon(Icons.add_location, size:20, color: widget.theme.dividerColor),
                        const SizedBox(width: 4),
                        Text(
                          // Utility.shorten(text: widget.donation.getSchool().getLocation().address ?? "", max: 14),
                          widget.donation.getSchool().getLocation().address ?? "",
                          style: widget.theme.textTheme.subtitle1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    )
                  ],
                ),
              ),

      const SizedBox(height: 20),






      // if((widget.donation.getDeliveries().isNotEmpty)&&widget.donation.getDeliveries().first.status=="delivered")
      //   Padding(
      //     padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
      //     child: Text('thanks_for_your_delivery_service', style: widget.theme.textTheme.bodyText1),
      //   ),
      if((widget.donation.getDeliveries().isNotEmpty)&&widget.donation.getDeliveries().first.status=="delivered")
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

             Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child:  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: Icon(Icons.play_arrow, size: 32, color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text(widget.tr(
                          Utility.showDateSmall(tr: widget.tr, time: widget.donation.getDeliveries().first.trip_start_time!)),
                          style: widget.theme.textTheme.bodyText2),
                    ],
                  )
              ),

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child:  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: Icon(Icons.stop, size: 32, color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text(widget.tr(
                          Utility.showDateSmall(tr: widget.tr, time: widget.donation.getDeliveries().first.trip_end_time!)),
                          style: widget.theme.textTheme.bodyText2),
                    ],
                  )
              ),


            InkWell(
              onTap: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) =>
                    DriverDonationDirectionPage(tr: widget.tr, theme: widget.theme,
                      school: widget.donation.getFundraiser().getUser(),
                      fundraiser: widget.donation.getFundraiser(),
                      stationary: widget.donation.getStationary(),
                      user: widget.user, donation: widget.donation,) ));
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child:  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: Icon(Icons.directions, size: 32, color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text(widget.tr('direction'),
                          style: widget.theme.textTheme.bodyText2),
                    ],
                  )
              ),
            ),
          ],
        )



          ],
        ),








      ],
    );
  }
}