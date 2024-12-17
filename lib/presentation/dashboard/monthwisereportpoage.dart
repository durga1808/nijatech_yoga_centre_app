import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/simple_month_year_picker.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/mymonthmodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/app_util.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/pref.dart';


class MonthWiseReportPage extends StatefulWidget {
  const MonthWiseReportPage({Key? key}) : super(key: key);

  @override
  _MonthWiseReportPageState createState() => _MonthWiseReportPageState();
}

class _MonthWiseReportPageState extends State<MonthWiseReportPage> {
  String? _selectedMonth;

  int? _selectedYear;
  bool _isLoading = false;
  MyMonthModel model = MyMonthModel();

  final List<String> months = List.generate(
    12,
    (index) => DateFormat('MMMM').format(DateTime(0, index + 1)),
  );

  void _showMonthYearPicker() async {
    final DateTime? selectedDate = await SimpleMonthYearPicker.showMonthYearPickerDialog(
      context: context,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      monthTextStyle: TextStyle(
        fontSize: 16,
      ),
      backgroundColor: Colors.white,
      selectionColor: AppColor.primary, // Your custom primary color
      barrierDismissible: true,
    );

    if (selectedDate != null) {
      setState(() {
        _selectedYear = selectedDate.year;
        _selectedMonth = DateFormat('MMMM').format(selectedDate);
      });
    }
  }

  void getlistByYearMonth(int selectedYear, String selectedMonth) async {
    int monthNumber = months.indexOf(selectedMonth) + 1;

    var body = {
      "createdBy": Prefs.getID("UserID"),
      "year": selectedYear.toString(),
      "month": monthNumber.toString().padLeft(2, '0'),
    };

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await Apiservice.getmonthwiselist(jsonEncode(body));
      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print("API Response: $jsonResponse");

        if (jsonResponse['status'] == true) {
          model = MyMonthModel.fromJson(jsonResponse);
        } else {
          model.message = [];
          AppUtils.showSingleDialogPopup(
              context, "No data found", "Ok", exitpopup);
        }
      } else {
        AppUtils.showSingleDialogPopup(
            context, "Error fetching data", "Ok", exitpopup);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", exitpopup);
    }
  }

  void exitpopup() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Month Wise Report'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text("Choose Year and Month",
                      style: TextStyle(fontSize: 15)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: _showMonthYearPicker,
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
                                  (_selectedYear != null &&
                                          _selectedMonth != null)
                                      ? '$_selectedYear - $_selectedMonth'
                                      : 'Select Year and Month',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(Icons.calendar_today,
                                    color: AppColor.primary),
                              ],
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
                          if (_selectedYear != null && _selectedMonth != null) {
                            getlistByYearMonth(_selectedYear!, _selectedMonth!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("No year or month selected")),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: model.message != null &&
                                  model.message!.isNotEmpty
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
                              : const Center(child: Text('No reports found.')),
                        ),
                ],
              ),
            ),
    );
  }
}
