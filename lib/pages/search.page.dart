import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/fragments/donations.list.fragment.dart';
import 'package:lapis_ui/fragments/search/fundraiser.list.fragment.dart';
import 'package:lapis_ui/fragments/search/post.list.fragment.dart';
import 'package:lapis_ui/fragments/search/school.list.fragment.dart';
import 'package:lapis_ui/fragments/search/stationary.list.fragment.dart';
import 'package:lapis_ui/widgets/search.textfield';
import 'package:lapis_ui/widgets/tab.dart';
import 'package:lapis_ui/fragments/search/map.navigator.fragment.dart';
import 'package:myapp/driver/driver.donation.list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({ Key? key, required this.saveUser,
    required this.user, required this.theme, required this.tr })
      : super(key: key);

  final UserModel user;
  final ThemeData theme;
  final String Function(String, {List<String> args}) tr;
  final void Function(UserModel newUser) saveUser;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = "";
  int selectedTab = 1;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: _title(),
              backgroundColor: widget.theme.scaffoldBackgroundColor,
              floating: true,
              pinned: true,
              // iconTheme: const IconThemeData(size: 0),
              leadingWidth: 0,
              expandedHeight: 100,
              forceElevated: innerBoxIsScrolled,
              // bottom: PreferredSize(preferredSize: Size( MediaQuery.of(context).size.width, 64),
              // child: _greetingWidget()),
              flexibleSpace: FlexibleSpaceBar(
                // title: _title(),
                expandedTitleScale: 1,
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(0,50,0,0),
                  child: _background(),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            _buildFragment(searchText),
          ],
        )
    );
  }

  Widget _title(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: (searchText.isNotEmpty)?widget.theme.colorScheme.onBackground:
          widget.theme.dividerColor.withOpacity(0.4),),
          tooltip: widget.tr('clear'),
          onPressed: () {
            setState(() { searchText = "";});
            FocusScope.of(context).unfocus();
          },
        ),
        Expanded(
            child: SearchTextField(
                hint: widget.tr("search"),
                text: searchText, theme: widget.theme,
                onChange: (txt){
                  setState(() { searchText = txt; });
                }
            )
        )
      ],
    );
  }

  Widget _background(){
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                child: MyTab(theme: widget.theme, items: [
                  TabItem(name: widget.tr('explore'), type: "main", icon: Icons.explore),
                  TabItem(name: widget.tr('schools')),
                  (widget.user.getToken().type=="driver")?
                      TabItem(name: widget.tr('donations')):
                      TabItem(name: widget.tr('fundraisers')),
                  TabItem(name: widget.tr('posts')),
                  TabItem(name: widget.tr('stationaries')),
                ],
                    selected: selectedTab,
                    onChange: (index){ setState(() { selectedTab = index; });}),
              ),
            ),
          ),
        ],
      );
  }


  Widget _buildFragment(String search){
    switch(selectedTab){
      case 0:
        return MapNavigatorFragment(tr: widget.tr, user: widget.user, theme: widget.theme, search: search);
      case 1:
        return SchoolListFragment( tr: widget.tr, user: widget.user, theme: widget.theme, search: search);
      case 2:
        if(widget.user.getToken().type=="driver") {
          return DriverDonationList( tr: widget.tr, user: widget.user, theme: widget.theme, search: search);
        } else {
          return FundraiserListFragment( tr: widget.tr, user: widget.user, theme: widget.theme, search: search);
        }
      case 3:
        return PostListFragment( tr: widget.tr, user: widget.user, theme: widget.theme, search: search);
      case 4:
        return StationaryListFragment( tr: widget.tr, user: widget.user, theme: widget.theme, search: search);
      default:
        return const SizedBox();
    }
  }
}