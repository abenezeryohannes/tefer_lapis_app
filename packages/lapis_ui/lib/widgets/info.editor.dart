import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';

import '../pages/select.theme.page.dart';

class InfoEditor extends StatefulWidget {
  const InfoEditor(
      {Key? key,
      required this.onChanged,
      required this.theme,
      required this.type,
      required this.title,
      required this.themes,
        this.editable = true,
      required this.value,
        required this.min,
        required this.locales,
        required this.max,
      required this.tr})
      : super(key: key);

  final ThemeData theme;
  final String type;
  final String title;
  final List<ThemeData> themes;
  final List<Locale> locales;
  final dynamic value;
  final int max;
  final int min;
  final bool editable;
  final String Function(String, {List<String> args}) tr;
  final Function(String) onChanged;

  @override
  State<InfoEditor> createState() => _InfoEditorState();
}

class _InfoEditorState extends State<InfoEditor> {
  final _formKey = GlobalKey<FormState>();
  late BuildContext _context;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    _context = context;
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: Text(
            widget.tr(widget.title),
            style: widget.theme.textTheme.bodyText2,
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            color: widget.theme.cardColor,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildValue(),
              if(widget.editable&&!editing)
                InkWell(
                    onTap: () {
                      setState(() { editing  = true; });
                    },
                    child: Icon( Icons.edit, size: 24,
                      color: widget.theme.dividerColor.withOpacity(0.6),
                    ))
                else if(editing&&widget.editable)
                  InkWell(
                    onTap: (){
                      if(widget.type.toLowerCase()=='theme'&&_selectedTheme>=0){
                        widget.onChanged(_selectedTheme.toString());
                        setState(() { editing = false; });
                        return;
                      }
                      if( widget.type.toLowerCase()=='locale'|| (_formKey.currentState!=null &&
                          _formKey.currentState!.validate())) {
                        widget.onChanged(controller.value.text);
                        setState(() { editing = false; });
                      }
                    },
                    child: Text(widget.tr('save'), style: widget.theme.textTheme.bodyText2,),
                  )
              ],
            ))
      ],
    );
  }

  bool editing = false;

  Widget _buildValue() {
    switch (widget.type.toLowerCase()) {
      default:
        return ((widget.value == 'null'||widget.value.length == 0) &&(!editing))?
        Text(widget.tr('not_set_yet'), style: TextStyle(color: widget.theme.dividerColor, fontWeight: FontWeight.bold, fontSize: 14)):
        (!editing)?Text('${widget.value}', style: widget.theme.textTheme.subtitle2):
            _showEditor(widget.type.toLowerCase());
    }
    //return const SizedBox(height: 30);
  }
  int _selectedTheme = -1;
  Widget _showEditor(String type){
    controller.text = widget.value.toString();
    switch (type) {
      case "email":
        return Form(
          key: _formKey,
          child: Expanded(
            child: TextFormField(
              controller: controller,
              validator: (value) => validateEmail(value),
            ),
          ),
        );
      case "phone_number":
        return Form(
          key: _formKey,
          child: Expanded(
            child: TextFormField(
              controller: controller,
              validator: (value) => validatePhoneNumber(value),
            ),
          ),
        );
      case "number":
        return Form(
          key: _formKey,
          child: Expanded(
            child: TextFormField(
              controller: controller,
              //initialValue: widget.value,
              validator: (value) => validateNumber(value),
            ),
          ),
        );
      case "text":
        return Form(
          key: _formKey,
          child: Expanded(
            child: TextFormField(
              controller: controller,
              // initialValue: widget.value,
            ),
          ),
        );
      case "theme":
        if(_selectedTheme==-1){
        _selectedTheme = AdaptiveTheme.of(context).mode.isLight?0:_selectedTheme;
        _selectedTheme = AdaptiveTheme.of(context).mode.isDark?1:_selectedTheme;
        _selectedTheme = AdaptiveTheme.of(context).mode.isSystem?2:_selectedTheme;
        }
        return Form(
          key: _formKey,
          child: ToggleButtons(
            children: <Widget>[
              Icon(Icons.light_mode, color: widget.theme.colorScheme.onBackground,),
              Icon(Icons.dark_mode, color: widget.theme.colorScheme.onBackground),
              Icon(Icons.chrome_reader_mode, color: widget.theme.colorScheme.onBackground),
            ],
            onPressed: (int index) {
              setState(() { _selectedTheme = index; });
            },
            isSelected: [
              _selectedTheme == 0,
              _selectedTheme == 1,
              _selectedTheme == 2
            ],
          ),
        );
        //     .then((value) {
        //   widget.onChanged("$value");
        // } );
        break;
      case "locale":
        return Form(
            key: _formKey,
            child: DropdownButton<Locale>(
              value: widget.value,
              icon: const Padding(
                padding: EdgeInsets.fromLTRB(3.0, 0, 0, 0),
                child: Icon(Icons.arrow_downward),
              ),
              underline: const SizedBox(height:0),
              elevation: 16,
              items: widget.locales.map<DropdownMenuItem<Locale>>((Locale loc) {
                return DropdownMenuItem<Locale>( value: loc, child: Text(widget.tr(loc.languageCode)) );
              }).toList(),
              onChanged: (Locale? newValue) {
                if(newValue!=null) widget.onChanged(newValue.languageCode);
              },
            )
        );
        break;
    }
    return const SizedBox(height: 0,);
  }

  final TextEditingController controller = TextEditingController();

  Widget _editWidget() {
    controller.text = widget.value.toString();
    switch (widget.type.toLowerCase()) {
      case "email":
        return Form(
          key: _formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.theme.dividerColor),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.theme.colorScheme.secondary),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
            ),
