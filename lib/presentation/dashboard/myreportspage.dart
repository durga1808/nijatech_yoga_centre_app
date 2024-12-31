import 'package:flutter/material.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/coursechartreportpage.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/coursenamereportpage.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/datechartreportpage.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/datewisereportpage.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/monthchartreportpage.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/monthwisereportpoage.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';

class MyReportsPage extends StatefulWidget {
  const MyReportsPage({super.key});

  @override
  _MyReportsPageState createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildCircleIconWithLabel(
                      icon: const Icon(
                        Icons.school,
                        size: 24,
                        color: Colors.white,
                      ),
                      label: 'Course Wise Report',
                      onPressed: _navigateToCourseNamePage,
                    ),
                  ),
                  Expanded(
                    child: _buildCircleIconWithLabel(
                      icon: const Icon(
                        Icons.calendar_today,
                        size: 24,
                        color: Colors.white,
                      ),
                      label: 'Day Wise Report',
                      onPressed: _navigateToDateWisePage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: _buildCircleIconWithLabel(
                      icon: const Icon(
                        Icons.calendar_month,
                        size: 24,
                        color: Colors.white,
                      ),
                      label: 'Month Wise Report',
                      onPressed: _navigateToMonthWisePage,
                    ),
                  ),
                  Expanded(
                    child: _buildCircleIconWithLabel(
                      icon: const Icon(
                        Icons.pie_chart,
                        size: 24,
                        color: Colors.white,
                      ),
                      label: 'Course Wise Chart Report',
                      onPressed: _navigateToCourseNameChartWisePage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: _buildCircleIconWithLabel(
                      icon: const Icon(
                        Icons.bar_chart,
                        size: 24,
                        color: Colors.white,
                      ),
                      label: 'Month Wise Chart Report',
                      onPressed: _navigateToMonthChartWisePage,
                    ),
                  ),
                  Expanded(
                    child: _buildCircleIconWithLabel(
                      icon: const Icon(
                        Icons.area_chart,
                        size: 24,
                        color: Colors.white,
                      ),
                      label: 'Day Wise Chart Report',
                      onPressed: _navigateToDateChartWisePage,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
        backgroundColor: buttonColor ?? Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _navigateToCourseNamePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CourseNameReportPage()),
    );
  }

  void _navigateToDateWisePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DateWiseReportPage()),
    );
  }

  void _navigateToMonthWisePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MonthWiseReportPage()),
    );
  }

  void _navigateToMonthChartWisePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MonthChartReportPage()),
    );
  }

  void _navigateToDateChartWisePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DateChartReportPage()),
    );
  }

  void _navigateToCourseNameChartWisePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CourseChartReportPage()),
    );
  }
}
