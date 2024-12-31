import 'package:flutter/material.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/alluserwisereport.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/coursewisereport.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/monthwisereport.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildCircleIconWithLabel(
                    icon: const Icon(
                      Icons.school,
                      size: 24,
                      color: Colors.white,
                    ),
                    label: 'Course Report',
                    onPressed: _navigateToCourseNamePage,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: _buildCircleIconWithLabel(
                    icon: const Icon(
                      Icons.calendar_month,
                      size: 24,
                      color: Colors.white,
                    ),
                    label: 'Month Report',
                    onPressed: _navigateToMonthWiseReport,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: _buildCircleIconWithLabel(
                    icon: const Icon(
                      Icons.person,
                      size: 24,
                      color: Colors.white,
                    ),
                    label: 'User Reports',
                    onPressed: _navigateToAllUserWiseReport,
                  ),
                ),
              ],
            )
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

  void _navigateToCourseNamePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseWiseReport(),
      ),
    );
  }

  void _navigateToMonthWiseReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MonthWiseReport(),
      ),
    );
  }

  void _navigateToAllUserWiseReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllUserWiseReport(),
      ),
    );
  }
}
