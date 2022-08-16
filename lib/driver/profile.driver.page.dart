import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:domain/controllers/user.request.dart';
import 'package:domain/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lapis_ui/fragments/driver/profile.fragment.dart';
import 'package:lapis_ui/theme.change.dart';
import 'package:lapis_ui/widgets/loading.bar.dart';
import 'package:myapp/config/themes/app.theme.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class ProfileDriverPage extends StatefulWidget {
  const ProfileDriverPage(
      {Key? key,
        required this.saveUser,
        required this.onThemeChange,
        required this.user,
        required this.theme,
        required this.themes,
        required this.locales,
        required this.tr})
      : super(key: key);

  final UserModel user;
  final ThemeData theme;
  final List<ThemeData> themes;
  final List<Locale> locales;
  final String Function(String, {List<String> args}) tr;
  final Function(UserModel newUser) saveUser;
  final void Function(int index) onThemeChange;

  @override
  State<ProfileDriverPage> createState() => _ProfileDriverPageState();
}

class _ProfileDriverPageState extends State<ProfileDriverPage> {

  bool loading = false;
  late UserModel user;
  late BuildContext _context;
  late ThemeData theme;

  @override
  void initState() {
    user = widget.user;
    theme = widget.theme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = AdaptiveTheme.of(context).theme;
    //print("printing this: ${RequestHandler.baseImageUrl}${user}");
    _context = context;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ThemeChange.getSystemUIOverlay(context),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            icon: const Icon(Icons.arrow_back),
                            color: theme.colorScheme.onBackground,
                            onPressed: () {
                              Navigator.maybePop(context);
                            }),
                        const SizedBox(width: 5),
                        Text(widget.tr(widget.tr("your_profile")),
                            style: theme.textTheme.bodyText1)
                      ],
                    ),

                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        // value: dropdownValue,
                        icon: Icon(Icons.more_vert, color: theme.colorScheme.onBackground,),
                        elevation: 16,
                        style: TextStyle(color: theme.colorScheme.onBackground,),
                        underline: Container(
                          height: 0,
                          color: theme.colorScheme.onBackground,
                        ),
                        onChanged: (String? newValue) async{
                          setState(() { loading = true; });
                          try { await UserRequest(widget.user).logOutUser(); }
                          finally { setState(() { loading = false; }); }
                          await widget.saveUser(UserModel.fresh());
                          if(Navigator.canPop(context)) Navigator.pop(context);
                        },

                        items: <String>['logout']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Icon(Icons.logout, color: theme.colorScheme.onBackground),
                                const SizedBox(width: 5,),
                                Text(value, style: theme.textTheme.bodyText2,),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if(loading) const LoadingBar( ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Row(
              //         children: [
              //           // IconButton(
              //           //     icon: const Icon(Icons.cancel),
              //           //     color: widget.theme.colorScheme.onBackground,
              //           //     onPressed: () {
              //           //       Navigator.maybePop(context);
              //           //     }),
              //           const SizedBox(width: 5),
              //           Text(widget.tr(widget.tr("your_profile")),
              //               style: widget.theme.textTheme.bodyText1)
              //         ],
              //       ),
              //
              //       DropdownButtonHideUnderline(
              //         child: DropdownButton<String>(
              //           // value: dropdownValue,
              //           icon: Icon(Icons.more_vert, color: widget.theme.colorScheme.onBackground,),
              //           elevation: 16,
              //           style: TextStyle(color: widget.theme.colorScheme.onBackground,),
              //           underline: Container(
              //             height: 0,
              //             color: widget.theme.colorScheme.onBackground,
              //           ),
              //           onChanged: (String? newValue) async{
              //             setState(() { loading = true; });
              //             try { await UserRequest(widget.user).logOutUser(); }
              //             finally { setState(() { loading = false; }); }
              //             await widget.saveUser(UserModel.fresh());
              //             if(Navigator.canPop(context)) Navigator.pop(context);
              //           },
              //
              //           items: <String>['logout']
              //               .map<DropdownMenuItem<String>>((String value) {
              //             return DropdownMenuItem<String>(
              //               value: value,
              //               child: Row(
              //                 children: [
              //                   Icon(Icons.logout, color: widget.theme.colorScheme.onBackground),
              //                   const SizedBox(width: 5,),
              //                   Text(value, style: widget.theme.textTheme.bodyText2,),
              //                 ],
              //               )
              //             );
              //           }).toList(),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              const SizedBox(height: 0,),
              ProfileFragment(
                onChange: (newUser) async {
                  setState(() { loading = true; });
                  try {
                    await widget.saveUser(newUser);
                  }finally{ setState(() { loading = false; });  }
                  },
                  theme: theme, tr: widget.tr, user: widget.user,
                  themes: widget.themes, locales: widget.locales, onThemeChange: (index ) { widget.onThemeChange(index); },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
