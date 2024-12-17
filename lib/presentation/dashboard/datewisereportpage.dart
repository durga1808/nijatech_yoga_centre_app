import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/mydatemodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/app_util.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/pref.dart';

class DateWiseReportPage extends StatefulWidget {
  const DateWiseReportPage({Key? key}) : super(key: key);

  @override
  _DateWiseReportPageState createState() => _DateWiseReportPageState();
}

class _DateWiseReportPageState extends State<DateWiseReportPage> {
  String? _selectedDate;
  bool _isLoading = false;
  bool _dateSelected = false;
  String altercourseid = "";
  MyDateModel model = MyDateModel();

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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
              // colorScheme: ColorScheme.light(
              //   // onPrimary: Colors.white,
              // ),
              ),
          child: child!,
        );
      },
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
      } else {
        model.message = [];
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No reports found")),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", exitpopup);
    }
  }

  void exitpopup() {
    AppUtils.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Day Wise Report'),
      ),
      body: Padding(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          foregroundColor: Colors.white,
                          backgroundColor: AppColor.primary,
                        ),
                        onPressed: () {
                          if (_selectedDate != null) {
                            getdatewiselist(altercourseid);
                          } else {
                            AppUtils.showSingleDialogPopup(
                              context,
                              "Please select a date",
                              "Ok",
                              exitpopup,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  model.message != null && model.message!.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
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
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Date: ${report.currentdate}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No. Occurrence: ${report.occurance}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${report.remarks}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const Center(child: Text('No reports found.')),
                ],
              ),
      ),
    );
  }
}
