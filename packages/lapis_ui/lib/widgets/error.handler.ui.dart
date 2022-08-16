import 'package:flutter/material.dart';

class ErrorHandlerUi{

  void showErrorDialog({required BuildContext context, required String title,
          required String description,required ThemeData theme,
          required Function(String, { List<String> args }) tr}){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(tr(title), style: theme.textTheme.headline6,),
            content: Text(tr(description), style: theme.textTheme.subtitle1),
            actionsOverflowButtonSpacing: 20,
            actions: [
              TextButton(
                  onPressed: () async{
                    if(Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(tr("ok"), style: theme.textTheme.bodyText2)),
            ],
            backgroundColor: theme.cardColor,
            shape: const RoundedRectangleBorder( borderRadius:
            BorderRadius.all(Radius.circular(20))),
          );});
  }
}