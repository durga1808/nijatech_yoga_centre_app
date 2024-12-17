import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/mydatemodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/app_util.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/pref.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/chartdata.dart';

class DateChartReportPage extends StatefulWidget {
  const DateChartReportPage({Key? key}) : super(key: key);

  @override
  _DateWiseReportPageState createState() => _DateWiseReportPageState();
}

class _DateWiseReportPageState extends State<DateChartReportPage> {
  String? _selectedDate;
  bool _isLoading = false;
  bool _dateSelected = false;
  String altercourseid = "";
  MyDateModel model = MyDateModel();
  List<ChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        _dateSelected = true;
      });
    }
  }

  void getdatewiselist(String courseName) async {
    var body = {
      "createdBy": Prefs.getID("UserID"),
      "date": _selectedDate,
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Apiservice.getdatewiselist(body);
      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 &&
          jsonDecode(response.body)['status'] == true) {
        model = MyDateModel.fromJson(jsonDecode(response.body));
        _prepareChartData();
      } else {
        model.message = [];
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            "No reports found",
          )),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", exitpopup);
    }
  }

  void _prepareChartData() {
    setState(() {
      chartData = model.message!
          .map((report) => ChartData(
                report.coursename ?? 'Unknown',
                report.occurance ?? 0,
              ))
          .toList();
    });
  }

  // void _prepareChartData() {
  //   final Map<String, int> courseCountMap = {};

  //   if (model.message != null) {
  //     for (var report in model.message!) {
  //       final courseName = report.coursename ?? 'Unknown';
  //       courseCountMap[courseName] = (courseCountMap[courseName] ?? 0) + 1;
  //     }
  //   }

  //   setState(() {
  //     chartData = courseCountMap.entries
  //         .map((entry) => ChartData(entry.key, entry.value))
  //         .toList();
  //   });
  // }

  void exitpopup() {
    AppUtils.pop(context);
  }

  void refresh() {
    AppUtils.pop(context);
    AppUtils.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day Wise Chart Report'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text("Choose Date", style: TextStyle(fontSize: 15)),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedDate ?? 'Select Date',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const Icon(Icons.calendar_today,
                                      color: AppColor.primary),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
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
                            if (_selectedDate != null) {
                              getdatewiselist(_selectedDate!);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("No date selected")),
                              );
                            }
                          },
                        )

                        // IconButton(
                        //   icon: const Icon(Icons.search),
                        //   onPressed: () {
                        //     if (_selectedDate != null) {
                        //       getdatewiselist(_selectedDate!);
                        //     } else {
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         const SnackBar(content: Text("No date selected")),
                        //       );
                        //     }
                        //   },
                        // ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    chartData.isNotEmpty
                        ? Container(
                            height: 400,
                            child: SfCircularChart(
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <PieSeries<ChartData, String>>[
                                PieSeries<ChartData, String>(
                                  dataSource: chartData,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true),
                                  // color: AppColor.primary,
                                ),
                              ],
                            ),
                          )
                        : const Center(child: Text('No reports found')),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'DayWise-Chart Data',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
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
        ),
      ),
    );
  }
}
