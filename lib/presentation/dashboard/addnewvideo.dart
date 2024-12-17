import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/coursemodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/app_util.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';


class AddNewVideo extends StatefulWidget {
  const AddNewVideo({super.key});

  @override
  AddNewVideoState createState() => AddNewVideoState();
}

class AddNewVideoState extends State<AddNewVideo> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedCoursename;
  CourseModel courseModel = CourseModel();
  bool _isLoading = false;
  final dropDownKey = GlobalKey<DropdownSearchState>();
  final TextEditingController _youtubelinkController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<String> courselist = [];
  String altercourseid = "";
  String altercoursename = "";

  @override
  void initState() {
    super.initState();
    _fetchCourseMaster();
  }

  @override
  void dispose() {
    _youtubelinkController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Video'),
      ),
      body: SingleChildScrollView(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Select Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownSearch<String>(
                      key: dropDownKey,
                      selectedItem: _selectedCoursename,
                      items:
                          courselist.isEmpty ? ["No data found"] : courselist,
                      popupProps: const PopupProps.menu(showSearchBox: true),
                      onChanged: (value) {
                        if (value != null && value != "No data found") {
                          for (var course in courseModel.message!) {
                            if (course.coursename == value) {
                              altercourseid = course.id.toString();
                              altercoursename = course.coursename.toString();
                              setState(() {
                                _selectedCoursename = value;
                              });
                              break;
                            }
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _youtubelinkController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Video URL',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Enter Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _submitData() async {
    if (_youtubelinkController.text.trim().isEmpty ||
        altercourseid.isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      _showDialog("All fields are required!");
      return;
    }

    final data = {
      // 'id': altercourseid,
      'content': _descriptionController.text.trim(),
      'youtubelink': _youtubelinkController.text.trim(),
      'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
      'coursename': altercoursename,
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Apiservice.addVideoDashboard(data);
      final responseData = jsonDecode(response.body);
      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 && responseData['status'] == true) {
        _showDialog(responseData['message'], refresh: true);
        _clearFields();
      } else {
        _showDialog(responseData['message'] ?? 'Submission failed.');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showDialog('Error: $error');
    }
  }

  void _clearFields() {
    _youtubelinkController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCoursename = null;
      _selectedDate = DateTime.now();
    });
  }

  Future<void> _fetchCourseMaster() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Apiservice.getcoursemaster({});
      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          courseModel = CourseModel.fromJson(responseData);
          courselist = courseModel.message!
              .where((course) => course.status == 0)
              .map((course) => course.coursename.toString())
              .toList();
        } else {
          _showDialog(responseData['message'] ?? 'Error loading courses');
        }
      } else {
        _showDialog('Failed to load courses. Please try again.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showDialog(e.toString());
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showDialog(String message, {bool refresh = false}) {
    AppUtils.showSingleDialogPopup(
      context,
      message,
      "Ok",
      refresh ? refreshPage : closeDialog,
    );
  }

  void refreshPage() {
    AppUtils.pop(context);
  }

  void closeDialog() => AppUtils.pop(context);
}
