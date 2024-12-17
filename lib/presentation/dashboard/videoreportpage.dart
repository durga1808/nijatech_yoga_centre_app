// import 'package:flutter/material.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:intl/intl.dart';
// import 'package:yoga_centre_app/data/api_service.dart';
// import 'package:yoga_centre_app/presentation/model/coursemodel.dart';
// import 'package:yoga_centre_app/presentation/model/myvideomodel.dart';
// import 'package:yoga_centre_app/presentation/util/app_util.dart';
// import 'package:yoga_centre_app/presentation/util/appcolor.dart';
// import 'package:yoga_centre_app/presentation/util/pref.dart';
// import 'dart:convert';

// class VideoUploadReportPage extends StatefulWidget {
//   const VideoUploadReportPage({Key? key}) : super(key: key);

//   @override
//   _VideoUploadReportPageState createState() => _VideoUploadReportPageState();
// }

// class _VideoUploadReportPageState extends State<VideoUploadReportPage> {
//   List<String> courselist = [];
//   String? _selectedCourse;
//   bool _isLoading = false;
//   VideoModel videoModel = VideoModel();

//   @override
//   void initState() {
//     super.initState();
//     getCourseMaster();
//   }

//   Future<void> getCourseMaster() async {
//     var body = {"createdBy": Prefs.getID("UserID")};
//     setState(() => _isLoading = true);

//     try {
//       final response = await Apiservice.getenrollmaster(body);
//       setState(() => _isLoading = false);

//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         if (jsonData['status'] == true) {
//           var courseModel = CourseModel.fromJson(jsonData);
//           setState(() {
//             courselist = courseModel.message!
//                 .map((course) => course.coursename!)
//                 .toList();
//           });
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("No courses found")),
//           );
//         }
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", exitpopup);
//     }
//   }

//   void getVideoReports(String coursename) async {
//     var body = {
//       "createdBy": Prefs.getID("UserID"),
//       "coursename": coursename,
//     };

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await Apiservice.getvideo(body);
//       setState(() {
//         _isLoading = false;
//       });

//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);

//         if (jsonData['status'] == true) {
//           videoModel = VideoModel.fromJson(jsonData);

//           if (videoModel.message == null || videoModel.message!.isEmpty) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("No reports found")),
//             );
//           }
//         } else {
//           setState(() {
//             videoModel.message = [];
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(jsonData['message'])),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to fetch reports")),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", exitpopup);
//     }
//   }

//   String formatToLocalDate(String utcDate) {
//     DateTime dateTimeUtc = DateTime.parse(utcDate).toUtc();
//     DateTime dateTimeLocal = dateTimeUtc.toLocal();
//     return DateFormat('yyyy-MM-dd').format(dateTimeLocal);
//   }

//   void exitpopup() => AppUtils.pop(context);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Video Report')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 10),
//                   const Text("Choose coursename"),
//                   const SizedBox(height: 5),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: DropdownSearch<String>(
//                           items: courselist,
//                           selectedItem: _selectedCourse,
//                           popupProps:
//                               const PopupProps.menu(showSearchBox: true),
//                           onChanged: (value) => setState(() {
//                             _selectedCourse = value;
//                           }),
//                           dropdownDecoratorProps: const DropDownDecoratorProps(
//                             dropdownSearchDecoration: InputDecoration(
//                               hintText: "Choose a course",
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       ElevatedButton.icon(
//                         icon: const Icon(
//                           Icons.search,
//                           color: Colors.white,
//                         ),
//                         label: const Text(
//                           "Search",
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: Colors.white,
//                           backgroundColor: AppColor.primary,
//                         ),
//                         onPressed: () {
//                           if (_selectedCourse == null ||
//                               _selectedCourse!.isEmpty) {
//                             AppUtils.showSingleDialogPopup(
//                               context,
//                               "Please select a course",
//                               "Ok",
//                               exitpopup,
//                             );
//                           } else {
//                             getVideoReports(_selectedCourse!);
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Expanded(
//                     child: videoModel.message != null &&
//                             videoModel.message!.isNotEmpty
//                         ? ListView.builder(
//                             itemCount: videoModel.message!.length,
//                             itemBuilder: (context, index) {
//                               final report = videoModel.message![index];
//                               return Card(
//                                 color: AppColor.primary,
//                                 margin: const EdgeInsets.all(16.0),
//                                 elevation: 4,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(16.0),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Course: ${report.coursename}',
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         'Date: ${report.date != null ? formatToLocalDate(report.date!) : 'No date available'}',
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         'Video URL: ${report.videourl}',
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         '${report.description}',
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           )
//                         : const Center(child: Text('No reports found.')),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
  