import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/alluserwisereport.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/coursewisereport.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/monthwisereport.dart';


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
                  child: _buildCardWithButton(
                    icon: Image.asset(
                      "assets/images/course.png",
                      height: 36,
                      width: 36,
                    ),
                    label: 'Course Report',
                    onPressed: () => _navigateToCourseNamePage(),
                    buttonColor: const Color(0xFFEAECFB),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: _buildCardWithButton(
                    icon: Image.asset(
                      "assets/images/calendar.png",
                      height: 36,
                      width: 36,
                    ),
                    label: 'Month Report',
                    onPressed: () => _NavigateToMonthWiseReport(),
                    buttonColor: const Color(0xFFEAECFB),
                  ),
                ),
                   const SizedBox(width: 5),
                Expanded(
                  child: _buildCardWithButton(
                    icon: Image.asset(
                      "assets/images/usermaster.png",
                      height: 36,
                      width: 36,
                    ),
                    label: 'User Reports',
                    onPressed: () => _NavigateAllUserWiseReport(),
                    buttonColor: const Color(0xFFEAECFB),
                  ),
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
          padding:const EdgeInsets.all(8.0),
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
          Text(label),
        ],
      ),
    );
  }

  void _navigateToCourseNamePage(){
    Navigator.push(context, 
    MaterialPageRoute(builder: (context) => CourseWiseReport(),
    ),
    );
  }
   void _NavigateToMonthWiseReport() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const MonthWiseReport(),
    ),
    );
   }
      void _NavigateAllUserWiseReport() {
    Navigator.push(context, MaterialPageRoute(builder: (context) =>  AllUserWiseReport(),
    ),
    );
   }
}
