import 'package:flutter/material.dart';

import '../widgets/theme/background.dart';
import '../widgets/theme/color.selection.icons.dart';

class SelectThemePage extends StatefulWidget {
  SelectThemePage({Key? key, required this.tr, required this.onBack,
    required this.onChange, required this.theme, required this.themes}) : super(key: key);
  late ThemeData theme;
  final List<ThemeData> themes;

  final String Function(String x) tr;
  final void Function(int) onChange;
  final void Function() onBack;
  @override
  _SelectThemePageState createState() => _SelectThemePageState();

}

class _SelectThemePageState extends State<SelectThemePage> {

  late BackgroundController _backgroundController;

  @override
  void initState() {
    _backgroundController = BackgroundController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        controller: _backgroundController,
        initialColor: [widget.theme.scaffoldBackgroundColor, widget.theme.backgroundColor],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Column(
              children:  [
                const SizedBox(height: 160),
                Center(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Text(widget.tr("select_theme"),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        )),
                  ),
                ),

                Center(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                    child: Text(widget.tr("can_be_changed_later_on_setting"),
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        )),
                  ),
                ),
              ],
            ),

           // SizedBox(height: 400, child: _buildColorSelectionIcons()),

            // Padding(
            //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            //   child: Center(
            //     child: ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           primary: widget.theme.colorScheme.secondary,
            //           padding: const EdgeInsets.symmetric(
            //               horizontal: 30, vertical: 14),
            //           minimumSize:
            //           Size(MediaQuery.of(context).size.width * 3 / 4, 40),
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(20)),
            //         ),
            //         onPressed: ()=>{Navigator.pop(context, _index) },
            //         child: Text(
            //           widget.tr("continue"),
            //           style: const TextStyle(
            //               fontSize: 18,
            //               color: Colors.black,
            //               fontWeight: FontWeight.bold),
            //         )),
            //   ),
            // ),

          ],
        ),
      );
  }



  int _index = 0;

  Widget _buildColorSelectionIcons() {
    void onTapDownCallback(final ThemeData themeData, final TapDownDetails tapDownDetails) {
      //setState(() { widget.theme = themeData; });
      _index = widget.themes.indexOf(themeData);
      widget.onChange(_index);
      _backgroundController.doPulse([ themeData.scaffoldBackgroundColor, themeData.backgroundColor ],
          tapDownDetails.globalPosition);
    }
    return ColorSelectionIcons(themes: widget.themes, onTapDown: onTapDownCallback);
  }



}
