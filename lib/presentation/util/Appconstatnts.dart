import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppConstants {
  //static const String LIVE_URL = 'http://192.168.0.103:3000/YogaApp/';
    //  static const String LOCAL_URL = 'http://nija.ddns.net:93/NewYogaApp/';
 static const String LOCAL_URL = 'http://192.168.29.121:3000/YogaApp/';
// static const String LOCAL_URL = 'http://192.168.31.13:3000/YogaApp/';
  //  static const String LOCAL_URL = 'http://192.168.31.13:3000/YogaApp/';
  static const String SESSIONTOKEN = 'Token';
  static const String SESSIONLOGGEDIN = "LoggedIn";
  static const String Login = 'getuserlogin';
  static const String enroll = 'getenroll';
  static const String addenroll = 'addenroll';
  static const String getSuperenroll = 'getSuperenroll';
  static const String videos ='getuploadvideo';
  static const String addNewUser ='addNewUser';
  static const String addcoursemaster ='addcoursemaster';
  static const String getcoursemaster = 'getcoursemaster';
  static const String getvideomaster = 'getvideomaster';
  static const String getusermaster = 'getusermaster';
  static const String getupdateuserstatus = 'getupdateuserstatus';
  static const String getupadtevideostatus = 'getupadtevideostatus';
  static const String getupadtecoursestatus = 'getupadtecoursestatus';
  static const String storeEnroll = 'storeEnroll';
  static const String getVideos = 'getVideos';
  static const String addVideoDashboard = 'addVideoDashboard';
  // static const String myscore = 'myscore';
  static const String courseNameWiseReport = 'courseNameWiseReport';
  static const String courseWiseReport = 'courseWiseReport';
  static const String getusermasterreport = 'getusermasterreport';
  static const String getusermasterreportid = 'getusermasterreportid';
  static const String getusermasterreportPage = 'getusermasterreportPage';
  static const String dateWiseReport = 'dateWiseReport';
  static const String monthWiseReport = 'monthWiseReport';
  static const String monthWiseReportuser = 'monthWiseReportuser';
  static const String addmyscore = 'addmyscore';
  static const String addmyvideos = 'addmyvideos';
  
  static List<Color> containerColor = [
    const Color(0xFF1ea4a9),
    const Color(0xFF5697db),
    const Color(0xFFeb3f55),
    const Color(0xFF5B0888),
    const Color(0xFFF39F5A),
    const Color(0xFF618264),
    const Color(0xFF80B300),
    const Color(0xFF00B3E6),
    const Color(0xFF1ea4a9),
    const Color(0xFF5697db),
  ];
  static List<Color> containerLightColor = [
    const Color(0XFFdcf2f2),
    const Color(0xFFdbe8f8),
    const Color(0xFFfae2e2),
    const Color(0xFFfaefdd),
    const Color(0xFFE5CFF7),
    const Color(0xFFB0D9B1),
    const Color(0xFFD5DEBD),
    const Color(0xFFD0E6EC),
    const Color(0XFFdcf2f2),
    const Color(0xFFdbe8f8),
  ];

  static changeyymmddformat(datetime) {
    return DateFormat("yyyy-MM-dd").format(DateTime.parse(datetime));
  }

  static changeddmmyyy(datetime) {
    return DateFormat("dd-MM-yyyy").format(DateTime.parse(datetime));
  }

  static String time12to24Format(String time) {
    DateTime date = DateFormat.jm().parse(time);
    // print(DateFormat("kk:mm:ss").format(date));
    String newTime = DateFormat("kk:mm:ss").format(date);
    print(newTime);
    return newTime;
  }
}
