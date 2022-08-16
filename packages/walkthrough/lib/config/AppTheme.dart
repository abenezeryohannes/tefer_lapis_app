import 'package:flutter/cupertino.dart';

import 'pelete.dart';

class AppTheme{

  static TextStyle titleTextStyle = TextStyle( fontSize: 20, color: Pelete.titleColor, fontFamily: Pelete.fontName, fontWeight: FontWeight.bold, letterSpacing: -0.5 );
  static TextStyle descriptionTextStyle = TextStyle( fontSize: 16, color: Pelete.descriptionColor, fontFamily: Pelete.fontName, letterSpacing: -0.5 );
  static TextStyle backTextStyle = TextStyle( fontSize: 20, color: Pelete.backColor, fontFamily: Pelete.fontName, fontWeight: FontWeight.w500);
  static TextStyle nextTextStyle =  TextStyle( fontSize: 20, color: Pelete.nextColor, fontFamily: Pelete.fontName, fontWeight: FontWeight.w500);

}