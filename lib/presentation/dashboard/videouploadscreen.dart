// import 'dart:convert';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'package:yoga_centre_app/data/api_service.dart';
// import 'package:yoga_centre_app/presentation/model/coursemodel.dart';
// import 'package:yoga_centre_app/presentation/util/Appconstatnts.dart';
// import 'package:yoga_centre_app/presentation/util/app_util.dart';
// import 'package:yoga_centre_app/presentation/util/appcolor.dart';
// import 'package:yoga_centre_app/presentation/util/pref.dart';

// class VideoUploadScreen extends StatefulWidget {
//   const VideoUploadScreen({super.key});

//   @override
//   VideopageState createState() => VideopageState();
// }

// class VideopageState extends State<VideoUploadScreen> {
//   DateTime _selectedDate = DateTime.now();
//   String? _selectedCoursename;
//   CourseModel courseModel = CourseModel();
//   bool _isLoading = false;
//   final dropDownKey = GlobalKey<DropdownSearchState>();
//   final TextEditingController _videoUrlController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   List<String> courselist = [];
//   String altercourseid = "";
//   String altercoursename = "";

//   @override
//   void initState() {
//     getenrollmaster();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _videoUrlController.dispose();
//     descriptionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upload Video'),
//       ),
//       body: !_isLoading
//           ? Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     InputDecorator(
//                       decoration: const InputDecoration(
//                         labelText: 'Select Date',
//                         border: OutlineInputBorder(),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.calendar_today),
//                             onPressed: () => _selectDate(context),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     DropdownSearch<String>(
//                       key: dropDownKey,
//                       selectedItem: _selectedCoursename,
//                       items:
//                           courselist.isEmpty ? ["No data found"] : courselist,
//                       popupProps: const PopupProps.menu(
//                         showSearchBox: true,
//                       ),
//                       onChanged: (value) {
//                         if (value != null && value != "No data found") {
//                           for (var course in courseModel.message!) {
//                             if (course.coursename == value) {
//                               altercourseid = course.id.toString();
//                               altercoursename = course.coursename.toString();
//                               setState(() {
//                                 _selectedCoursename = value;
//                               });
//                               break;
//                             }
//                           }
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: _videoUrlController,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Video URL',
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: descriptionController,
//                       maxLines: 4,
//                       decoration: InputDecoration(
//                         hintText: "Enter Description",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: _submitData,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColor.primary,
//                       ),
//                       child: const Text('Submit',
//                           style: TextStyle(color: Colors.white)),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           : const Center(child: CircularProgressIndicator()),
//     );
//   }

//   Future<void> _submitData() async {
//     String videourl = _videoUrlController.text;
//     if (videourl.isEmpty || altercourseid.isEmpty) {
//       AppUtils.showSingleDialogPopup(
//           context, "Please enter all required fields!", "Ok", exitpopup);
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     const String url = '${AppConstants.LOCAL_URL}addUploadvideos';
//     final Map<String, dynamic> data = {
//       'courseId': altercourseid,
//       'courseName': altercoursename,
//       'createdBy': Prefs.getID('UserID'),
//       'videoUrl': videourl,
//       'description': descriptionController.text,
//       'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
//     };

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: json.encode(data),
//       );

//       setState(() {
//         _isLoading = false;
//       });

//       final responseData = json.decode(response.body);
//       if (response.statusCode == 200 && responseData['status'] == true) {
//         AppUtils.showSingleDialogPopup(
//             context, responseData['message'], "Ok", refresh);
//         _videoUrlController.clear();
//         descriptionController.clear();
//         setState(() {
//           _selectedCoursename = null;
//           _selectedDate = DateTime.now();
//         });
//       } else {
//         AppUtils.showSingleDialogPopup(context,
//             responseData['message'] ?? 'Failed to submit.', "Ok", exitpopup);
//       }
//     } catch (error) {
//       setState(() {
//         _isLoading = false;
//       });
//       AppUtils.showSingleDialogPopup(
//           context, error.toString(), "Ok", exitpopup);
//     }
//   }

//   void _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now().subtract(const Duration(days: 7)),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   void getenrollmaster() async {
//     setState(() {
//       _isLoading = true;
//     });
//     var body = {"createdBy": Prefs.getID("UserID")};
//     Apiservice.getenrollmaster(body).then((response) {
//       setState(() {
//         _isLoading = false;
//       });

//       if (response.statusCode == 200 &&
//           jsonDecode(response.body)['status'] == true) {
//         courseModel = CourseModel.fromJson(jsonDecode(response.body));
//         courselist = courseModel.message!
//             .map((course) => course.coursename.toString())
//             .toList();
//       } else {
//         AppUtils.showSingleDialogPopup(
//             context,
//             jsonDecode(response.body)['message']?.toString() ??
//                 'Error loading courses',
//             "Ok",
//             exitpopup);
//       }
//     }).catchError((e) {
//       setState(() {
//         _isLoading = false;
//       });
//       AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", exitpopup);
//     });
//   }

//   void exitpopup() {
//     AppUtils.pop(context);
//   }

//   void refresh() {
//     AppUtils.pop(context);
//   }
// }
