import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/addnewvideo.dart';
import 'dart:convert';

import 'package:nijatech_yoga_centre_app/presentation/model/videomodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/app_util.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';


class VideoMaster extends StatefulWidget {
  @override
  _VideoMasterState createState() => _VideoMasterState();
}

class _VideoMasterState extends State<VideoMaster> {
  // List<Message> video = [];
  bool _isLoading = false;
  // VideoModelMaster videoModel = VideoModelMaster();
  VideoModel videoModel = VideoModel();
  List<Data> video = [];

  @override
  void initState() {
    super.initState();
    getVideoReports();
  }

  void getVideoReports() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Apiservice.getVideos({});
      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true) {
          videoModel = VideoModel.fromJson(jsonData);
          video = videoModel.data ?? [];

          if (video.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No reports found")),
            );
          }
        } else {
          setState(() {
            video = [];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonData['data'] ?? 'Unknown error')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch reports")),
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

  Future<void> _updateVideoStatus(int id, int currentStatus, int index) async {
    int newStatus = (currentStatus == 1) ? 0 : 1;
    int originalStatus = video[index].status ?? 0;

    setState(() {
      video[index].status = newStatus;
    });

    try {
      print("Sending update request for docno: $id, status: $newStatus");

      final response = await Apiservice.getupadtevideostatus({
        'id': id.toString(),
        'status': newStatus.toString(),
      });

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Status updated successfully')),
          );
        } else {
          setState(() {
            video[index].status = originalStatus;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update status')),
          );
        }
      } else {
        setState(() {
          video[index].status = originalStatus;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating status. Server error')),
        );
      }
    } catch (error) {
      print("Error updating user status: $error");

      setState(() {
        video[index].status = originalStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error updating status. Check your connection.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Master'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddNewVideo()));
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: SingleChildScrollView(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Id')),
                      DataColumn(label: Text('CourseName')),
                      DataColumn(label: Text('Video URL')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: video
                        .asMap()
                        .map((index, message) {
                          return MapEntry(
                            index,
                            DataRow(cells: [
                              DataCell(Text(message.id?.toString() ?? '')),
                              DataCell(Text(message.coursename ?? '')),
                              DataCell(Text(message.youtubelink ?? '')),
                              DataCell(Text(message.content ?? '')),
                              DataCell(
                                Switch(
                                  value: message.status == 0,
                                  onChanged: (bool isActive) {
                                    _updateVideoStatus(message.id!,
                                        message.status ?? 99, index);
                                  },
                                  activeColor: AppColor.primary,
                                  inactiveThumbColor: Colors.red,
                                ),
                              ),
                            ]),
                          );
                        })
                        .values
                        .toList(),
                  ),
                ),
              ),
      ),
    );
  }
}
