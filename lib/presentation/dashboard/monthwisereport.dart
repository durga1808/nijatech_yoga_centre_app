import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/simple_month_year_picker.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/mymonthmodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/usermodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/app_util.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/pref.dart';

class MonthWiseReport extends StatefulWidget {
  const MonthWiseReport({Key? key}) : super(key: key);

  @override
  _MonthWiseReportState createState() => _MonthWiseReportState();
}

class _MonthWiseReportState extends State<MonthWiseReport> {
  String? _selectedMonth;
  String? _selectedUser;
  int? _selectedYear;
  late UserModel userModel;
  MyMonthModel model = MyMonthModel();
  String? selectedUserId;
  bool _isLoading = false;

  List<String> userList = [];
  final List<String> months = List.generate(
    12,
    (index) => DateFormat('MMMM').format(DateTime(0, index + 1)),
  );

  @override
  void initState() {
    super.initState();
    getUserList();
  }

  Future<void> getUserList() async {
    setState(() => _isLoading = true);

    var body = {
      "createdBy": Prefs.getID("UserID"),
      "username": Prefs.getUserName("UserName"),
    };

    try {
      final response = await Apiservice.getUserwiseReport(body);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          userModel = UserModel.fromJson(jsonResponse);
          setState(() {
            userList = userModel.message
                    ?.where((user) => user.status == 0)
                    .map((user) => user.username!)
                    .toList() ??
                [];
          });
        } else {
          _handleNoData();
        }
      } else {
        _handleNoData();
      }
    } catch (e) {
      _handleError(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }


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
        _selectedYear = pickedDate.year;
      });

      // getlistByYearMonth(_selectedYear!, _selectedMonth!);
    }
  }

  void _handleNoData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No data found")),
    );
  }

  void _handleError(dynamic e) {
    AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", AppUtils.pop);
  }

  void getlistByYearMonth(int year, String month, String username) async {
    setState(() => _isLoading = true);

    int monthNumber = months.indexOf(month) + 1;

    var body = {
      "createdBy": Prefs.getID("UserID"),
      "year": year.toString(),
      "month": monthNumber.toString().padLeft(2, '0'),
      "username": username,
    };

    try {
      var response = await Apiservice.getmonthWiseReportuser(body);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('Response JSON: $jsonResponse');
        if (jsonResponse['status'] == true) {
          final parsedModel = MyMonthModel.fromJson(jsonResponse);
          setState(() {
            model = parsedModel;
          });
        } else {
          setState(() {
            model = MyMonthModel();
          });
          _handleNoData();
        }
      } else {
        _handleError("Error fetching data");
      }
    } catch (e) {
      _handleError(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Month Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Choose Year and Month", style: TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            InkWell(
              onTap: _showMonthYearPicker,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (_selectedYear != null && _selectedMonth != null)
                          ? '$_selectedYear - $_selectedMonth'
                          : 'Select Year and Month',
                    ),
                    const Icon(Icons.calendar_today, color: AppColor.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Choose username"),
            const SizedBox(height: 5),
            DropdownSearch<String>(
              items: userList,
              selectedItem: _selectedUser,
              onChanged: (value) => setState(() => _selectedUser = value),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: "Choose a username",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.search, color: Colors.white),
              label:
                  const Text("Search", style: TextStyle(color: Colors.white)),
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
              onPressed: () {
                if (_selectedYear != null &&
                    _selectedMonth != null &&
                    _selectedUser != null) {
                  getlistByYearMonth(
                      _selectedYear!, _selectedMonth!, _selectedUser!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("All fields are required")),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: model.message != null && model.message!.isNotEmpty
                        ? ListView.builder(
                            itemCount: model.message!.length,
                            itemBuilder: (context, index) {
                              final report = model.message?[index];
                              String formattedDate = report?.date != null
                                  ? DateFormat("dd/MM/yyyy")
                                      .format(report!.date!)
                                  : "N/A";
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
                                        'Course: ${report?.coursename ?? "N/A"}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Date: $formattedDate',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No. Occurrence: ${report?.occurance ?? 0}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${report?.remarks ?? "N/A"}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(child: Text('No data available')),
                  ),
          ],
        ),
      ),
    );
  }
}
