import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/courcemaster.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/usermaster.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/videomaster.dart';

class Master extends StatefulWidget {
  @override
  _MasterState createState() => _MasterState();
}

class _MasterState extends State<Master> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildCardWithButton(
                      icon: Image.asset(
                        "assets/images/useraccount.png",
                        height: 36,
                        width: 36,
                      ),
                      label: 'User Master',
                      onPressed: () => _navigateToUserMasterPage(),
                      buttonColor: const Color(0xFFEAECFB)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildCardWithButton(
                      icon: Image.asset(
                        "assets/images/coursemaster.png",
                        height: 36,
                        width: 36,
                      ),
                      label: 'Course Master',
                      onPressed: () => _navigateToCourceMasterPage(),
                      buttonColor: const Color(0xFFEAECFB)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildCardWithButton(
                      icon: Image.asset(
                        "assets/images/videomaster.png",
                        height: 36,
                        width: 36,
                      ),
                      label: 'Video Master',
                      onPressed: () => _navigateToVideoMasterPage(),
                      buttonColor: const Color(0xFFEAECFB)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCardWithButton({
    required Widget icon,
    required String label,
    required VoidCallback onPressed,
    Color? buttonColor,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildIconButton(
          icon: icon,
          label: label,
          onPressed: onPressed,
          buttonColor: buttonColor,
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required Widget icon,
    required String label,
    required VoidCallback onPressed,
    Color? buttonColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToUserMasterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserMaster(),
      ),
    );
  }

  void _navigateToCourceMasterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseMaster(),
      ),
    );
  }

  void _navigateToVideoMasterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoMaster(),
      ),
    );
  }
}
