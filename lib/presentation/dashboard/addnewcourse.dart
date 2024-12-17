import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/app_util.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';


class AddNewCourse extends StatefulWidget {
  @override
  _AddNewCourseState createState() => _AddNewCourseState();
}

class _AddNewCourseState extends State<AddNewCourse> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _courseameController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final userData = {
        "coursename": _courseameController.text,
      };

      print('Payload being sent: ${jsonEncode(userData)}');

      setState(() {
        _isLoading = true;
      });

      try {
        var response = await Apiservice.addNewCourse(userData);

        print('Response: ${response.body}');
        setState(() {
          _isLoading = false;
        });

        var responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData['status']) {
          AppUtils.showSingleDialogPopup(
            context,
            responseData['message'],
            "OK",
            () {
              Navigator.pop(context);
              Navigator.pop(context);
              _formKey.currentState?.reset();
              _courseameController.clear();
            },
          );
        } else {
          AppUtils.showSingleDialogPopup(
            context,
            responseData['message'],
            "OK",
            () {
              Navigator.pop(context);
            },
          );
        }
      } catch (error) {
        print('Error caught: $error');
        setState(() {
          _isLoading = false;
        });

        AppUtils.showSingleDialogPopup(
          context,
          "An error occurred: $error",
          "OK",
          () {
            Navigator.pop(context);
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Course'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _courseameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Course Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a course name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
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
}
