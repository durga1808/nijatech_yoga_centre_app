import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/app_util.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';


class AddNewUser extends StatefulWidget {
  @override
  _AddNewUserState createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _countrycodeController = TextEditingController();
  final TextEditingController _phonenocontroller = TextEditingController();
  bool _isSuperUser = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final userData = {
        "firstname": _nameController.text,
        "username": _usernameController.text,
        "userpassword": _passwordController.text,
        "mailid": _mailController.text,
        "issuperuser": _isSuperUser ? 1 : 0,
        "countrycode": _countrycodeController.text,
        "phoneno": _phonenocontroller.text
        

      };

      print('Payload being sent: ${jsonEncode(userData)}');

      setState(() {
        _isLoading = true;
      });

      try {
        var response = await Apiservice.addNewUser(userData);
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
              _formKey.currentState?.reset();
              _nameController.clear();
              _usernameController.clear();
              _passwordController.clear();
              _mailController.clear();
              _isSuperUser = false;
              _countrycodeController.clear();
              _phonenocontroller.clear();
              
              setState(() {});
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
        title: const Text('Add New User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _mailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Mail ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a mail ID';
                  }
                  return null;
                },
              ),
                  SizedBox(height: 10),
                  TextFormField(
                controller: _countrycodeController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Country Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Country Code';
                  }
                  return null;
                },
              ),
               SizedBox(height: 10),
                  TextFormField(
                controller: _phonenocontroller,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Phone No'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Phone No';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                title: const Text('Is Super User'),
                value: _isSuperUser,
                onChanged: (bool? value) {
                  setState(() {
                    _isSuperUser = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
