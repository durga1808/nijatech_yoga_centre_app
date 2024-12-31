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
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';

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
                  child: _buildCircleIconWithLabel(
                    icon: const Icon(
                      Icons.person,
                      size: 24,
                      color: Colors.white,
                    ),
                    label: 'User Master',
                    onPressed: _navigateToUserMasterPage,
                  ),
                ),
                Expanded(
                  child: _buildCircleIconWithLabel(
                    icon: const Icon(
                      Icons.school,
                      size: 24,
                      color: Colors.white,
                    ),
                    label: 'Course Master',
                    onPressed: _navigateToCourceMasterPage,
                  ),
                ),
                Expanded(
                  child: _buildCircleIconWithLabel(
                    icon: const Icon(
                      Icons.video_library,
                      size: 24,
                      color: Colors.white,
                    ),
                    label: 'Video Master',
                    onPressed: _navigateToVideoMasterPage,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIconWithLabel({
    required Widget icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: AppColor.primary,
            radius: 28,
            child: icon,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
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
