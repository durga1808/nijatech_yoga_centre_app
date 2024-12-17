import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:nijatech_yoga_centre_app/l10n/custommonthyearpicker.dart';
import 'package:nijatech_yoga_centre_app/l10n/localization.dart';
import 'package:nijatech_yoga_centre_app/presentation/splash.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/pref.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );


  String? languageCode = await Prefs.getLanguage("Language");
  languageCode ??= 'en';

  runApp(MainApp(languageCode : languageCode));
}

class MainApp extends StatefulWidget{
  final String languageCode;

  const MainApp({Key? key, required this.languageCode}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale){
    _MainAppState?  state =context.findAncestorStateOfType<_MainAppState>();
    state?.setLocale(newLocale);
  }
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Locale _locale;

  @override
  void initState(){
    super.initState();
    _locale = Locale(widget.languageCode, widget.languageCode == 'ta' ? 'IN':'US');
}


   void setLocale(Locale newLocale){
    setState(() {
      _locale = newLocale;
    });
   }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yoga App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Assistance',
        primarySwatch: CompanyColors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.white,
         ),
         cardTheme: const CardTheme(
          surfaceTintColor: Colors.white,
          color: Colors.white,
         ),
         ),
        home: const SplashScreen(),
        localizationsDelegates: const [

          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
          AppLocalizations.delegate,
          CustomMonthYearPickerDelegate(),
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ta','IN'),
        ],
        locale: _locale,
        localeResolutionCallback: (locale, supportedLocales){
          for (var supportedLocale in supportedLocales) {
           if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return const Locale('en','US');
        },
    );
  }
  }

class CompanyColors {
  
  CompanyColors._();

  static const int _primaryValue = 0xFF186F65;

  static const MaterialColor black = MaterialColor(
    _primaryValue, 
    <int, Color>{
      50: Color(_primaryValue),
      100: Color(_primaryValue),
      200:Color(_primaryValue),
      300:Color(_primaryValue),
      400:Color(_primaryValue),
      500:Color(_primaryValue),
      600:Color(_primaryValue),
      700:Color(_primaryValue),
      800:Color(_primaryValue),
      900:Color(_primaryValue),
    },
    );
}