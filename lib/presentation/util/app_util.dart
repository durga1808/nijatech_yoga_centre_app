import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';


class 
AppUtils {
  static void hideKeyboard(context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static String capitalize(String value) =>
      value.trim().length > 1 ? value.toUpperCase() : value;

  static void showSnackbar({context, message, backgroundColor}) {
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: message,
          backgroundColor: backgroundColor ?? Colors.red,
        ),
      );
    }
    Timer(const Duration(seconds: 4), () {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }

  // show dialog popup
  static Future showSingleDialogPopup(context, title, buttonname, onPressed) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title.toString(), maxLines: null),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    onPressed();
                  },
                  child: Text(buttonname.toString())),
            ],
          );
        });
  }

  // show confirmation dialog
  static Future showconfirmDialog(
      context, title, yesstring, nostring, onPressedYes, onPressedNo) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            TextButton(onPressed: onPressedYes, child: Text(yesstring)),
            TextButton(onPressed: onPressedNo, child: Text(nostring)),
          ],
        );
      },
    );
  }

  //Text
  static Widget buildHeaderText({final String? text}) {
    return Text(
      text.toString(),
      style:  TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );
  }

  static Widget reporttwoWidget({
    final String? header,
    final String? header1,
    final String? value1,
    final String? header2,
    final String? value2,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        elevation: 3,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  color: AppColor.primary,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  )),
              padding: const EdgeInsets.only(
                  top: 13.0, left: 10.0, bottom: 13.0, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    header.toString(),
                    style:  TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                //textDirection: TextDirection.rtl,),
                columnWidths: const {
                  0: FlexColumnWidth(),
                  1: FlexColumnWidth()
                },
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppUtils.buildNormalText(
                          text: header1.toString(),
                          color: Colors.black,
                          fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppUtils.buildNormalText(
                        text: value1.toString(),
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppUtils.buildNormalText(
                          text: header2.toString(),
                          color: Colors.black,
                          fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppUtils.buildNormalText(
                        text: value2.toString(),
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildNormalText(
      {@required text,
      color,
      double fontSize = 12,
      textAlign,
      fontWeight,
      letterSpacing,
      wordSpacing,
      fontFamily,
      maxLines,
      overflow,
      decoration,
      lineSpacing,
      fontStyle}) {
    return Text(
      text ?? '--',
      textAlign: textAlign ?? TextAlign.left,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
          decoration: decoration ?? TextDecoration.none,
          color: color ?? Colors.black,
          fontSize: fontSize ?? 12,
          fontWeight: fontWeight ?? FontWeight.w400,
          letterSpacing: letterSpacing ?? 0,
          wordSpacing: wordSpacing ?? 0.0,
          height: lineSpacing != null ? lineSpacing + 0.0 : null,
          fontStyle: fontStyle ?? FontStyle.normal),
    );
  }

  static iconWithText(
      {@required icons,
      @required text,
      MaterialColor? iconcolor,
      color,
      double fontSize = 12,
      textAlign,
      fontWeight,
      letterSpacing,
      wordSpacing,
      fontFamily,
      maxLines,
      overflow,
      decoration,
      lineSpacing,
      fontStyle}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icons,
          color: iconcolor ?? Colors.black,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          text ?? '--',
          textAlign: textAlign ?? TextAlign.left,
          maxLines: maxLines,
          overflow: overflow,
          style: TextStyle(
              decoration: decoration ?? TextDecoration.none,
              color: color ?? Colors.black,
              fontSize: fontSize ?? 12,
              fontWeight: fontWeight ?? FontWeight.w400,
              letterSpacing: letterSpacing ?? 0,
              wordSpacing: wordSpacing ?? 0.0,
              height: lineSpacing != null ? lineSpacing + 0.0 : null,
              fontStyle: fontStyle ?? FontStyle.normal),
        )
      ],
    );
  }

  static void showBottomCupertinoDialog(BuildContext context,
      {@required String? title,
      @required btn1function,
      @required btn2function}) async {
    return showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
          title: Text(title.toString()),
          actions: [
            CupertinoActionSheetAction(
                onPressed: btn1function, child: const Text('Camera')),
            CupertinoActionSheetAction(
                onPressed: btn2function, child: const Text('Files'))
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('Cancel'),
          )),
    );
  }

  static pop(context) {
    Navigator.pop(context);
  }
}
