import 'package:flutter/material.dart';
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/addnewcourse.dart';
import 'dart:convert';

import 'package:nijatech_yoga_centre_app/presentation/model/coursemodel.dart';
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
    // setState(() => isLoading = true);
    try {
      final response = await Apiservice.getcoursemaster(json);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        CourseModel courseModel = CourseModel.fromJson(data);

        if (courseModel.status == true) {
          setState(() => courses = courseModel.message ?? []);
        } else {
          print("API Error: ${data['message']}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(data['message'] ?? 'Failed to load courses')),
          );
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to fetch courses. Server error.')),
        );
      }
    } catch (error) {
      print("Error fetching course data: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Error fetching course data. Check your connection.')),
      );
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(data['message'] ?? 'Failed to update status')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Status updated successfully')),
          );
        }
      } else {
        setState(() {
          courses[index].status = originalStatus;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating status. Server error')),
        );
      }
    } catch (error) {
      print("Error updating user status: $error");
      setState(() {
        courses[index].status = originalStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error updating status. Check your connection.')),
      );
    }
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
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Id')),
                    DataColumn(label: Text('Course Name')),
                    DataColumn(label: Text('Status')),
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
                    ]);
                  }),
                ),
              ),
      ),
    );
  }
}
