import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/simple_month_year_picker.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/allusermodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/model/usermodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/pref.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:excel/excel.dart' as excel;

class AllUserWiseReport extends StatefulWidget {
  const AllUserWiseReport({Key? key}) : super(key: key);

  @override
  _AllUserWiseReportState createState() => _AllUserWiseReportState();
}

class _AllUserWiseReportState extends State<AllUserWiseReport> {
  String? _selectedMonth;
  String? _selectedUser;
  int? _selectedYear;
  late UserModel userModel;
  AllUserModel allUserModel = AllUserModel();
  bool _isLoading = false;

  List<String> userList = [];
  final List<String> months = List.generate(
    12,
    (index) => DateFormat('MMMM').format(DateTime(0, index + 1)),
  );

  @override
  void initState() {
    super.initState();
    _fetchUserList();
  }

  Future<void> _fetchUserList() async {
    setState(() => _isLoading = true);
    var body = {
      "createdBy": Prefs.getID("UserID"),
      "username": Prefs.getUserName("UserName"),
    };

    try {
      final response = await Apiservice.getUserwiseReport(body);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          userModel = UserModel.fromJson(jsonResponse);
          setState(() {
            userList = ["All Users"];
            userList.addAll(userModel.message
                    ?.where((user) => user.status == 0)
                    .map((user) => user.username!)
                    .toList() ??
                []);
          });
        } else {
          _showSnackBar("No data found");
        }
      } else {
        _showSnackBar("Failed to fetch user data");
      }
    } catch (e) {
      _showSnackBar("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMonthYearPicker() async {
    final DateTime? pickedDate =
        await SimpleMonthYearPicker.showMonthYearPickerDialog(
      context: context,
      titleTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      monthTextStyle: const TextStyle(fontSize: 16),
      backgroundColor: Colors.white,
      selectionColor: AppColor.primary,
      barrierDismissible: true,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedMonth = DateFormat('MMMM').format(pickedDate);
        _selectedYear = pickedDate.year;
      });
    }
  }

  Future<void> _fetchMonthlyReport(
      int year, String month, String username) async {
    setState(() => _isLoading = true);

    int monthNumber = months.indexOf(month) + 1;
    var body = {
      "createdBy": Prefs.getID("UserID"),
      "year": year.toString(),
      "month": monthNumber.toString().padLeft(2, '0'),
    };

    if (username != "All Users") {
      body["username"] = username;
    }

    try {
      final response = await Apiservice.getmonthWiseReportuser(body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          setState(() {
            allUserModel = AllUserModel.fromJson(jsonResponse);
          });
        } else {
          setState(() => allUserModel = AllUserModel());
          _showSnackBar("No data found");
        }
      } else {
        _showSnackBar("Error fetching data");
      }
    } catch (e) {
      _showSnackBar("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _exportToExcel() async {
    if (allUserModel.message == null || allUserModel.message!.isEmpty) {
      _showSnackBar("No data available to export");
      return;
    }

    var excelFile = excel.Excel.createExcel();
    excel.Sheet sheet = excelFile['AllUserReports'];


    Set<String> uniqueDatesSet = {};
    for (var report in allUserModel.message!) {
      if (report?.date != null) {
        String formattedDate = DateFormat("dd/MM/yyyy").format(report!.date!);
        uniqueDatesSet.add(formattedDate);
      }
    }

   
    List<String> uniqueDates = uniqueDatesSet.toList();
    uniqueDates.sort((a, b) => a.compareTo(b));


    List<dynamic> headerRow = ['PhoneNo'] + uniqueDates;

    
    var headerStyle = excel.CellStyle(
      backgroundColorHex: "#FFC000",
      fontColorHex: "#000000",
      bold: true, 
    );

  
    for (int col = 0; col < headerRow.length; col++) {
      var cell = sheet.cell(
          excel.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
      cell.value = headerRow[col];
      cell.cellStyle = headerStyle; 
    }

   
    Map<String, Map<String, int>> phoneDataMap = {};

    for (var report in allUserModel.message!) {
      if (report?.phoneno != null && report?.date != null) {
        String phoneNo = report!.phoneno!;
        String formattedDate = DateFormat("dd/MM/yyyy").format(report!.date!);

        if (!phoneDataMap.containsKey(phoneNo)) {
          phoneDataMap[phoneNo] = {};
        }

        if (!phoneDataMap[phoneNo]!.containsKey(formattedDate)) {
          phoneDataMap[phoneNo]![formattedDate] = 0;
        }

        phoneDataMap[phoneNo]![formattedDate] =
            (phoneDataMap[phoneNo]![formattedDate] ?? 0) +
                (report.occurance ?? 0);
      }
    }

   
    int currentRow = 1; 
    for (var phoneNo in phoneDataMap.keys) {
      List<dynamic> row = [phoneNo];

      for (var date in uniqueDates) {
        row.add(phoneDataMap[phoneNo]?[date] ?? 0);
      }

      for (int col = 0; col < row.length; col++) {
        var cell = sheet.cell(excel.CellIndex.indexByColumnRow(
            columnIndex: col, rowIndex: currentRow));
        cell.value = row[col];
      }

      currentRow++;
    }

   
    try {
      final directory = await getExternalStorageDirectory();
      final file = File('${directory!.path}/AllUserWiseReport.xlsx');

      await file.writeAsBytes(excelFile.encode()!);

      OpenFile.open(file.path);
    } catch (e) {
      _showSnackBar("Error while exporting: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All User Reports')),
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
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today, color: AppColor.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Choose Username"),
            const SizedBox(height: 5),
            DropdownSearch<String>(
              items: userList,
              selectedItem: _selectedUser,
              onChanged: (value) {
                setState(() => _selectedUser = value);
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: "Choose a username",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: const Text("Search",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary),
                  onPressed: () {
                    if (_selectedYear != null &&
                        _selectedMonth != null &&
                        _selectedUser != null) {
                      _fetchMonthlyReport(
                          _selectedYear!, _selectedMonth!, _selectedUser!);
                    } else {
                      _showSnackBar("All fields are required");
                    }
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.file_download, color: Colors.white),
                  label: const Text("Export to Excel",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary),
                  onPressed: () async {
                    final permissionStatus = await Permission.storage.status;
                    if (permissionStatus.isDenied) {
                      await Permission.storage.request();
                    } else if (permissionStatus.isPermanentlyDenied) {
                      await openAppSettings();
                    } else {
                      await _exportToExcel();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: allUserModel.message != null &&
                            allUserModel.message!.isNotEmpty
                        ? ListView.builder(
                            itemCount: allUserModel.message!.length,
                            itemBuilder: (context, index) {
                              final report = allUserModel.message?[index];
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
                                        "PhoneNo: ${report?.phoneno ?? "N/A"}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Date: $formattedDate",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Occurrence: ${report?.occurance ?? "N/A"}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(child: Text("No data found")),
                  ),
          ],
        ),
      ),
    );
  }
}
