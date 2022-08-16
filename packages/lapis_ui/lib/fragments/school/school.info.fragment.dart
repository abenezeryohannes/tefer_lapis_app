import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/widgets/info.editor.dart';

class SchoolInfoFragment extends StatefulWidget {
  const SchoolInfoFragment({Key? key, required this.school,
  required this.onChanged, required this.theme, required this.tr}) : super(key: key);

  final ThemeData theme;
  final UserModel school;
  final String Function(String, {List<String> args}) tr;
  final Function(UserModel) onChanged;

  @override
  State<SchoolInfoFragment> createState() => _SchoolInfoFragmentState();
}

class _SchoolInfoFragmentState extends State<SchoolInfoFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          InfoEditor(theme: widget.theme, title: "email_address",
            editable: false,themes: const [], locales: const [],
            tr: widget.tr, onChanged: (val){ },
            value: widget.school.email_address??'',
            type: 'email', min: 0, max: 0 ),

          InfoEditor(theme: widget.theme, title: "phone_number",
            editable: false, themes: const [], locales: const [],
            tr: widget.tr, onChanged: (val){ },
            value: widget.school.phone_number??'',
            type: 'phone_number', min: 0, max: 0,),

          InfoEditor(theme: widget.theme, title: "address",
            editable: false,themes: const [], locales: const [],
            tr: widget.tr, onChanged: (val){ },
            value: widget.school.getLocation().address??'',
            type: 'text', min: 0, max: 0,),

          // InfoEditor(theme: widget.theme, title: "students",
          //   editable: false,themes: const [], locales: const [],
          //   tr: widget.tr, onChanged: (val){  },
          //   value: widget.school.getSchool().students,
          //   type: 'number', min: 0, max: 10000000,),

          // InfoEditor(theme: widget.theme, title: "scope",
          //   editable: false,themes: const [], locales: const [],
          //   tr: widget.tr, onChanged: (val){},
          //   value: widget.school.getSchool().scope,
          //   type: 'text', min: 0, max: 0,),
        ],
      )
    );
  }

}
