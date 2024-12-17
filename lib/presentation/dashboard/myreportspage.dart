import 'package:flutter/material.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/coursechartreportpage.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/coursenamereportpage.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/datechartreportpage.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/datewisereportpage.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/monthchartreportpage.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/monthwisereportpoage.dart';

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
                    child: _buildCardWithButton(
                      icon: Image.asset(
                        "assets/images/course.png",
                        height: 36,
                        width: 36,
                      ),
                      label: 'Course Wise Report',
                      onPressed: _navigateToCourseNamePage,
                      buttonColor: const Color(0xFFEAECFB),
                    ),
                  ),
                  Expanded(
                    child: _buildCardWithButton(
                      icon: Image.asset(
                        "assets/images/daycalendar.png",
                        height: 36,
                        width: 36,
                      ),
                      label: 'Day Wise Report',
                      onPressed: _navigateToDateWisePage,
                      buttonColor: const Color(0xFFEAECFB),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: _buildCardWithButton(
                      icon: Image.asset(
                        "assets/images/calendar.png",
                        height: 36,
                        width: 36,
                      ),
                      label: 'Month Wise Report',
                      onPressed: _navigateToMonthWisePage,
                      buttonColor: const Color(0xFFEAECFB),
                    ),
                  ),
                  Expanded(
                    child: _buildCardWithButton(
                      icon: Image.asset(
                        "assets/images/coursechart.png",
                        height: 36,
                        width: 36,
                      ),
                      label: 'Course Wise Chart Report',
                      onPressed: _navigateToCourseNameChartWisePage,
                      buttonColor: const Color(0xFFEAECFB),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: _buildCardWithButton(
                      icon: Image.asset(
                        "assets/images/barchart.png",
                        height: 36,
                        width: 36,
                      ),
                      label: 'Month Wise Chart Report',
                      onPressed: _navigateToMonthChartWisePage,
                      buttonColor: const Color(0xFFEAECFB),
                    ),
                  ),
                  Expanded(
                    child: _buildCardWithButton(
                      icon: Image.asset(
                        "assets/images/piechart.png",
                        height: 36,
                        width: 36,
                      ),
                      label: 'Day Wise Chart Report',
                      onPressed: _navigateToDateChartWisePage,
                      buttonColor: const Color(0xFFEAECFB),
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
      child: SizedBox(
        height: 135, 
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildIconButton(
            icon: icon,
            label: label,
            onPressed: onPressed,
            buttonColor: buttonColor,
          ),
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
