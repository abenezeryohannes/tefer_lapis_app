import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';

class DonationWalkthroughPage extends StatefulWidget {
  const DonationWalkthroughPage( {Key? key,required this.fundraiser,
      required this.theme, required this.tr, required this.user}) : super(key: key);

  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final UserModel user;
  final FundraiserModel fundraiser;

  @override
  State<DonationWalkthroughPage> createState() => _DonationWalkthroughPageState();
}

class _DonationWalkthroughPageState extends State<DonationWalkthroughPage> {

  PageController controller = PageController(initialPage: 0);
  late DonationModel Donation;

  @override
  void initState() { super.initState(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            ((controller.page??4) < 2)?Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.cancel),
                          color: widget.theme.colorScheme.onBackground,
                          onPressed: () {

                          } ),
                      const SizedBox(width: 5),
                      Text( (controller.page??4)==0?widget.tr(widget.fundraiser.title??""): widget.tr("choose_stationary"),
                          style: widget.theme.textTheme.headline5)
                    ],
                  )
                ],
              ),
            ):const SizedBox(width: 0,),

            PageView(
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [ ]
            ),
          ]
        )

      ),
    );
  }
}
