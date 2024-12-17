import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/coursemodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/mycoursemodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/usermodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/app_util.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/pref.dart';


class CourseWiseReport extends StatefulWidget {
  const CourseWiseReport({Key? key}) : super(key: key);

  @override
  _CourseWiseReport createState() => _CourseWiseReport();
}

class _CourseWiseReport extends State<CourseWiseReport> {
  List<String> courseList = [];
  List<String> userList = [];
  String? _selectedCourse;
  String? _selectedUser;
  bool _isLoading = false;
  late CourseModel courseModel;
  late UserModel userModel;
  MyCourseModel model = MyCourseModel();
  String? selectedCourseId;
  String? selectedUserId;

  @override
  void initState() {
    super.initState();
    getCourseMaster();
    getUserList();
  }

  Future<void> getCourseMaster() async {
    var body = {
      "createdBy": Prefs.getID("UserID"),
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Apiservice.getcoursemaster(body);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          courseModel = CourseModel.fromJson(jsonResponse);
          setState(() {
            courseList = courseModel.message!
                .where((course) => course.status == 0)
                .map((course) => course.coursename!)
                .toList();
            _isLoading = false;
          });
        } else {
          _handleNoData();
        }
      }
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> getUserList() async {
    var body = {
      "createdBy": Prefs.getID("UserID"),
      "username": Prefs.getUserName("UserName"),
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Apiservice.getUserwiseReport(body);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          userModel = UserModel.fromJson(jsonResponse);
          setState(() {
            userList = userModel.message!
                .where((user) => user.status == 0)
                .map((user) => user.username!)
                .toList();
            _isLoading = false;
          });
        } else {
          _handleNoData();
        }
      }
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> getUserListid(String userId, String username) async {
    var body = {
      "createdBy": Prefs.getID("UserID"),
      "userId": userId,
      "username": username
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Apiservice.getUserwiseReportid(body);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          userModel = UserModel.fromJson(jsonResponse);
          setState(() {
            userList =
                userModel.message!.map((user) => user.username!).toList();
            _isLoading = false;
          });
        } else {
          _handleNoData();
        }
      }
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> getCourseReports(
      String courseId, String courseName, String username) async {
    var body = {
      "createdBy": Prefs.getID("UserID"),
      "coursename": courseName,
      "username": username,
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Apiservice.getcourselist(body);

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
            SnackBar(
                content: Text(jsonResponse['message'] ?? "No reports found")),
          );
        }
      } else {
        _handleNoData();
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(dynamic e) {
    setState(() {
      _isLoading = false;
    });
    AppUtils.showSingleDialogPopup(
      context,
      "Error: $e",
      "Ok",
      exitPopup,
    );
  }

  void exitPopup() {
    AppUtils.pop(context);
  }

  void _handleNoData() {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No data found")),
    );
  }

  // void _handleError(dynamic e) {
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", exitPopup);
  // }

  // void exitPopup() {
  //   AppUtils.pop(context);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Reports'),
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
                  DropdownSearch<String>(
                    items: courseList,
                    selectedItem: _selectedCourse,
                    popupProps: const PopupProps.menu(showSearchBox: true),
                    onChanged: (value) {
                      setState(() {
                        _selectedCourse = value;
                        selectedCourseId = courseList.indexOf(value ?? '') >= 0
                            ? (courseList.indexOf(value!) + 1).toString()
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
                  const SizedBox(height: 10),
                  const Text("Choose username"),
                  const SizedBox(height: 5),
                  DropdownSearch<String>(
                    items: userList,
                    selectedItem: _selectedUser,
                    popupProps: const PopupProps.menu(showSearchBox: true),
                    onChanged: (value) {
                      setState(() {
                        _selectedUser = value;

                        selectedUserId = userModel.message!
                                .firstWhere(
                                  (user) => user.username == _selectedUser,
                                  orElse: () =>
                                      User(id: 0, username: "", mobile: ''),
                                )
                                .id
                                ?.toString() ??
                            '';
                      });
                    },
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: "Choose a username",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.search, color: Colors.white),
                    label: const Text(
                      "Search",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                    ),
                    onPressed: () {
                      if (selectedCourseId == null || _selectedUser == null) {
                        AppUtils.showSingleDialogPopup(
                          context,
                          "Please select both course and username",
                          "Ok",
                          exitPopup,
                        );
                      } else {
                        getCourseReports(
                          selectedCourseId!,
                          _selectedCourse!,
                          _selectedUser!,
                        );
                      }
                    },
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
                        : const Center(
                            child: Text('No reports available.'),
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
