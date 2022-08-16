import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:util/Utility.dart';

import '../../intro/payment.page.intro.dart';
import '../../widgets/button.big.dart';
import '../../widgets/donation.Items.dart';

class AddDonationFragment extends StatefulWidget {
  const AddDonationFragment(
      {Key? key,required this.donation, required this.theme, required this.tr, required this.user})
      : super(key: key);
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final UserModel user;
  final DonationModel donation;

  @override
  State<AddDonationFragment> createState() => _AddDonationFragmentState();
}

class _AddDonationFragmentState extends State<AddDonationFragment> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [


              Text(widget.tr("add_donation"), style: TextStyle( fontSize: 16, color: widget.theme.colorScheme.secondary )),

              const SizedBox( height: 10,),

              Text(("${Utility.format(widget.donation.amount??'0', true)} ETB"), style: widget.theme.textTheme.headline1),
              const SizedBox(height: 30,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DonationItems(fundraiserItems: widget.donation.getDonationItems(), theme: widget.theme, tr: widget.tr),
              ),

              const SizedBox(height: 30,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox( width: MediaQuery.of(context).size.width,
                    child: Text(widget.donation.getFundraiser().title??"", textAlign: TextAlign.center, style: widget.theme.textTheme.headline6)),
              ),

              const SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Row(
                      children: [
                        Image.asset("assets/icons/school.png", width: 24, height: 24, fit: BoxFit.cover,),
                        const SizedBox(width: 5,),
                        Text(widget.donation.getFundraiser().getUser().full_name??"", style: widget.theme.textTheme.subtitle1 ),
                      ],
                    ),

                    Row(
                      children: [
                        Image.asset("assets/icons/stationary.png", width: 24, height: 24, fit: BoxFit.cover,),
                        const SizedBox(width: 5,),
                        Text(widget.donation.getStationary().full_name??"", style: widget.theme.textTheme.subtitle1 ),
                      ],
                    ),

                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
                child: Text(widget.tr(widget.donation.getFundraiser().description??""),
                    textAlign: TextAlign.center, style: widget.theme.textTheme.subtitle1),
              ),

            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: ButtonBig( theme: widget.theme, child: Text( widget.tr("continue"), style: widget.theme.textTheme.button), onClick: () => {

              Navigator.pushReplacement(
                  context,MaterialPageRoute(builder: (context) =>
                  PaymentPageIntro(tr: widget.tr, theme: widget.theme, fundraiser: widget.donation.getFundraiser(), user: widget.user, donation: DonationModel.fresh(),) )
              )

            }),
          )
        ],
      ),
    );
  }
}
