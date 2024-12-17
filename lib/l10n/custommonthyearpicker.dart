import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';

class CustomMonthYearPickerLocalizations extends MonthYearPickerLocalizations {
  final Locale locale;

  CustomMonthYearPickerLocalizations(this.locale) : super('locale');

  @override
  String get okButtonLabel => locale.languageCode == 'ta' ? 'சரி' : 'OK';

  @override
  String get cancelButtonLabel =>
      locale.languageCode == 'ta' ? 'ரத்து செய்' : 'CANCEL';

  @override
  String get selectYearLabel => locale.languageCode == 'ta'
      ? 'வருடத்தைத் தேர்ந்தெடுக்கவும்'
      : 'Select Year';

  @override
  String get selectMonthYearLabel => locale.languageCode == 'ta'
      ? 'மாதம் மற்றும் வருடத்தைத் தேர்ந்தெடுக்கவும்'
      : 'Select Month & Year';

  @override
  String get helpText => locale.languageCode == 'ta'
      ? 'மாதம் மற்றும் வருடத்தைத் தேர்ந்தெடுக்கவும்'
      : 'Select Month & Year';
}

class CustomMonthYearPickerDelegate
    extends LocalizationsDelegate<MonthYearPickerLocalizations> {
  const CustomMonthYearPickerDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ta'].contains(locale.languageCode);
  }

  @override
  Future<MonthYearPickerLocalizations> load(Locale locale) async {
    return SynchronousFuture(CustomMonthYearPickerLocalizations(locale));
  }

  @override
  bool shouldReload(CustomMonthYearPickerDelegate old) => false;
}

