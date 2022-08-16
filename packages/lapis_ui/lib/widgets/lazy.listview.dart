import 'package:dio/dio.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lapis_ui/widgets/button.outline.big.dart';
import 'package:lapis_ui/widgets/list.view.error.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:rive/rive.dart';

class LazyListView extends StatefulWidget {
  const LazyListView({Key? key, required this.pagination, this.nested = false, required this.tr,
    required this.loadMore, required this.item, required this.theme, required this.onRetry,
    this.onNoData=""}) : super(key: key);

  final Future<dynamic> pagination;
  final Function(PaginationModel pagination, int page) loadMore;
  final Function(dynamic data) item;
  final ThemeData theme;
  final Function(String val, { List<String> args }) tr;
  final bool nested;
  final String onNoData;
  final Function onRetry;

  @override
  State<LazyListView> createState() => _LazyListViewState();

}

class _LazyListViewState extends State<LazyListView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: widget.pagination,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data.data.length==0&& widget.onNoData.isNotEmpty){
              return ListViewError(tr: widget.tr, error: widget.onNoData,
                  theme: widget.theme, onRetry: widget.onRetry);
            }
            return Flexible(
               fit: FlexFit.tight,
              child: LazyLoadScrollView(
                isLoading: isLoading,
                onEndOfPage: () async {
                  //print("isLoading1: $isLoading");
                  if ((snapshot.data.current_page ?? 0) < (snapshot.data.total_pages ?? 0) && !isLoading) {
                    setState(() {  isLoading = true; });
                    //print("isLoading2: $isLoading");
                    await widget.loadMore(snapshot.data, (snapshot.data.current_page ?? 1) +1);
                    //print("isLoading3: $isLoading");
                  }
                },
                child: ListView.builder(
                  itemCount: snapshot.data.data.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics:  (widget.nested)? const NeverScrollableScrollPhysics(): const BouncingScrollPhysics(),
                  itemBuilder: (context, position) {
                    return widget.item(snapshot.data.data[position]);
                  },
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return ListViewError(tr: widget.tr, error: snapshot.error??{"message": "unknown Error"},
                theme: widget.theme, onRetry: widget.onRetry);
          }
          // By default, show a loading spinner.
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }
    );
  }
}