//initialValue: widget.value,
            validator: (value) => validateEmail(value),
          ),
        );
      case "phone_number":
        return Form(
          key: _formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.theme.dividerColor),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.theme.colorScheme.secondary),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
            ),
            //initialValue: widget.value,
            validator: (value) => validatePhoneNumber(value),
          ),
        );
      case "number":
        return Form(
          key: _formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.theme.dividerColor),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.theme.colorScheme.secondary),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
            ),
            //initialValue: widget.value,
            validator: (value) => validateNumber(value),
          ),
        );
      case "text":
        return Form(
          key: _formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.theme.dividerColor),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: widget.theme.colorScheme.secondary),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
            ),
          //initialValue: widget.value,
          ),
        );
      case "theme":
        return Form(
          key: _formKey,
          child: ToggleButtons(
            children: <Widget>[
              Icon(Icons.light_mode, color: widget.theme.colorScheme.onBackground,),
              Icon(Icons.dark_mode, color: widget.theme.colorScheme.onBackground),
              Icon(Icons.chrome_reader_mode, color: widget.theme.colorScheme.onBackground),
            ],
            onPressed: (int index) {
                if(index == 0) {
                  AdaptiveTheme.of(context).setLight();
                }else if(index == 1) {
                  AdaptiveTheme.of(context).setDark();
                }else{
                  AdaptiveTheme.of(context).setSystem();
                }
            },
            isSelected: [
              AdaptiveTheme.of(context).mode.isLight,
              AdaptiveTheme.of(context).mode.isDark,
              AdaptiveTheme.of(context).mode.isSystem
            ],
          ),
        );
        //     .then((value) {
        //   widget.onChanged("$value");
        // } );
        break;
      case "locale":
        return Form(
          key: _formKey,
          child: DropdownButton<Locale>(
            value: widget.value,
            icon: const Padding(
              padding: EdgeInsets.fromLTRB(3.0, 0, 0, 0),
              child: Icon(Icons.arrow_downward),
            ),
            underline: const SizedBox(height:0),
            elevation: 16,
            items: widget.locales.map<DropdownMenuItem<Locale>>((Locale loc) {
              return DropdownMenuItem<Locale>( value: loc, child: Text(widget.tr(loc.languageCode)) );
            }).toList(),
            onChanged: (Locale? newValue) {
              if(newValue!=null) widget.onChanged(newValue.languageCode);
            },
          )
        );
        break;
    }
    return const SizedBox(height: 1);
  }

  String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value))
      return widget.tr('enter_valid', args: [widget.tr("email")]);
    else
      return null;
  }

  String? validatePhoneNumber(String? value) {}
  String? validateNumber(String? value) {int? x = int.tryParse(value??''); if(x==null) return widget.tr("invalid_number");
  else if(x < widget.min || x > widget.max){return widget.tr("enter_number_between", args: [widget.min.toString(), widget.max.toString()]);} }
}
