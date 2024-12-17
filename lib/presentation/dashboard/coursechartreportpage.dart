import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/chartdata.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/coursemodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/mycoursemodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/app_util.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/pref.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class CourseChartReportPage extends StatefulWidget {
  const CourseChartReportPage({Key? key}) : super(key: key);

  @override
  _CourseChartReportPageState createState() => _CourseChartReportPageState();
}

class _CourseChartReportPageState extends State<CourseChartReportPage> {
  List<String> courseList = [];
  String? _selectedCourse;
  bool _isLoading = false;
  late CourseModel courseModel;
  MyCourseModel model = MyCourseModel();
  String? selectedCourseId;
  List<ChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    getCourseMaster();
  }

  Future<void> getCourseMaster() async {
    var body = {"createdBy": Prefs.getID("UserID")};
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Apiservice.getenrollmaster(body);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          courseModel = CourseModel.fromJson(jsonResponse);
          setState(() {
            courseList = courseModel.message!
                .map((course) => course.coursename!)
                .toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No data found")),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", exitPopup);
    }
  }

  Future<void> getCourseReports(String courseId, String courseName) async {
    var body = {
      "createdBy": Prefs.getID("UserID"),
      "courseId": courseId,
      "coursename": courseName,
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Apiservice.getdcourselist(body);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          setState(() {
            model = MyCourseModel.fromJson(jsonResponse);
            _isLoading = false;
          });
          _prepareChartData();
        } else {
          setState(() {
            model.message = [];
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No reports found")),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load data")),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", exitPopup);
    }
  }

  void exitPopup() {
    AppUtils.pop(context);
  }

    
// void _prepareChartData() {

//   final Map<String, int> courseOccurrenceMap = {};

//   for (var report in model.message ?? []) {
//     final courseName = report?.coursename ?? 'Unknown';
//     final occurrence = (report?.occurance ?? 0) as int; 
//     courseOccurrenceMap[courseName] = (courseOccurrenceMap[courseName] ?? 0) + occurrence;
//   }

 
//   setState(() {
//     chartData = courseOccurrenceMap.entries
//         .map((entry) => ChartData(entry.key, entry.value))
//         .toList();
//   });
// }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Wise Chart Report'),
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
                    Text("Choose Course", style: TextStyle(fontSize: 15)),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownSearch<String>(
                            items: courseList,
                            selectedItem: _selectedCourse,
                            popupProps: const PopupProps.menu(
                              showSearchBox: true,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _selectedCourse = value;
                                selectedCourseId =
                                    courseList.indexOf(value ?? '') >= 0
                                        ? (courseList.indexOf(value!) + 1)
                                            .toString()
                                        : null;
                              });
                            },
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Choose a course",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
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
                            foregroundColor: Colors.white,
                            backgroundColor: AppColor.primary,
                          ),
                          onPressed: () {
                            if (selectedCourseId == null) {
                              AppUtils.showSingleDialogPopup(
                                context,
                                "Please select a course",
                                "Ok",
                                exitPopup,
                              );
                            } else {
                              getCourseReports(
                                  selectedCourseId!, _selectedCourse!);
                            }
                          },
                        )
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
                        : const Center(child: Text('No data available')),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'CourseWise-Chart Data',
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
