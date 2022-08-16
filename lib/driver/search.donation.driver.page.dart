import 'package:domain/models/pagination.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/widgets/lazy.listview.dart';

class SearchDonationDriverPage extends StatefulWidget {
  const SearchDonationDriverPage({Key? key,
    required this.user,
    required this.theme,
    required this.mapItem,
    required this.request,
    required this.tr})
      : super(key: key);

  final UserModel user;
  final ThemeData theme;
  // final Function(PaginationModel pagination, int page) loadMore;
  final Widget Function(dynamic) mapItem;
  final String Function(String, {List<String> args}) tr;
  final Future<PaginationModel?> Function({PaginationModel? pagination, int page, String search}) request;

  @override
  State<SearchDonationDriverPage> createState() => _SearchDonationDriverPageState();
}

class _SearchDonationDriverPageState extends State<SearchDonationDriverPage> {

  late Future<PaginationModel?> searchPagination;
  String search = "";


  @override
  void initState() {
    super.initState();
    searchPagination = widget.request(page: 1, search: search);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'search_bar',
              child: Card(
                elevation: 5,
                color: widget.theme.cardColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: widget.theme.dividerColor,),
                      tooltip: widget.tr('clear'),
                      onPressed: () {
                        if(Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*10/12,
                      child: TextField(
                         autofocus: true,
                         style: widget.theme.textTheme.bodyText2,
                         onChanged: (text) async{
                           setState(() { search = text; });
                           await Future.delayed(const Duration(milliseconds: 500), (){});
                           setState(() {
                             searchPagination = widget.request(search: text, page: 1);
                           });
                         },
                          onTap: () {  },
                          decoration: InputDecoration(
                            hintText: widget.tr("search"),
                            border: InputBorder.none,

                            focusColor: widget.theme.colorScheme.secondary,
                            constraints: const BoxConstraints(maxHeight: 42),
                            filled: false, fillColor: widget.theme.backgroundColor,
                            hintStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 16,
                                color: widget.theme.dividerColor),
                            contentPadding: const EdgeInsets.symmetric( horizontal: 10, vertical: 10),
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10,),

            if(search.isNotEmpty)
            LazyListView(
                tr: widget.tr,
                onRetry: (){widget.request(search: search, page:1);},
                pagination: searchPagination,
                onNoData: "No donation related to this search.",
                loadMore: (pagination, page) async{ widget.request(search: search, pagination:pagination, page:page);},
                item: (data) =>  widget.mapItem(data),
                theme: widget.theme ),




          ],
        ),
      ),
    );
  }
}
