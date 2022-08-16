





import 'dart:io';

import 'package:domain/controllers/driver.request.dart';
import 'package:domain/controllers/user.request.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/models/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapis_ui/fragments/info.fragment.dart';
import 'package:util/RequestHandler.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment(
      {Key? key,
      required this.user,
      required this.theme,
      required this.onChange,
      required this.onThemeChange,
      required this.locales,
      required this.themes,
      required this.tr})
      : super(key: key);

  final UserModel user;
  final ThemeData theme;
  final List<Locale> locales;
  final List<ThemeData> themes;
  final Function(UserModel) onChange;
  final Function(int) onThemeChange;
  final String Function(String, {List<String> args}) tr;

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {

  int selectedTab = 0;

  PageController controller = PageController(initialPage: 0);

  late Future<Wrapper> stat;

  @override
  void initState() { stat = DriverRequest(widget.user).stat(); super.initState(); }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: SizedBox(
                            height: 90,
                            width: 85,
                            child: Stack(
                              fit: StackFit.loose,
                              children: [
                                CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: NetworkImage(
                                      "${RequestHandler.baseImageUrl}${widget.user.avatar}"),
                                  backgroundColor: Colors.transparent,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: () { _getImage(); },
                                    child: Icon(Icons.edit, color: widget.theme.colorScheme.onBackground,
                                      size: 24,),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text(widget.user.full_name ?? "",
                              style: widget.theme.textTheme.bodyText1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                              items: <String>[
                                widget.tr("donor"),
                                widget.tr("driver")
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value,
                                    style: widget.theme.textTheme.bodyText2));
                              }).toList(),

                              icon: Padding(
                                padding: const EdgeInsets.fromLTRB(3.0, 0, 0, 0),
                                child: Icon(Icons.arrow_downward, color: widget.theme.dividerColor,),
                              ),

                              value: widget.user.getToken().type ?? "donor",
                              underline: const SizedBox(height: 0),
                              onChanged: (val) {
                                UserModel temp = widget.user;
                                temp.getToken().type = val;
                                widget.onChange(temp);
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
                                    if(snapshot.data!=null&& snapshot.data?.data!=null)Text(
                                      '${snapshot.data?.data['trips']??0}',
                                      style: widget.theme.textTheme.bodyText1,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.tr("trips"),
                                      style: TextStyle(
                                          color: widget.theme.colorScheme.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 60),
                                    if(snapshot.data!=null&& snapshot.data?.data!=null)Text(
                                      '${snapshot.data?.data['delivered_items']??0}',
                                      style: widget.theme.textTheme.bodyText1,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.tr("delivered_items"),
                                      style: TextStyle(
                                          color: widget.theme.colorScheme.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if(snapshot.data!=null&& snapshot.data?.data!=null)Text(
                                      '${snapshot.data?.data['traveled']??0}',
                                      style: widget.theme.textTheme.bodyText1,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.tr("traveled"),
                                      style: TextStyle(
                                          color: widget.theme.colorScheme.secondary,
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
                              style: widget.theme.textTheme.bodyText1,
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
              //           theme: widget.theme,
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


              Padding(
                padding: const EdgeInsets.symmetric( vertical: 16 ),
                child: InfoFragment(onChanged: (val) async{await _editUser(val); }, themes: widget.themes,
                  onThemeChanged: (index){widget.onThemeChange(index);},
                  theme: widget.theme, tr: widget.tr, user: widget.user, locales: widget.locales,),
              ),


            ],
          ),
    );
  }

  Future<bool> _editUser(UserModel user)  async {
    // print("before update: ${user}");
    Wrapper wrapper = await UserRequest(widget.user).editUser(user: user);
    if (wrapper.success ?? false) {
      await widget.onChange(wrapper.data);
      // print("after update: ${user}");
    }
    // print("onchange: $wrapper");
    return true;
  }

  Future _getImage() async {
    File _image;
    var imagePicker = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(imagePicker!=null){
      _image = File(imagePicker.path);
      UserModel? user = await UserRequest(widget.user).uploadProfileImage(_image);
      if(user!=null) {
        widget.onChange(user);
      }
    }
    // _image = _pickedFile.path.;
  }

}
