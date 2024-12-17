import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/admindashboardscreen.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/dashboardscreen.dart';
import 'package:nijatech_yoga_centre_app/presentation/loginscreen/loginscreen.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/pref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getcheckedLoggin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: AppColor.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.zero,
          border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
        ),
        child:  Stack(
          alignment: Alignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/statue.png"),
              //height: 100,
              fit: BoxFit.fill,
            ),
            Align(
              alignment: Alignment(0.0, 1.0),
              child: Text(
                "",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 22,
                  color: Color(0xffffffff),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getcheckedLoggin() {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    (Prefs.getLoggedIn("IsLoggedIn") == null ||
                            Prefs.getLoggedIn("IsLoggedIn") == false)
                        ? const LoginScreen()
                        : Prefs.getSupeUser("SuperUser")== 1 ? AdminDashBoardScreen():  DashboardScreen())));
  }
}
