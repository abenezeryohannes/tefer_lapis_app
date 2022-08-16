import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:domain/controllers/user.request.dart';
import 'package:flutter/material.dart';
import 'package:lapis_ui/widgets/info.editor.dart';

class InfoFragment extends StatefulWidget {
  const InfoFragment({Key? key, required this.user, required this.onThemeChanged, required this.locales, required this.themes,
  required this.onChanged, required this.theme, required this.tr}) : super(key: key);

  final ThemeData theme;
  final Function(int) onThemeChanged;
  final UserModel user;
  final List<Locale> locales;
  final List<ThemeData> themes;
  final String Function(String, {List<String> args}) tr;
  final Function(UserModel) onChanged;

  @override
  State<InfoFragment> createState() => _InfoFragmentState();
}

class _InfoFragmentState extends State<InfoFragment> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 20),

        InfoEditor(theme: widget.theme, title: "full_name", tr: widget.tr, onChanged: (val){
          UserModel temp = widget.user; temp.full_name = val;  widget.onChanged(temp);  }, themes: widget.themes,
          value: widget.user.full_name??'', type: 'text', min: 0, max: 0, locales: widget.locales),

        InfoEditor(theme: widget.theme, title: "email_address", tr: widget.tr, onChanged: (val){
          UserModel temp = widget.user; temp.email_address = val;  widget.onChanged(temp);  }, themes: widget.themes,
          value: widget.user.email_address??'', type: 'email', min: 0, max: 0, locales: widget.locales),

        InfoEditor(theme: widget.theme, title: "phone_number", tr: widget.tr, onChanged: (val){
          UserModel temp = widget.user; temp.phone_number = val;  widget.onChanged(temp);  }, themes: widget.themes,
          value: widget.user.phone_number??'', type: 'phone_number', min: 0, max: 0, locales: widget.locales),

        InfoEditor(theme: widget.theme, title: "address", tr: widget.tr, onChanged: (val){
          UserModel temp = widget.user; temp.getLocation().address = val;  widget.onChanged(temp);  },  themes: widget.themes,
          value: widget.user.getLocation().address??'', type: 'text', min: 0, max: 0, locales: widget.locales),

        // InfoEditor(theme: widget.theme, title: "language", tr: widget.tr, onChanged: (val){
        // UserModel temp = widget.user; temp.locale = val;  widget.onChanged(temp);  }, themes: widget.themes,
        //   value: widget.user.locale??'', type: 'locale', min: 0, max: 0, locales: widget.locales),

        InfoEditor(theme: widget.theme, title: "theme", tr: widget.tr, onChanged: (val){
            widget.onThemeChanged(int.parse(val));
          }, themes: widget.themes,
          value: AdaptiveTheme.of(context).mode.name, type: 'theme', min: 0, max: 100, locales: widget.locales),

        const SizedBox(height: 20)
      ],
    );
  }

}
