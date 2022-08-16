import 'dart:convert';
import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:authentication/auth.dart';
import 'package:domain/controllers/user.request.dart';
import 'package:domain/models/current.user.model.dart';
import 'package:domain/models/user.model.dart';
import 'package:domain/shared_preference/user.sp.dart';
import 'package:domain/models/wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_persistent_keyboard_height/flutter_persistent_keyboard_height.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/FirebaseNotification.dart';
import 'package:myapp/config/config.dart';
import 'package:myapp/config/themes/app.theme.data.dark.dart';
import 'package:myapp/config/themes/app.theme.data.dart';
import 'package:provider/provider.dart';
import 'package:walkthrough/walkthrough.dart';
import 'domain/shared_preference/setting.sp.dart';
import '../../config/themes/app.theme.dart'; 
//import 'firebase_options.dart';
import 'firebase_options.dart';
import 'pages/main.page.dart';
import 'package:map/map.screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';




    main() async {

      WidgetsFlutterBinding.ensureInitialized();

      await EasyLocalization.ensureInitialized();

      await Auth.INITIALIZEFIREBASE();
      FirebaseNotification.initState();


      //load theme from sharedPreference
      SettingSP settingSp = SettingSP();
      await settingSp.loadPreference();
      AppTheme appTheme = AppTheme.Fresh();//await settingSp.getTheme();//
      await appTheme.loadThemeDatas();

      //load theme from sharedPreference
      UserSP userSp = UserSP();
      await userSp.loadPreference();
      UserModel user = await userSp.getUser();
      CurrentUserModel currentUser = CurrentUserModel(User: user);

      ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
      SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
      EasyLocalization.logger.enableBuildModes = [];


      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
      );


      WidgetsFlutterBinding.ensureInitialized();
      final AdaptiveThemeMode? savedThemeMode = await AdaptiveTheme.getThemeMode();
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      runApp(
          EasyLocalization(
            supportedLocales: const [ Locale('en', 'US'), Locale('am', 'ET') ],
            path: 'assets/locals',
            fallbackLocale: const Locale('en', 'US'),
            saveLocale: false,
            child: MultiProvider(
                providers: [
                  ChangeNotifierProvider<AppTheme>( create: ( context ) => appTheme ),
                  ChangeNotifierProvider<CurrentUserModel>( create: ( context ) => currentUser ),
                ],
                child: MyApp(savedThemeMode: savedThemeMode ),
              ),
            ),
        );
      FlutterNativeSplash.remove();
    }


class MyApp extends StatelessWidget {

  MyApp({ Key? key, this.savedThemeMode}) : super(key: key);

  final AdaptiveThemeMode? savedThemeMode;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // static String Function(String, List<String> args) Notificationtr = tr;

  @override
  Widget build(BuildContext context) {
    // sets theme mode to dark
    return AdaptiveTheme(
      light: AppThemeData.Fresh().getThemeData(),
      dark: AppThemeDataDark.Fresh().getThemeData(),
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) {
      return  MaterialApp(
                title: tr("lapis"),
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                theme: theme, darkTheme: darkTheme,
                home: const MainPage()
      );},
    );

  }

}



