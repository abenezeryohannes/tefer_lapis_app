import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dio/dio.dart';
import 'package:domain/controllers/donor.request.dart';
import 'package:domain/controllers/user.request.dart';
import 'package:domain/models/token.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapis_ui/fragments/donations.list.fragment.dart';
import 'package:lapis_ui/fragments/info.fragment.dart';
import 'package:lapis_ui/widgets/error.handler.ui.dart';
import 'package:lapis_ui/widgets/loading.bar.dart';
import 'package:lapis_ui/widgets/tab.dart';
import 'package:util/RequestHandler.dart';
import 'package:util/Utility.dart';

import '../theme.change.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {Key? key,
      required this.user,
      required this.theme,
      required this.onChange,
      required this.onThemeChange,
      required this.themes,
      required this.locales,
      required this.tr})
      : super(key: key);

  final UserModel user;
  final ThemeData theme;
  final List<ThemeData> themes;
  final List<Locale> locales;
  final Function(UserModel) onChange;
  final Function(int) onThemeChange;
  final String Function(String, {List<String> args}) tr;

  @override
  State<ProfilePage> createState() => _ProfilePageState();

  
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedTab = 0;
  PageController controller = PageController(initialPage: 0);
  late Future<Wrapper> stat;
  late UserModel user;
  late BuildContext _context;
  bool loading = false;
  late ThemeData theme;

  @override
  void initState() {
    stat = DonorRequest(widget.user).stat();
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
                          await widget.onChange(UserModel.fresh());
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
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if(loading) const LoadingBar( ),
              Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Stack(
                              fit: StackFit.loose,
                              children: [
                                CircleAvatar(
                                  radius: 80.0,
                                  backgroundImage: NetworkImage(
                                      "${RequestHandler.baseImageUrl}${user.avatar}"),
                                  backgroundColor: Colors.transparent,
                                ),
                                Align(
                                  alignment: const Alignment(0.8, 1.1),
                                  child: InkWell(
                                    onTap: () { _getImage(); },
                                    child: Icon(Icons.edit, color: theme.colorScheme.onBackground, size: 24,),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text((user.full_name ?? "").toUpperCase(),
                              style: theme.textTheme.bodyText2),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                              icon: Padding(
                                padding: const EdgeInsets.fromLTRB(3.0, 0, 0, 0),
                                child: Icon(Icons.arrow_downward, size: 14, color: theme.dividerColor,),
                              ),

                              items: <String>[
                                widget.tr("donor"),
                                widget.tr("driver")
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value, style: theme.textTheme.bodyText2,));
                              }).toList(),
                              value: widget.tr(user.getToken().type ?? "donor"),
                              underline: const SizedBox(height: 0),
                              onChanged: (val) async{
                                UserModel temp = user;
                                if(temp.Token!=null) {
                                  temp.Token!.type = val;
                                }
                                try {
                                  setState(() { loading = true; });
                                  //temp.Token = TokenModel.
                                  //fresh(token:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjo1MSwiaWF0IjoxNjU3MDM0MTAyfQ.tefztGAmdLfe-e-54rd1qRSTIC_T2QD4D05YQFNnCcU",type:val);
                                  Wrapper wrap = await UserRequest(widget.user)
                                      .editUser(user: temp);
                                  if (wrap.success ?? false ||
                                      (wrap.message == null &&
                                          wrap.data != null)) {
                                    await widget.onChange(wrap.data);
                                    setState(() {
                                      user = wrap.data;
                                    });
                                    if(Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                  }
                                }on DioError catch(e){
                                  ErrorHandlerUi().showErrorDialog(context: context,
                                      title: "error",
                                      description:  Utility.formatError(e, tr: widget.tr),
                                      theme: theme,tr: widget.tr);
                                }finally{
                                  setState(() { loading = false; });
                                }
                                //print("temp: ${temp.toString()}");
                                // Navigator.maybePop(context);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  FutureBuilder<Wrapper>(
                      future: stat,
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(24, 140, 24, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if(snapshot.data!=null&& snapshot.data!.data!=null)Text(
                                      '${snapshot.data?.data.gave_away}',
                                      style: theme.textTheme.bodyText1,
                                    )else Text('0', style: theme.textTheme.bodyText1),
                                    const SizedBox(height: 3),
                                    Text(
                                      widget.tr("give_away"),
                                      style: TextStyle(
                                          color: theme.colorScheme.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 60),
                                    if(snapshot.data!=null&& snapshot.data!.data!=null) Text(
                                      '${snapshot.data?.data.donated}',
                                      style: theme.textTheme.bodyText1,
                                    )else Text('0', style: theme.textTheme.bodyText1),
                                    const SizedBox(height: 3),
                                    Text(
                                      widget.tr("donated"),
                                      style: TextStyle(
                                          color: theme.colorScheme.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if(snapshot.data!=null&& snapshot.data!.data!=null) Text(
                                      '${snapshot.data?.data.delivered}',
                                      style: theme.textTheme.bodyText1,
                                    )else Text('0', style: theme.textTheme.bodyText1),
                                    const SizedBox(height: 3),
                                    Text(
                                      widget.tr("delivered"),
                                      style: TextStyle(
                                          color: theme.colorScheme.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              '${snapshot.error}',
                              style: theme.textTheme.bodyText1,
                            ),
                          );
                        }
                        // By default, show a loading spinner.
                        return const Center(child: Center(child: CircularProgressIndicator()));
                      }
                  )
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       MyTab(
              //           theme: theme,
              //           items: [
              //             TabItem(name: widget.tr('personal_info')),
              //             TabItem(name: widget.tr('donations')),
              //           ],
              //           selected: selectedTab,
              //           onChange: (index) => setState(() {
              //                 controller.jumpToPage(index);
              //                 selectedTab = index;
              //               })),
              //     ],
              //   ),
              // ),

      InfoFragment(onChanged: (val) async{ _editUser(val); },
                  theme: theme, tr: widget.tr, user: user,
                  themes: widget.themes, locales: widget.locales,
                  onThemeChanged: (index) {
                  widget.onThemeChange(index);
                  },),
              // Flexible(
              //   child: PageView(
              //       controller: controller,
              //       physics: const NeverScrollableScrollPhysics(),
              //       onPageChanged: (index) { setState(() {selectedTab = index; }); },
              //       scrollDirection: Axis.horizontal,
              //       children: [
              //         InfoFragment(onChanged: (val) async{ _editUser(val); },
              //           theme: theme, tr: widget.tr, user: user,
              //           themes: widget.themes, locales: widget.locales,
              //           onThemeChanged: (index) {
              //           widget.onThemeChange(index);
              //           },),
              //
              //         //const SizedBox(height: 10,)
              //         Column(
              //           children: [
              //             DonationListFragment(theme: theme,user: user, tr: widget.tr, onEnd: () {  },),
              //           ],
              //         )
              //       ]
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _editUser(UserModel user)  async {
    // print("before update: ${user}");
    setState(() { loading = true; });
    try{
      Wrapper wrapper = await UserRequest(user).editUser(user: user);
      if (wrapper.success ?? false) {
        await widget.onChange(wrapper.data);
        setState(() { user = wrapper.data; });
        // print("after update: ${userModel}");
      }
    }on DioError catch(e){
      ErrorHandlerUi().showErrorDialog(context: context,
          title: "error",
          description:  Utility.formatError(e, tr: widget.tr),
          theme: theme,tr: widget.tr);
      // ScaffoldMessenger.of(_context).showSnackBar(
      //     SnackBar( content: Text(e.toString(),
      //         style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      //     ),
      //     backgroundColor: theme.cardColor,)
      // );
    }finally{
      setState(() { loading = false; });
    }

    // print("onchange: $wrapper");
    return true;
  }

  Future _getImage() async {

    File _image;
    var imagePicker = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(imagePicker!=null){
      _image = File(imagePicker.path);
      try {
        setState(() { loading = true; });
        UserModel? userx = await UserRequest(user).uploadProfileImage(
            _image);
        if (userx != null) {
          setState(() { user = userx; });
          await widget.onChange(userx);
        }
      } on DioError catch(e){
        ErrorHandlerUi().showErrorDialog(context: context,
            title: "error",
            description:  Utility.formatError(e, tr: widget.tr),
            theme: theme,tr: widget.tr);
      }finally{
        setState(() { loading = false; });
      }
    }
    // _image = _pickedFile.path.;
  }
  
}


