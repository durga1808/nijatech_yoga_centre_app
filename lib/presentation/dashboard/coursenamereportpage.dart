import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/coursemodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/mycoursemodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/app_util.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/pref.dart';


class CourseNameReportPage extends StatefulWidget {
  const CourseNameReportPage({Key? key}) : super(key: key);

  @override
  _CourseNameReportPageState createState() => _CourseNameReportPageState();
}

class _CourseNameReportPageState extends State<CourseNameReportPage> {
  List<String> courseList = [];
  String? _selectedCourse;
  bool _isLoading = false;
  late CourseModel courseModel;
  MyCourseModel model = MyCourseModel();
  String? selectedCourseId;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Wise Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text("Choose course name"),
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
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Choose a course",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // IconButton(
                      //   icon: const Icon(Icons.search),
                      //   color: AppColor.primary,
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: model.message != null && model.message!.isNotEmpty
                        ? ListView.builder(
                            itemCount: model.message!.length,
                            itemBuilder: (context, index) {
                              final report = model.message![index];
                              return Card(
                                color: AppColor.primary,
                                margin: const EdgeInsets.all(16.0),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Course: ${report.coursename}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Date: ${report.currentdate}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Occurance: ${report.occurance}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        ' ${report.remarks}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(child: Text('No reports found.')),
                  ),
                ],
              ),
      ),
    );
  }
}
