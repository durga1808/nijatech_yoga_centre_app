import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/l10n/localization.dart';
import 'package:nijatech_yoga_centre_app/main.dart';

import 'dart:convert';

import 'package:nijatech_yoga_centre_app/presentation/model/coursemodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/Appconstatnts.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/app_util.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/pref.dart';


class Myscore extends StatefulWidget {
  const Myscore({super.key});

  @override
  _MyScorePageState createState() => _MyScorePageState();
}

class _MyScorePageState extends State<Myscore> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedCoursename;
  CourseModel courseModel = CourseModel();
  bool _isLoading = false;
  final dropDownKey = GlobalKey<DropdownSearchState>();
  final TextEditingController _angryCountController = TextEditingController();
  List<String> courselist = [];
  String altercourseid = "";
  String altercoursename = "";
  TextEditingController reasoncontroller = TextEditingController();

  void _changeLanguage(String langCode) {
    Locale newLocale = Locale(langCode);
    MainApp.setLocale(context, newLocale);
  }

  @override
  void initState() {
    getenrollmaster();
    super.initState();
  }

  @override
  void dispose() {
    _angryCountController.dispose();
    reasoncontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.myscoretitle ?? 'My Score',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            // fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
              color: Colors.white,
              onSelected: (String languageCode) async {
                await Prefs.setLanguage("Language", languageCode);
                Locale myLocale =
                    Locale(languageCode, languageCode == 'ta' ? 'IN' : 'US');
                MainApp.setLocale(context, myLocale);
              },
              itemBuilder: (context) => const [
                    PopupMenuItem(value: 'en', child: Text('English')),
                    PopupMenuItem(value: 'ta', child: Text('தமிழ்'))
                  ])
        ],
      ),
      body: !_isLoading
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Select Date',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8),
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
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
                        selectedItem:
                            AppLocalizations.of(context)?.course ?? "Course",
                        items: courselist,
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                          showSelectedItems: true,
                        ),
                        onChanged: (value) {
                          for (int kk = 0;
                              kk < courseModel.message!.length;
                              kk++) {
                            if (courseModel.message![kk].coursename
                                    .toString() ==
                                value) {
                              altercourseid =
                                  courseModel.message![kk].id.toString();
                              altercoursename = courseModel
                                  .message![kk].coursename
                                  .toString();

                              setState(() {});
                            }
                          }
                        },
                      ),
                      // DropdownButtonFormField<String>(
                      //   value: _selectedCoursename,
                      //   decoration: const InputDecoration(
                      //     labelText: 'Select Coursename',
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   isExpanded: true,
                      //   items: _courseList.map((String video) {
                      //     return DropdownMenuItem<String>(
                      //       value: video,
                      //       child: Text(
                      //         video,
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //     );
                      //   }).toList(),
                      //   onChanged: (String? newValue) {
                      //     setState(() {
                      //       _selectedCoursename = newValue;
                      //     });
                      //   },
                      // ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _angryCountController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText:
                              AppLocalizations.of(context)?.count ?? 'count',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),

                      Container(
                          //padding: EdgeInsets.all(20),
                          child: TextField(
                        controller: reasoncontroller,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)?.enterremarks ??
                                  'Enter Remarks',
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: Colors.black26, width: 1),
                          ),
                        ),
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: _submitData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                        ),
                        child: Text(
                            AppLocalizations.of(context)?.submit ?? 'submit',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future<void> _submitData() async {
    String occurance = _angryCountController.text;

    if (occurance.isEmpty) {
      AppUtils.showSingleDialogPopup(
          context,
          AppLocalizations.of(context)?.pleaseentercount ??
              "Please Enter Count!",
          AppLocalizations.of(context)?.Ok ?? "Ok",
          exitpopup);
      return;
    }
    if (altercourseid.isEmpty) {
      AppUtils.showSingleDialogPopup(
          context,
          AppLocalizations.of(context)?.pleasechoosecourse ??
              "Please Choose Course!",
          AppLocalizations.of(context)?.Ok ?? "Ok",
          exitpopup);
      return;
    }
    setState(() {
      _isLoading = true;
    });

    const String url = '${AppConstants.LOCAL_URL}addmyscore';
    final Map<String, dynamic> data = {
      'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
      'courseId': altercourseid,
      'coursename': altercoursename,
      'createdBy': Prefs.getID('UserID'),
      'occurance': occurance,
      "remarks": reasoncontroller.text
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      print(jsonEncode(data));
      setState(() {
        _isLoading = false;
      });
      //final responseData = json.decode(response.body);
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        if (json.decode(response.body)['status'] == true) {
          AppUtils.showSingleDialogPopup(
              context, json.decode(response.body)['message'], "Ok", refresh);
          _angryCountController.clear();
          setState(() {
            _selectedCoursename = null;
            _selectedDate = DateTime.now();
          });
        } else {
          AppUtils.showSingleDialogPopup(
              context, json.decode(response.body)['message'], "Ok", refresh);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit. Please try again.'),
          ),
        );
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      AppUtils.showSingleDialogPopup(context, error, "Ok", exitpopup);
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        // initialDate: _selectedDate,
        // firstDate: DateTime(2000),
        // lastDate: DateTime(2101),
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 7)),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void getenrollmaster() async {
    setState(() {
      _isLoading = true;
    });
    var body = {
      "createdBy": Prefs.getID("UserID"),
    };
    print(jsonEncode(body));
    Apiservice.getenrollmaster(body).then((response) {
      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'] == true) {
          courseModel = CourseModel.fromJson(jsonDecode(response.body));
          print(jsonDecode(response.body));
          courselist.clear();

          for (int k = 0; k < courseModel.message!.length; k++) {
            courselist.add(courseModel.message![k].coursename.toString());
          }
          print(courselist.length);
        } else {
          AppUtils.showSingleDialogPopup(context,
              jsonDecode(response.body)['message'].toString(), "Ok", exitpopup);
        }
      } else {
        AppUtils.showSingleDialogPopup(
            context, response.reasonPhrase, "Ok", exitpopup);
      }
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", exitpopup);
    });
  }

  void exitpopup() {
    AppUtils.pop(context);
  }

  void refresh() {
    AppUtils.pop(context);
    AppUtils.pop(context);
  }
}
