import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/addnewuser.dart';

import 'dart:convert';

import 'package:nijatech_yoga_centre_app/presentation/model/usermodel.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';


class UserMaster extends StatefulWidget {
  @override
  _UserMasterState createState() => _UserMasterState();
}

class _UserMasterState extends State<UserMaster> {
  List<User> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Apiservice.getusermaster(json);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          List<User> loadedUsers = [];
          for (var userData in data['message']) {
            loadedUsers.add(User.fromJson(userData));
          }
          setState(() {
            users = loadedUsers;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateUserStatus(
      int userId, int currentStatus, int index) async {
    int newStatus = (currentStatus == 1) ? 0 : 1;
    int originalStatus = users[index].status ?? 0;

    setState(() {
      users[index].status = newStatus;
    });

    try {
      print("Sending update request for userId: $userId, status: $newStatus");

      final response = await Apiservice.getupdateUserStatus({
        'userId': userId.toString(),
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
            users[index].status = originalStatus;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update status')),
          );
        }
      } else {
        setState(() {
          users[index].status = originalStatus;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating status. Server error')),
        );
      }
    } catch (error) {
      print("Error updating user status: $error");

      setState(() {
        users[index].status = originalStatus;
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
        title: const Text('User Master'),
        actions: [
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddNewUser()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Username')),
                      DataColumn(label: Text('Email ID')),
                      DataColumn(label: Text('Password')),
                      DataColumn(label: Text('Superuser')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: users
                        .asMap()
                        .map((index, user) {
                          return MapEntry(
                            index,
                            DataRow(cells: [
                              DataCell(Text(user.id.toString())),
                              DataCell(Text(user.username ?? '')),
                              DataCell(Text(user.mailid ?? '')),
                              DataCell(Text(user.userpassword.toString())),
                              DataCell(
                                  Text(user.issuperuser == 1 ? 'Yes' : 'No')),
                              // DataCell(Text(user.status == 0 ? 'Active' : 'Inactive')),
                              DataCell(
                                Switch(
                                  value: user.status == 0,
                                  onChanged: (bool isActive) {
                                    _updateUserStatus(
                                        user.id!, user.status ?? 99, index);
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
