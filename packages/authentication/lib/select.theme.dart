import 'package:authentication/auth.dart';
import 'package:flutter/material.dart';
import 'widget/color.selection.icons.dart';
import 'widget/background.dart';

class SelectTheme extends StatefulWidget {
  SelectTheme({Key? key, required this.slideTo, required this.tr,
    required this.onChange, required this.theme, required this.themes}) : super(key: key);
  late ThemeData theme;
  final List<ThemeData> themes;

  final  Function(Slide) slideTo;
  final String Function(String x) tr;
  final void Function(int) onChange;
  @override
  _SelectThemeState createState() => _SelectThemeState();
 
}

class _SelectThemeState extends State<SelectTheme> {
  final BackgroundController _backgroundController = BackgroundController();


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
    
        SizedBox(height: 400, child: _buildColorSelectionIcons()), 
  
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: widget.theme.colorScheme.secondary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 14),
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 3 / 4, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: ()=>{
                  widget.slideTo(Slide.end)
                },
                child: Text(
                  widget.tr("continue"),
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
          ),
        ), 
     
        ],
      ),
    );

    
  }

 
 
 
  Widget _buildColorSelectionIcons() {
    void onTapDownCallback(final ThemeData themeData, final TapDownDetails tapDownDetails) {
      //setState(() { widget.theme = themeData; });
      widget.onChange(widget.themes.indexOf(themeData));
      _backgroundController.doPulse([ themeData.scaffoldBackgroundColor, themeData.backgroundColor ], tapDownDetails.globalPosition); 
    }
    return ColorSelectionIcons(themes: widget.themes, onTapDown: onTapDownCallback);
  }



}
 