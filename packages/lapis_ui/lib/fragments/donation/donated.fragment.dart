import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/widgets/cards/driver.card.dart';
import 'package:util/Utility.dart';

import '../../intro/payment.page.intro.dart';
import '../../pages/donation.direction.page.dart';
import '../../widgets/button.big.dart';
import '../../widgets/button.outline.big.dart';
import '../../widgets/donation.Items.dart';

class DonatedFragment extends StatefulWidget {
  const DonatedFragment(
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
  State<DonatedFragment> createState() => _DonatedFragmentState();
}

class _DonatedFragmentState extends State<DonatedFragment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text(widget.tr(widget.donation.status??'donated'), style: TextStyle( fontSize: 16,
                color: (widget.donation.status??'delivered')=='delivered'?Colors.green: Colors.blue ))

            ,const SizedBox( height: 10,),

            Text(("${Utility.format(widget.donation.amount??'0', true)} ETB"),
                style: TextStyle(fontSize: 32, color: widget.theme.colorScheme.onBackground,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DonationItems( fundraiserItems: widget.donation.getDonationItems(),
                  theme: widget.theme,
                  tr: widget.tr ),
            ),

            const SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox( width: MediaQuery.of(context).size.width,
                  child: Text( widget.donation.getFundraiser().title??"",
                      textAlign: TextAlign.left,
                      style: widget.theme.textTheme.bodyText1 )),
            ),

            const SizedBox(height: 8,),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                spacing: 10,
                runSpacing: 10,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/icons/school.png", width: 20, height: 20,
                        fit: BoxFit.cover,),
                      const SizedBox(width: 5,),
                      Text(widget.donation.getFundraiser().getUser().full_name??"",
                          style: widget.theme.textTheme.subtitle2 ),
                    ],
                  ),
                  //const SizedBox(height: 8,),
                  Row(
                    children: [
                      Image.asset("assets/icons/stationary.png", width: 20, height: 20,
                        fit: BoxFit.cover,),
                      const SizedBox(width: 5,),
                      Text(widget.donation.getStationary().full_name??"",
                          style: widget.theme.textTheme.subtitle2 ),
                    ],
                  ),

                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
              child: Text(widget.tr(widget.donation.getFundraiser().description??""),
                 textAlign: TextAlign.left, style: widget.theme.textTheme.subtitle2),
            ),

             if(widget.donation.Deliveries!=null && widget.donation.Deliveries!.isNotEmpty)
             DriverCard(theme: widget.theme, onClick: (x){},
                 tr: widget.tr, delivery: widget.donation.Deliveries![0]),

          ],
        ),

         Padding(
          padding: const EdgeInsets.fromLTRB(0, 60, 0, 16),
          child: ButtonOutlineBig( theme: widget.theme, child: Text( widget.tr("Direction"),
              style: TextStyle(color: widget.theme.colorScheme.onBackground, fontSize: 16)),
              onClick: () => {
                Navigator.push(
                    context,MaterialPageRoute(builder: (context) =>
                    DonationDirectionPage(tr: widget.tr, theme: widget.theme,
                      school: widget.donation.getFundraiser().getUser(),
                      stationary: widget.donation.getStationary(),
                      onDonationChanged: widget.onDonationChanged,
                      user: widget.user, donation: widget.donation,) )
                )
              }),
        ),
      ],
    );
  }
}