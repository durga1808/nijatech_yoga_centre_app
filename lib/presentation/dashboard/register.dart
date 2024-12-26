import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nijatech_yoga_centre_app/data/api_service.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/app_util.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/appcolor.dart';

class Register extends StatefulWidget {
  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool passwordVisible = false; 

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countrycodeController = TextEditingController();
  final TextEditingController _phonenoController = TextEditingController();

  Future<bool> _checkEmailExists(String email) async {
    try {
      var response = await Apiservice.checkEmail(email);
      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseData['exists'] ?? false;
      } else {
        AppUtils.showSingleDialogPopup(
          context,
          "Failed to check email. Please try again.",
          "OK",
          () => Navigator.pop(context),
        );
        return false;
      }
    } catch (error) {
      AppUtils.showSingleDialogPopup(
        context,
        "An error occurred: $error",
        "OK",
        () => Navigator.pop(context),
      );
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _checkPhoneExists(String phoneno) async {
    try {
      var response = await Apiservice.checkPhone(phoneno);
      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseData['exists'] ?? false;
      } else {
        AppUtils.showSingleDialogPopup(
          context,
          "Failed to check phone number. Please try again.",
          "OK",
          () => Navigator.pop(context),
        );
        return false;
      }
    } catch (error) {
      AppUtils.showSingleDialogPopup(
        context,
        "An error occurred: $error",
        "OK",
        () => Navigator.pop(context),
      );
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _performAsyncValidations() async {
    bool emailExists = await _checkEmailExists(_emailController.text);
    bool phoneExists = await _checkPhoneExists(_phonenoController.text);

    if (emailExists) {
      AppUtils.showSingleDialogPopup(
        context,
        "Email already exists. Please use a different email.",
        "OK",
        () {
          Navigator.pop(context);
        },
      );
      return false;
    }

    if (phoneExists) {
      AppUtils.showSingleDialogPopup(
        context,
        "Phone number already exists. Please use a different phone number.",
        "OK",
        () {
          Navigator.pop(context);
        },
      );
      return false;
    }
    return true;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      bool isValid = await _performAsyncValidations();
      if (!isValid) return;

      final userData = {
        "firstname": _nameController.text,
        "username": _usernameController.text,
        "userpassword": _passwordController.text,
        "mailid": _emailController.text,
        "countrycode": _countrycodeController.text,
        "phoneno": _phonenoController.text,
      };

      setState(() {
        _isLoading = true;
      });

      try {
        var response = await Apiservice.registerUser(userData);
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
              _emailController.clear();
              _countrycodeController.clear();
              _phonenoController.clear();
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
        title: const Text('Register'),
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
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Password',
                  helperStyle: const TextStyle(color: Colors.green),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _countrycodeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Country Code',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid Country Code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phonenoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Register', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
