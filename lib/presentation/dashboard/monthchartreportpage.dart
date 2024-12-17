import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/simple_month_year_picker.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/mymonthmodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/pref.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:month_year_picker/month_year_picker.dart';


import '../model/chartdata.dart';

class MonthChartReportPage extends StatefulWidget {
  const MonthChartReportPage({Key? key}) : super(key: key);

  @override
  _ChartReportPageState createState() => _ChartReportPageState();
}

class _ChartReportPageState extends State<MonthChartReportPage> {
  String? _selectedMonth;
  String? _selectedYear;
  bool _isLoading = false;
  MyMonthModel model = MyMonthModel();
  List<ChartData> chartData = [];
  List<String> courseNames = [];

  final List<String> years =
      List.generate(10, (index) => (DateTime.now().year - index).toString());


  void _showMonthYearPicker() async {
    final DateTime? pickedDate = await SimpleMonthYearPicker.showMonthYearPickerDialog(
      context: context,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      monthTextStyle: TextStyle(
        fontSize: 16,
      ),
      backgroundColor: Colors.white,
      selectionColor: AppColor.primary, 
      barrierDismissible: true,
    );

  if (pickedDate != null) {
      setState(() {
        _selectedMonth = DateFormat('MMMM').format(pickedDate);
        _selectedYear = pickedDate.year.toString();
      });

      // getlistByYearMonth(_selectedYear!, _selectedMonth!);
    }
  }
  void getlistByYearMonth(String selectedYear, String selectedMonth) async {
    int monthNumber = DateFormat('MMMM').parse(selectedMonth).month;

    var body = {
      "createdBy": Prefs.getID("UserID"),
      "month": monthNumber.toString().padLeft(2, '0'),
      "year": selectedYear,
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Apiservice.getmonthwiselist(jsonEncode(body));

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == true) {
          model = MyMonthModel.fromJson(responseBody);
          _prepareChartData();
        } else {
          setState(() {
            chartData = [];
            courseNames = [];
          });
        }
      } else {
        _showErrorDialog("Error fetching data");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog(e.toString());
    }
  }

  void _prepareChartData() {
    final Map<String, int> courseCountMap = {};
    courseNames.clear();

    if (model.message != null) {
      for (var report in model.message!) {
        final courseName = report.coursename ?? 'Unknown';
        courseCountMap[courseName] = (courseCountMap[courseName] ?? 0) + 1;
      }
    }

    setState(() {
      chartData = courseCountMap.entries
          .map((entry) => ChartData(entry.key, entry.value))
          .toList();
      courseNames = courseCountMap.keys.toList();
    });
  }

// void _prepareChartData() {
//   setState(() {
//     chartData = model.message!
//         .map((report) => ChartData(
//               report.coursename ?? 'Unknown',
//               report.occurance ?? 0,
//             ))
//         .toList();
//   });
// }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = const SizedBox(height: 5);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Month Wise Chart Report'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text("Choose Year and Month", style: TextStyle(fontSize: 15)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _showMonthYearPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedMonth != null && _selectedYear != null
                                ? '$_selectedMonth $_selectedYear'
                                : 'Select Year and Month',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.calendar_today,
                              color: AppColor.primary),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // IconButton(
                //   icon: const Icon(Icons.search),
                //   color: AppColor.primary,
                //   onPressed: () {
                //     if (_selectedMonth != null && _selectedYear != null) {
                //       getlistByYearMonth(_selectedYear!, _selectedMonth!);
                //     } else {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(content: Text("No year or month selected")),
                //       );
                //     }
                //   },
                // ),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Search",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_selectedMonth != null && _selectedYear != null) {
                      getlistByYearMonth(_selectedYear!, _selectedMonth!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("No year or month selected")),
                      );
                    }
                  },
                )
              ],
            ),
            sizedBox,
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      chartData.isNotEmpty
                          ? Container(
                              height: 600,
                              child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(
                                  labelRotation: 90,
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                  title: AxisTitle(text: 'Course Names'),
                                ),
                                primaryYAxis: NumericAxis(
                                  // minimum: 0,
                                  interval: 1,
                                  title: AxisTitle(text: 'Occurrences'),
                                ),
                                tooltipBehavior: TooltipBehavior(
                                  enable: true,
                                  shouldAlwaysShow: true,
                                  //   format: 'point.x: point.y Occurrences',
                                  //   textStyle: TextStyle(
                                  //     color: Colors.white,
                                  //     fontSize: 12,
                                  //   ),
                                ),
                                series: <ChartSeries<ChartData, String>>[
                                  ColumnSeries<ChartData, String>(
                                    dataSource: chartData,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) =>
                                        data.y.toDouble(),
                                    color: AppColor.primary,
                                    dataLabelSettings: DataLabelSettings(
                                      isVisible: true, // Display data labels
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      labelPosition:
                                          ChartDataLabelPosition.inside,
                                      labelAlignment:
                                          ChartDataLabelAlignment.middle,
                                    ),
                                  )
                                ],
                              ))
                          : const Center(child: Text('No reports found.')),
                      const Text(
                        'MonthWise-Chart Data',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      chartData.isNotEmpty
                          ? SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Table(
                                border: TableBorder.all(color: Colors.grey),
                                columnWidths: const {
                                  0: FlexColumnWidth(3),
                                  1: FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(
                                    decoration: const BoxDecoration(
                                        color: AppColor.primary),
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'Course Name',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'No.Of.Occurance',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ...chartData.map((data) => TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(data.x),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(data.y.toString()),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            )
                          : const Center(child: Text('No data available')),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
