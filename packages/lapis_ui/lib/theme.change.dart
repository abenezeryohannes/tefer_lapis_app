
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeChange{

  static SystemUiOverlayStyle getSystemUIOverlay(final BuildContext context){

    final bool isLight = AdaptiveTheme.of(context).brightness == Brightness.light;
    final Brightness iconBrightness = isLight? Brightness.dark : Brightness.light;
    final Brightness statusBarBrightness = isLight? Brightness.light : Brightness.dark;
    final Color BackgroundColor = AdaptiveTheme.of(context).theme.scaffoldBackgroundColor;

    return SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: iconBrightness,
        statusBarBrightness: statusBarBrightness,
        systemNavigationBarIconBrightness: iconBrightness,
        systemNavigationBarColor: BackgroundColor
    );
  }
}