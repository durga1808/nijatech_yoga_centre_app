import 'package:flutter/material.dart';
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nijatech_yoga_centre_app/presentation/dashboard/addnewcourse.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/coursemodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/Appconstatnts.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';

class CourseMaster extends StatefulWidget {
  @override
  _CourseMasterState createState() => _CourseMasterState();
}

class _CourseMasterState extends State<CourseMaster> {
  List<Message> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourseData();
  }

  Future<void> _fetchCourseData() async {
    setState(() => isLoading = true);
    try {
      final response = await Apiservice.getcoursemaster({});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        CourseModel courseModel = CourseModel.fromJson(data);
        if (courseModel.status == true) {
          setState(() => courses = courseModel.message ?? []);
        } else {
          _showSnackBar(data['message'] ?? 'Failed to load courses');
        }
      } else {
        _showSnackBar('Failed to fetch courses. Server error.');
      }
    } catch (error) {
      print("Error fetching course data: $error");
      _showSnackBar('Error fetching course data. Check your connection.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteCourseMasterId(
      int id, String coursename, int index) async {
    setState(() => isLoading = true);
    try {
      final url =
          Uri.parse(AppConstants.LOCAL_URL + AppConstants.deleteCourseMasterId);

      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'id': id.toString(),
          'coursename': coursename,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          setState(() => courses.removeAt(index));
          _showSnackBar(data['message'] ?? 'Course deleted successfully.');
        } else {
          _showSnackBar(data['message'] ?? 'Failed to delete course.');
        }
      } else {
        _showSnackBar('Server error. Failed to delete course.');
      }
    } catch (error) {
      print("Error deleting course: $error");
      _showSnackBar('Error deleting course. Check your connection.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateCourseStatus(int id, int currentStatus, int index) async {
    int newStatus = (currentStatus == 1) ? 0 : 1;
    int originalStatus = courses[index].status ?? 0;

    setState(() {
      courses[index].status = newStatus;
    });

    try {
      final response = await Apiservice.getupadtecoursestatus({
        'id': id.toString(),
        'status': newStatus.toString(),
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] != true) {
          setState(() {
            courses[index].status = originalStatus;
          });
          _showSnackBar(data['message'] ?? 'Failed to update status');
        } else {
          _showSnackBar('Status updated successfully');
        }
      } else {
        setState(() {
          courses[index].status = originalStatus;
        });
        _showSnackBar('Error updating status. Server error');
      }
    } catch (error) {
      print("Error updating course status: $error");
      setState(() {
        courses[index].status = originalStatus;
      });
      _showSnackBar('Error updating status. Check your connection.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Master'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNewCourse()),
              ).then((value) => _fetchCourseData());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Course Name')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: List.generate(courses.length, (index) {
                  final course = courses[index];
                  return DataRow(cells: [
                    DataCell(Text(course.id?.toString() ?? '')),
                    DataCell(Text(course.coursename ?? '')),
                    DataCell(
                      Switch(
                        value: course.status == 0,
                        onChanged: (isActive) {
                          if (course.id != null) {
                            _updateCourseStatus(
                                course.id!, course.status ?? 99, index);
                          }
                        },
                        activeColor: AppColor.primary,
                        inactiveThumbColor: Colors.red,
                      ),
                    ),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete, color: AppColor.primary),
                        onPressed: () {
                          if (course.id != null && course.coursename != null) {
                            _deleteCourseMasterId(
                                course.id!, course.coursename!, index);
                          }
                        },
                      ),
                    ),
                  ]);
                }),
              ),
            ),
    );
  }
}
