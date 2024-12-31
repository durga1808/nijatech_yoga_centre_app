import 'package:flutter/material.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/master.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/reports.dart';
import 'package:nijatech_yoga_centre_app/presentation/loginscreen/loginscreen.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/pref.dart';

class AdminDashBoardScreen extends StatefulWidget {
  const AdminDashBoardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<AdminDashBoardScreen> {
  DateTime? currentBackPressTime;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          const snackBar =
              SnackBar(content: Text('Press again to exit the app'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 30),
                            title: Text(
                              Prefs.getName("Name").toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(color: Colors.white),
                            ),
                            subtitle: Text(
                              'Yoga Center',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.white54),
                            ),
                            trailing: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                Prefs.getGender("Gender")
                                            .toString()
                                            .toUpperCase() ==
                                        "FEMALE"
                                    ? 'assets/icons/female.png'
                                    : 'assets/icons/male.png',
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDashboardOption(
                            icon:
                                const AssetImage('assets/icons/mastercard.png'),
                            label: 'Master',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Master()),
                              );
                            },
                          ),
                          _buildDashboardOption(
                            icon: const AssetImage(
                                'assets/icons/Group 34082.png'),
                            label: 'Reports',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Reports()),
                              );
                            },
                          ),
                          _buildDashboardOption(
                            icon: Icons.logout,
                            label: 'Log Out',
                            onTap: () {
                              Prefs.setLoggedIn("IsLoggedIn", false);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDashboardOption({
    required dynamic icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColor.primary,
            child: icon is AssetImage
                ? ImageIcon(icon, color: Colors.white, size: 30)
                : Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
