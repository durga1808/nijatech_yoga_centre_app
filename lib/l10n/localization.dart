import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations load(Locale locale) {
    return AppLocalizations(locale);
  }

  String get logintitle =>
      locale.languageCode == 'ta' ? 'யோகா மையம்' : 'Yoga Center';
  String get pleaseLogIn => locale.languageCode == 'ta' ? 'உள்நுழைக' : 'Log In';
  String get username =>
      locale.languageCode == 'ta' ? 'பயனர் பெயர்' : 'Username';
  String get password =>
      locale.languageCode == 'ta' ? 'கடவுச்சொல்' : 'Password';
  String get enterusername => locale.languageCode == 'ta'
      ? 'பயனர் பெயரை உள்ளிடவும்'
      : 'Enter User Name';
  String get enteruserpassword => locale.languageCode == 'ta'
      ? 'பயனர் கடவுச்சொல்லை உள்ளிடவும்'
      : 'Enter User Password';
  String get Ok => locale.languageCode == 'ta' ? 'சரி' : 'Ok';
  String get logIn => locale.languageCode == 'ta' ? 'உள்நுழைக' : 'Log In';
  String get poweredBy =>
      locale.languageCode == 'ta' ? 'மூலம் இயக்கப்படுகிறது' : 'Powered By';
  String get myscoretitle =>
      locale.languageCode == 'ta' ? 'எனது மதிப்பெண்' : 'My Score';
  String get enterremarks =>
      locale.languageCode == 'ta' ? 'ரிமார்க்ஸ்' : 'Enter Remarks';
  String get pleaseentercount => locale.languageCode == 'ta'
      ? 'கவுண்ட் உள்ளிடவும்!'
      : 'Please Enter Count!';
  String get pleasechoosecourse => locale.languageCode == 'ta'
      ? 'கோர்ஸ்தேர்ந்தெடுங்கள்!'
      : 'Please Choose Course!';
  String get course => locale.languageCode == 'ta' ? 'கோர்ஸ்' : 'Course';
  String get count => locale.languageCode == 'ta' ? 'கவுண்ட்' : 'Count';
  String get submit =>
      locale.languageCode == 'ta' ? 'சமர்ப்பிக்கவும்' : 'Submit';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ta'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations.load(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
