import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/widgets/info.editor.dart';

class StationaryInfoFragment extends StatefulWidget {
  const StationaryInfoFragment({Key? key, required this.stationary,
  required this.onChanged, required this.theme, required this.tr}) : super(key: key);

  final ThemeData theme;
  final UserModel stationary;
  final String Function(String, {List<String> args}) tr;
  final Function(UserModel) onChanged;

  @override
  State<StationaryInfoFragment> createState() => _StationaryInfoFragmentState();
}

class _StationaryInfoFragmentState extends State<StationaryInfoFragment> {
  @override
  Widget build(BuildContext context) {
    return Column(

      children: [

        InfoEditor(theme: widget.theme, title: "email_address",
          editable: false,themes: const [], locales: const [],
          tr: widget.tr, onChanged: (val){ },
          value: widget.stationary.email_address??'',
          type: 'email', min: 0, max: 0 ),

        InfoEditor(theme: widget.theme, title: "phone_number",
          editable: false,themes: const [], locales: const [],
          tr: widget.tr, onChanged: (val){ },
          value: widget.stationary.phone_number??'',
          type: 'phone_number', min: 0, max: 0,),

        InfoEditor(theme: widget.theme, title: "address",
          editable: false,themes: const [], locales: const [],
          tr: widget.tr, onChanged: (val){ },
          value: widget.stationary.getLocation().address??'',
          type: 'text', min: 0, max: 0,),

        // InfoEditor(theme: widget.theme, title: "students",
        //   editable: false,themes: const [], locales: const [],
        //   tr: widget.tr, onChanged: (val){  },
        //   value: widget.stationary.getStationary().students,
        //   type: 'number', min: 0, max: 10000000,),
        //
        // InfoEditor(theme: widget.theme, title: "scope",
        //   editable: false,themes: const [], locales: const [],
        //   tr: widget.tr, onChanged: (val){},
        //   value: widget.stationary.getStationary().scope,
        //   type: 'text', min: 0, max: 0,),
      ],
    );
  }

}
