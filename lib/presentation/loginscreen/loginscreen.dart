import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/l10n/localization.dart';
import 'package:nijatech_yoga_centre_app/main.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/admindashboardscreen.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/dashboardscreen.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/loginmodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/app_util.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/curveclipper.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/pref.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginModel loginModel = LoginModel();
  bool loading = false;
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  void _changeLanguage(String langCode) {
    Locale newLocale = Locale(langCode);
    MainApp.setLocale(context, newLocale);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.logintitle ?? 'Yoga Center',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
              color: Colors.white,
              onSelected: (String languageCode) async {
                await Prefs.setLanguage("Language", languageCode);
                Locale myLocale =
                    Locale(languageCode, languageCode == 'ta' ? 'IN' : 'US');
                MainApp.setLocale(context, myLocale);
              },
              itemBuilder: (context) => const [
                    PopupMenuItem(value: 'en', child: Text('English')),
                    PopupMenuItem(value: 'ta', child: Text('தமிழ்'))
                  ])
        ],
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _backgroundImage(size),
                      _loginCredentials(size),
                    ],
                  ),
                  _circleButton(size),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      persistentFooterButtons: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              Text(AppLocalizations.of(context)?.poweredBy ?? 'Powered By'),
              Image.asset(
                "assets/images/nijalogo.png",
                height: 80,
                width: 130,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _circleButton(Size size) {
    return Positioned(
      top: size.height * 0.42,
      right: size.width * 0.15,
      child: FloatingActionButton(
        onPressed: () {},
        elevation: 5.0,
        backgroundColor: AppColor.primary,
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 30.0,
        ),
      ),
    );
  }

  Widget _backgroundImage(Size size) {
    return ClipPath(
      clipper: CurveClipper(),
      child: Container(
        height: size.height * 0.55,
        color: AppColor.primary,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 48.0),
          child: Center(
            child: Image(
              image: AssetImage('assets/images/statue.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginCredentials(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)?.pleaseLogIn ?? 'Please Log In',
            style: const TextStyle(fontSize: 24),
          ),
          SizedBox(height: size.height * 0.03),
          _inputField(
              context: context,
              controller: usernamecontroller,
              hintText: AppLocalizations.of(context)?.username ?? 'Username',
              icon: Icons.person),
          SizedBox(height: size.height * 0.04),
          _inputField(
              context: context,
              controller: passwordcontroller,
              hintText: AppLocalizations.of(context)?.password ?? 'Password',
              icon: Icons.lock_outline,
              obscureText: true),
          SizedBox(height: size.height * 0.04),
          _loginButton(context, size),
          SizedBox(height: size.height * 0.03),
        ],
      ),
    );
  }

  Widget _inputField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Material(
      elevation: 10.0,
      color: AppColor.white,
      borderRadius: BorderRadius.circular(30.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          hintText: hintText,
          prefixIcon: Icon(
            icon,
            size: 25.0,
            color: AppColor.black.withOpacity(0.4),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context, Size size) {
    return InkWell(
      onTap: () {
        if (usernamecontroller.text.isEmpty) {
          AppUtils.showSingleDialogPopup(
            context,
            AppLocalizations.of(context)?.enterusername ?? 'enterusername',
            AppLocalizations.of(context)?.Ok ?? 'Ok',
            exitpopup,
          );
        } else if (passwordcontroller.text.isEmpty) {
          AppUtils.showSingleDialogPopup(
            context,
            AppLocalizations.of(context)?.enteruserpassword ?? 'enterpassword',
            AppLocalizations.of(context)?.Ok ?? 'Ok',
            exitpopup,
          );
        } else {
          getlogin();
        }
      },
      child: Material(
        elevation: 10.0,
        shadowColor: AppColor.primary,
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(30.0),
        child: SizedBox(
          width: size.width,
          height: size.width * 0.13,
          child: Center(
            child: Text(
              AppLocalizations.of(context)?.logIn ?? 'login',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void exitpopup() {
    Navigator.of(context).pop();
  }

  void getlogin() async {
    setState(() {
      loading = true;
    });

    try {
      final response = await Apiservice.getlogin(
          usernamecontroller.text, passwordcontroller.text);

      setState(() {
        loading = false;
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          loginModel = LoginModel.fromJson(responseData);
          await addsharedpref(loginModel);
        } else {
          AppUtils.showSingleDialogPopup(
              context, responseData['message'].toString(), "Ok", exitpopup);
        }
      } else {
        AppUtils.showSingleDialogPopup(
            context, "Login Failed! Please try again.", "Ok", exitpopup);
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", exitpopup);
    }
  }

  Future<void> addsharedpref(LoginModel model) async {
    final message = model.message?.first;

    if (message != null) {
      await Prefs.setLoggedIn("IsLoggedIn", true);
      await Prefs.setUserName("UserName", message.username ?? '');
      await Prefs.setID("UserID", message.id?.toInt() ?? 0);
      await Prefs.setName("Name",
          '${message.firstname ?? ''} ${message.middlename ?? ''} ${message.lastname ?? ''}');
      await Prefs.setCenterID("CenterId", message.centerid?.toInt() ?? 0);
      await Prefs.setCenterName("CenterName", message.centername ?? '');
      await Prefs.setMobileNo("MobileNo", message.phoneno ?? '');
      await Prefs.setGender("Gender", message.gender ?? '');
      await Prefs.setSuperUser("SuperUser", message.issuperuser?.toInt() ?? 0);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => message.issuperuser == 1
              ? const AdminDashBoardScreen()
              : const DashboardScreen()));
    }
  }
}
