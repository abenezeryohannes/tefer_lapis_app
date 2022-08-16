import 'package:domain/controllers/donor.request.dart';
import 'package:domain/models/subscription.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/fragments/school/school.fundraiser.list.fragment.dart';
import 'package:lapis_ui/fragments/school/school.info.fragment.dart';
import 'package:lapis_ui/fragments/school/school.post.list.fragment.dart';
import 'package:lapis_ui/fragments/stationary/stationary.items.list.fragment.dart';
import 'package:util/RequestHandler.dart';
import '../fragments/stationary/stationary.info.fragment.dart';
import '../widgets/tab.dart';

class StationaryPage extends StatefulWidget {
  const StationaryPage({Key? key,
    required this.user,
    required this.theme,
    required this.stationary,
    required this.tr})
      : super(key: key);

  final UserModel user;
  final UserModel stationary;
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;

  @override
  State<StationaryPage> createState() => _StationaryPageState();
}

class _StationaryPageState extends State<StationaryPage> {

  int selectedTab = 0;
  PageController controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: widget.theme.backgroundColor,
              expandedHeight: 200,
              floating: true,
              pinned: true,
              leading: InkWell(onTap: () {Navigator.maybePop(context);}, child: const Icon(Icons.cancel)),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Hero(
                      tag: "stationary_image"+widget.stationary.id.toString(),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage('${RequestHandler.baseImageUrl}${widget.stationary.avatar}'),
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
                title: Text(widget.stationary.full_name ?? "",
                  style: TextStyle(
                      color: widget.theme.colorScheme.onBackground,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),),
              ),
            ),
          ];
        },
        body: Column(

          children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 10.0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MyTab(
                      theme: widget.theme,
                      items: [
                        TabItem(name: widget.tr('stock')),
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


                    Column(
                      children: [
                        StationaryItemListFragment(theme: widget.theme,
                          user: widget.user, stationary: widget.stationary,
                          tr: widget.tr,),
                      ],
                    ),


                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: StationaryInfoFragment(onChanged: (val) async{ },
                            theme: widget.theme, tr: widget.tr, stationary: widget.stationary,),
                        ),
                      ],
                    ),
                  ]
              ),
            ),

          ],
        ),
      ),
    );
  }

}




