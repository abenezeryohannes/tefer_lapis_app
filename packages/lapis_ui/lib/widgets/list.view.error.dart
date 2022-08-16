import 'package:dio/dio.dart';
import 'package:domain/models/pagination.model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lapis_ui/widgets/button.outline.big.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:rive/rive.dart';
import 'package:util/Utility.dart';

class ListViewError extends StatefulWidget {
  const ListViewError({Key? key, required this.tr, required this.error,
    required this.theme, required this.onRetry}) : super(key: key);

  final Object error;
  final ThemeData theme;
  final Function(String val, { List<String> args }) tr;
  final Function onRetry;

  @override
  State<ListViewError> createState() => _ListViewErrorState();

}

class _ListViewErrorState extends State<ListViewError> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
            if (widget.error is DioError){
              DioError error = widget.error as DioError;
              if(error.type == DioErrorType.connectTimeout || error.type == DioErrorType.receiveTimeout
                  || error.type == DioErrorType.sendTimeout){
                return Expanded( child:
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Material(
                            elevation: 8.0,
                            color: Colors.transparent,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: RiveAnimation.asset('assets/anim/lapis.riv',
                                alignment:Alignment.center,
                                fit:BoxFit.contain,
                                stateMachines: ['State Machine Idle'],
                                artboard: 'New Artboard',
                                animations: ['idle'],
                              ),
                              radius: 42,
                            )),
                        const SizedBox(height: 20),
                        Text(widget.tr("connection_error"), style: widget.theme.textTheme.bodyText2, ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: 120,
                            child:
                            ButtonOutlineBig(theme: widget.theme,
                                child: Text(widget.tr("retry"), style: TextStyle(fontSize: 16),),
                                onClick: (){
                                  widget.onRetry();
                                }),
                        )
                      ],
                    ),
                  )
                );

              }else {
                return Expanded( child: Center(child:
                Text(Utility.formatError(error, tr: widget.tr),
                  textAlign: TextAlign.center,style:  widget.theme.textTheme.subtitle1, )), );
              }
            }
            return Expanded( child: Container(
              alignment: const Alignment(0, -1/2),
              // color: Colors.red,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Material(
                      elevation: 8.0,
                      color: Colors.transparent,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: RiveAnimation.asset('assets/anim/lapis.riv',
                          alignment:Alignment.center,
                          fit:BoxFit.contain,
                          stateMachines: ['State Machine Idle'],
                          artboard: 'New Artboard',
                          animations: ['idle'],
                        ),
                        radius: 42,
                      )),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text("${widget.error}", textAlign: TextAlign.center,
                            style: widget.theme.textTheme.subtitle1, ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ), );

  }
}
