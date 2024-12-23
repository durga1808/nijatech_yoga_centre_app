import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nijatech_yoga_centre_app/presentation/util/Appconstatnts.dart';
import 'package:nijatech_yoga_centre_app/presentation/util/pref.dart';

class Apiservice {
  static const int timeOutDuration = 35;
  String userid = Prefs.getUserName("UserName").toString();

  static Future<http.Response> getlogin(
      String username, String password) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.Login);
    Map<String, String> headers = {"Content-Type": "application/json"};

    var body = {"username": username, "userpassword": password};
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> getcoursemaster(d) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.getcoursemaster);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http.post(url, headers: headers).timeout(
          const Duration(seconds: timeOutDuration),
        );
    return response;
  }

  static Future<http.Response> getusermaster(d) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.getusermaster);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http.post(url, headers: headers).timeout(
          const Duration(seconds: timeOutDuration),
        );
    return response;
  }

  static Future<http.Response> getvideosmaster(d) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.getvideomaster);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http.post(url, headers: headers).timeout(
          const Duration(seconds: timeOutDuration),
        );
    return response;
  }

  static Future<http.Response> getupdateUserStatus(
      Map<String, String> data) async {
    var url =
        Uri.parse(AppConstants.LOCAL_URL + AppConstants.getupdateuserstatus);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response = await http
        .post(
          url,
          headers: headers,
          body: json.encode(data),
        )
        .timeout(const Duration(seconds: timeOutDuration));

    return response;
  }

  static Future<http.Response> getupadtevideostatus(
      Map<String, String> data) async {
    var url =
        Uri.parse(AppConstants.LOCAL_URL + AppConstants.getupadtevideostatus);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response = await http
        .post(
          url,
          headers: headers,
          body: json.encode(data), // Pass the data as JSON encoded
        )
        .timeout(const Duration(seconds: timeOutDuration));

    return response;
  }

  static Future<http.Response> getupadtecoursestatus(
      Map<String, String> data) async {
    var url =
        Uri.parse(AppConstants.LOCAL_URL + AppConstants.getupadtecoursestatus);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response = await http
        .post(
          url,
          headers: headers,
          body: json.encode(data), // Pass the data as JSON encoded
        )
        .timeout(const Duration(seconds: timeOutDuration));

    return response;
  }

  static Future<http.Response> deleteCourseMasterId(
      Map<String, String> data) async {
    var url =
        Uri.parse(AppConstants.LOCAL_URL + AppConstants.deleteCourseMasterId);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response = await http
        .delete(
          url,
          headers: headers,
          body: json.encode(data), // Pass the data as JSON encoded
        )
        .timeout(const Duration(seconds: timeOutDuration));

    return response;
  }

  static Future<http.Response> deleteUserMasterId(
      Map<String, String> data) async {
    var url =
        Uri.parse(AppConstants.LOCAL_URL + AppConstants.deleteUserMasterId);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response = await http
        .delete(
          url,
          headers: headers,
          body: json.encode(data), // Pass the data as JSON encoded
        )
        .timeout(const Duration(seconds: timeOutDuration));

    return response;
  }

  static Future<http.Response> deleteVideoMasterId(
      Map<String, String> data) async {
    var url =
        Uri.parse(AppConstants.LOCAL_URL + AppConstants.deleteVideoMasterId);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response = await http
        .delete(
          url,
          headers: headers,
          body: json.encode(data), // Pass the data as JSON encoded
        )
        .timeout(const Duration(seconds: timeOutDuration));

    return response;
  }

  static Future<http.Response> addenrollmaster(
      Map<String, dynamic> body) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.addenroll);
    Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      var response = await http
          .post(
            url,
            body: jsonEncode(body), // Encode the body properly
            headers: headers,
          )
          .timeout(const Duration(seconds: timeOutDuration));
      return response;
    } catch (e) {
      print("Error occurred while sending request: $e");
      rethrow; // Re-throw the error for handling in `_enrollInCourse`
    }
  }

  static Future<http.Response> getenrollmaster(dynamic json) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.enroll);
    Map<String, String> headers = {"Content-Type": "application/json"};

    //var body = {"username": username, "userpassword": password};
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    // print(response);
    return response;
  }

  static Future<http.Response> getenrollsupermaster(dynamic json) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.getSuperenroll);
    Map<String, String> headers = {"Content-Type": "application/json"};

    //var body = {"username": username, "userpassword": password};
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    // print(response);
    return response;
  }

  static Future<http.Response> getvideo(dynamic json) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.videos);
    Map<String, String> headers = {"Content-Type": "application/json"};

    //var body = {"username": username, "userpassword": password};
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    // print(response);
    return response;
  }

  static Future<http.Response> getVideos(Map<String, dynamic> json) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.getVideos);
    Map<String, String> headers = {"Content-Type": "application/json"};

    var response = await http
        .post(
          url,
          body: jsonEncode(json), // Ensure `json` is a Map<String, dynamic>
          headers: headers,
        )
        .timeout(const Duration(seconds: timeOutDuration));

    return response;
  }

  static Future<http.Response> getvideomaster(dynamic json) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.addmyvideos);
    Map<String, String> headers = {"Content-Type": "application/json"};

    //var body = {"username": username, "userpassword": password};
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    // print(response);
    return response;
  }

  static Future<http.Response> addVideoDashboard(dynamic json) async {
    var url = Uri.parse(AppConstants.LOCAL_URL +
        AppConstants.addVideoDashboard); // Full URL here
    Map<String, String> headers = {"Content-Type": "application/json"};

    var response = await http
        .post(
          url,
          body: jsonEncode(json),
          headers: headers,
        )
        .timeout(const Duration(seconds: 30)); // Adjust timeout if needed

    return response;
  }

  // static Future<http.Response> getcourcemaster() async {
  //   var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.getcourcemaster);
  //   Map<String, String> headers = {"Content-Type": "application/json"};

  //   //var body = {"username": username, "userpassword": password};
  //   var response = await http.get(url, headers: headers).timeout(
  //         const Duration(seconds: timeOutDuration),
  //       );
  //   //print(jsonEncode(json));
  //   return response;
  // }

  // static Future<http.Response> getscrorelist(dynamic json) async {
  //   var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.myscore);
  //   Map<String, String> headers = {"Content-Type": "application/json"};

  //   //var body = {"username": username, "userpassword": password};
  //   var response =
  //       await http.post(url, body: jsonEncode(json), headers: headers).timeout(
  //             const Duration(seconds: timeOutDuration),
  //           );
  //   // print(response);
  //   return response;
  // }

  static Future<http.Response> getdcourselist(dynamic json) async {
    var url =
        Uri.parse(AppConstants.LOCAL_URL + AppConstants.courseNameWiseReport);
    Map<String, String> headers = {"Content-Type": "application/json"};

    var body = jsonEncode(json);

    var response = await http
        .post(
          url,
          headers: headers,
          body: body,
        )
        .timeout(const Duration(seconds: timeOutDuration));

    return response;
  }

  static Future<http.Response> getcourselist(Map<String, dynamic> json) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.courseWiseReport);
    Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      var body = jsonEncode(json);

      var response = await http
          .post(
            url,
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: timeOutDuration));

      return response;
    } catch (error) {
      throw Exception("Error encoding JSON: $error");
    }
  }

  static Future<http.Response> getmonthWiseReportuser(
      Map<String, dynamic> json) async {
    var url =
        Uri.parse(AppConstants.LOCAL_URL + AppConstants.monthWiseReportuser);
    Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      var body = jsonEncode(json);

      var response = await http
          .post(
            url,
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: timeOutDuration));

      return response;
    } catch (error) {
      throw Exception("Error encoding JSON: $error");
    }
  }

  static Future<http.Response> addNewUser(dynamic json) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.addNewUser);
    Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      var response = await http
          .post(url, body: jsonEncode(json), headers: headers)
          .timeout(const Duration(seconds: 30));

      return response;
    } catch (e) {
      print('Error while sending request: $e');
      rethrow; // Rethrow the exception to handle it in the caller
    }
  }

  static Future<http.Response> registerUser(dynamic json) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.registerUser);
    Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      var response = await http
          .post(url, body: jsonEncode(json), headers: headers)
          .timeout(const Duration(seconds: 30));

      return response;
    } catch (e) {
      print('Error while sending request: $e');
      rethrow; // Rethrow the exception to handle it in the caller
    }
  }

  static Future<dynamic> checkEmail(String email) async {
    final url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.checkEmail);
    final response = await http.post(url, body: {'mailid': email});
    return response;
  }

  static Future<dynamic> checkPhone(String phone) async {
    final url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.checkPhone);
    final response = await http.post(url, body: {'phoneno': phone});
    return response;
  }

  static Future<http.Response> addNewCourse(dynamic json) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.addcoursemaster);
    Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      var response = await http
          .post(url, body: jsonEncode(json), headers: headers)
          .timeout(const Duration(seconds: 30));

      return response;
    } catch (e) {
      print('Error while sending request: $e');
      rethrow; // Rethrow the exception to handle it in the caller
    }
  }

  static Future<http.Response> getUserwiseReport(dynamic json) async {
    var url =
        Uri.parse(AppConstants.LOCAL_URL + AppConstants.getusermasterreport);
    Map<String, String> headers = {"Content-Type": "application/json"};

    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> getUserwiseReportid(dynamic json) async {
    var url =
        Uri.parse(AppConstants.LOCAL_URL + AppConstants.getusermasterreportid);
    Map<String, String> headers = {"Content-Type": "application/json"};

    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> getdatewiselist(dynamic json) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.dateWiseReport);
    Map<String, String> headers = {"Content-Type": "application/json"};

    // Ensure you include the body in the POST request
    var response = await http
        .post(url, headers: headers, body: jsonEncode(json))
        .timeout(const Duration(seconds: timeOutDuration));

    return response;
  }

  static Future<http.Response> getmonthwiselist(dynamic json) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.monthWiseReport);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http
        .post(
          url,
          headers: headers,
          body: json,
        )
        .timeout(const Duration(seconds: timeOutDuration));

    return response;
  }

  static Future<http.Response> getAllUserWiseReport(
      Map<String, dynamic> json) async {
    var url =
        Uri.parse(AppConstants.LOCAL_URL + AppConstants.allUserWiseReport);
    Map<String, String> headers = {"Content-Type": "application/json"};
    String body = jsonEncode(json);
    var response = await http
        .post(
          url,
          headers: headers,
          body: body,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static getCourseReport(Map<String, String> body) {}
}
